assert = require "assert"
supertest = require "supertest"
app = require "../lib/app"

describe "GET /survey", ->

  it "returns a JSON representation of the survey", (done) ->
    supertest(app)
      .get("/survey")
      .expect("Content-Type", /json/)
      .expect(200)
      .end (err, res) ->
        return done(err) if err
        assert res.body.questions
        assert.equal res.body.id, 1

        res.body.questions.map (question) ->
          assert question.question__c

        done()