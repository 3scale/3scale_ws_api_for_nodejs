assert = require 'assert'

# set keys as environment variables for tests that
# run against the 3scale API or use dummy keys
provider_key = process.env.TEST_3SCALE_PROVIDER_KEY
application_key = process.env.TEST_3SCALE_APP_KEY
application_id = process.env.TEST_3SCALE_APP_ID

trans = [
  { 'app_id': application_id, 'usage': { 'hits': 1 } },
  { 'app_id': application_id, 'usage': { 'hits': 1000 } }
]
report_test = {transactions: trans, provider_key: provider_key}

Client = require('../src/client')

describe 'Integration tests for the 3Scale::Client', ->
  describe 'The authorize method', ->
    it 'should call the callback with a successful response', (done) ->
      client = new Client provider_key
      client.authorize {app_key: application_key, app_id: application_id}, (response) ->
        assert response.is_success()
        done()

    it 'should call the callback with a error response if app_id was wrong', (done) ->
      client = new Client provider_key
      client.authorize {app_key: application_key, app_id: 'ERROR'}, (response) ->
        assert.equal response.is_success(), false
        done()

  describe 'The report method', ->
    it 'should give a success response with the correct params', (done) ->
      client = new Client provider_key
      client.report report_test, (response) ->
        assert response.is_success()
        done()
