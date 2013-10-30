pg = require("pg")
pgConfig = require("./pg-config")()
async = require("async")

module.exports =
  getSurvey: (cb) ->
    survey = {}
    pg.connect pgConfig, (err, client, done) ->
      throw err if err

      client.query "SELECT id FROM survey__c;", (err, result) ->
        done()
        throw err if err
        survey.id = result.rows[0].id

        client.query "select question__c,sfid,response_type__c, survey_del__c from survey_question__c;", (err, result) ->
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
    # return cb(null, survey)
    pg.connect pgConfig, (err, client, done) ->
      throw err if err

      q = """
        INSERT INTO survey_respondent__c (
          survey__c,
          respondent_firstname__c,
          respondent_lastname__c,
          survey_completed_location__latitude__s,
          survey_completed_location__longitude__s
        ) VALUES (
          '#{survey.id}',
          '#{survey.firstname}',
          '#{survey.lastname}',
          '#{survey.latitude}',
          '#{survey.longitude}'
        ) returning id;
      """

      # return cb(err, q.replace(/\n/g, ''))

      client.query q, (err, result) ->
        done()
        return cb(err) if err
        respondent_id = result.rows[0].id
        questions = ({qid: k, response: v} for k,v of survey.questions)

        async.map questions
        ,
          (question, callback) ->
            question_query = """
              INSERT INTO survey_question_response__c (
                survey_question__c,
                response_option__c,
                survey_respondent__c
              ) VALUES (
                '#{question.qid}',
                '#{question.response}',
                '#{respondent_id}'
              ) returning id;
            """
            client.query question_query, (err, result) ->
              done()
              return cb(err) if err
              callback(err, result)
        ,
          (err, results) ->
            cb(null, results)
