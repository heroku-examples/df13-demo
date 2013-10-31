pg = require("pg")
pgConfig = require("./pg-config")()
async = require("async")
sanitize = require("validator").sanitize

module.exports =

  getAllSurveys: (cb) ->
    pg.connect pgConfig, (err, client, done) ->
      throw err if err

      client.query "SELECT name, sfid FROM survey__c;", (err, result) ->
        done()
        throw err if err
        cb(result.rows)

  getSurvey: (sfid, cb) ->
    survey = {}
    pg.connect pgConfig, (err, client, done) ->
      throw err if err

      q = "SELECT name, sfid FROM survey__c where sfid='#{sfid}' LIMIT 1;"
      client.query q, (err, result) ->
        done()
        throw err if err
        survey.name = result.rows[0].name
        survey.sfid = result.rows[0].sfid

        q = """
          select name, question__c, sfid, response_type__c, survey_del__c
          from survey_question__c where survey_del__c='#{sfid}';
        """

        client.query q, (err, result) ->
          done()
          throw err if err
          survey.questions = result.rows

          client.query "select answer__c, survey_question__c, sfid from survey_question_answer__c;", (err, result) ->
            done()
            throw err if err

            survey.questions = survey.questions.map (question) ->
              question.answers = result.rows.filter (answer) ->
                answer.survey_question__c is question.sfid
              return question

            cb(survey)

  saveSurvey: (survey, cb) ->

    # Watch out for XSS
    # for key, value of survey
    #   survey[key] = sanitize(value).xss() unless typeof(value) is "object"

    # for key, value of survey.questions
    #   survey.questions[key] = sanitize(value).xss()
    # return cb(survey)

    pg.connect pgConfig, (err, client, done) ->
      throw err if err

      respondent_query = """
        INSERT INTO survey_respondent__c (
          survey__c,
          survey_completed_location__latitude__s,
          survey_completed_location__longitude__s
        ) VALUES (
          '#{survey.id}',
          '#{survey.latitude}',
          '#{survey.longitude}'
        ) returning id;
      """

      client.query respondent_query, (err, result) ->
        done()
        return cb(err) if err

        questions = ({qid: k, response: v} for k,v of survey.questions)

        async.map questions
        ,
          (question, callback) ->
            question_query = """
              INSERT INTO survey_question_response__c (
                survey_question__c,
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
