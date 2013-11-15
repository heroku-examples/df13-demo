assert = require "assert"
supertest = require "supertest"
app = require "../lib/app"

describe "GET /opinion", ->

  it "returns a JSON representation of the opinion", (done) ->
    supertest(app)
      .get("/opinion")
      .expect("Content-Type", /json/)
      .expect(200)
      .end (err, res) ->
        return done(err) if err
        assert res.body.questions
        assert.equal res.body.id, 1

        res.body.questions.map (question) ->
          assert question.question__c

        done()

describe "POST /opinion", ->

  # pg.connect connString, (err, client, finished) ->
  #   return console.error("error running query", err)  if err
  #   client.query "select * from packages where build_id = $1", [id], (err, result) ->
  #     return console.error("error running query", err)  if err
  #     assert.equal 1, result.rows.length
  #     row = result.rows[0]
  #     assert.equal id, row.build_id
  #     assert.deepEqual req.params.package, row.package
  #     finished()
  #     done()

  it "saves opinions", (done) ->

    payload =
      name: "foo"
      version: "0.0.0"
      dependencies:
        bogart: "3"
        express: "1.0.0"

    supertest(app)
      .post("/opinion")
      .send(payload)
      .set('Accept', 'application/json')
      .expect("Content-Type", /json/)
      .expect(200)
      .end (err, res) ->
        return done(err) if err
        assert.equal res.body, request_id
        done()