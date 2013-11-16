pg = require("pg")
pgConfig = require("./pg-config")()
async = require("async")
sanitize = require("validator").sanitize

module.exports =

  getAllOpinions: (cb) ->
    pg.connect pgConfig, (err, client, done) ->
      throw err if err

      client.query "SELECT description__c, sfid FROM opinion__c where sync_to_mobile_app__c = true;", (err, result) ->
        done()
        throw err if err
        cb(result.rows)

  getOpinion: (sfid, cb) ->
    opinion = {}
    pg.connect pgConfig, (err, client, done) ->
      throw err if err

      q = "SELECT description__c, sfid FROM opinion__c where sfid='#{sfid}' LIMIT 1;"
      client.query q, (err, result) ->
        done()
        throw err if err
        opinion.description = result.rows[0].description__c
        opinion.caffeinated = true; #opinion.description.match(/coffee|cafe/ig)
        opinion.sfid = result.rows[0].sfid

        q = """
          select name, question__c, sfid, response_type__c, opinion_del__c
          from opinion_question__c where opinion_del__c='#{sfid}';
        """

        client.query q, (err, result) ->
          done()
          throw err if err
          opinion.questions = result.rows

          client.query "select answer__c, opinion_question__c, sfid from opinion_question_answer__c;", (err, result) ->
            done()
            throw err if err

            opinion.questions = opinion.questions.map (question) ->
              question.answers = result.rows.filter (answer) ->
                answer.opinion_question__c is question.sfid
              return question

            cb(opinion)

  saveOpinion: (opinion, cb) ->


    # Watch out for XSS
    for key, value of opinion
      opinion[key] = sanitize(value).xss() unless typeof(value) is "object"

    for key, value of opinion.questions
      opinion.questions[key] = sanitize(value).xss()

    # Save respondent info
    pg.connect pgConfig, (err, client, done) ->
      throw err if err

      respondent_query = """
        INSERT INTO opinion_respondent__c (
          opinion__c,
          opinion_completed_location__latitude__s,
          opinion_completed_location__longitude__s
        ) VALUES (
          '#{opinion.id}',
          '#{opinion.latitude}',
          '#{opinion.longitude}'
        ) returning id;
      """

      client.query respondent_query, (err, result) ->
        done()
        return cb(err) if err
        return cb(null, result)

        # Save responses
        questions = ({qid: k, response: v} for k,v of opinion.questions)
        async.map questions
        ,
          (question, callback) ->
            question_query = """
              INSERT INTO opinion_question_response__c (
                opinion_question__c,
                response_option__c
              ) VALUES (
                '#{question.qid}',
                '#{question.response}'
              ) returning id;
            """
            client.query question_query, (err, result) ->
              done()
              return cb(err) if err
              callback(err, result)
        ,
          (err, results) ->
            cb(null, results)
