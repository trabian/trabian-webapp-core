FakeServer = require 'core/dev/lib/server'

describe 'FakeServer', ->

  afterEach ->
    @server?.restore()

  describe 'GET requests', ->

    it 'should support passing the response as an object directly', (done) ->

      @server = new FakeServer
        delay: 0
        responses: (server) ->
          server.get '/test',
            testing: 'this'

      $.get('/test').done (data) ->

        data.should.deep.equal
          testing: 'this'

        done()

    it 'should support passing the response as a function', (done) ->

      @server = new FakeServer
        delay: 0
        responses: (server) ->

          server.get '/test', (req) ->

            response = JSON.stringify
              testing: 'this'

            req.respond 200, { 'Content-Type': 'application/json' }, response

      $.get('/test').done (data) ->

        data.should.deep.equal
          testing: 'this'

        done()

    it 'should support :params in path', (done) ->

      @server = new FakeServer
        delay: 0
        responses: (server) ->

          server.get '/test/:id', (req, params) ->

            req.respond
              id: params.id

      $.get('/test/23').done (data) ->

        data.should.deep.equal
          id: '23'

        done()

    it 'should support query params in path', (done) ->

      @server = new FakeServer
        delay: 0
        responses: (server) ->

          server.get '/test/:id', (req, params) ->

            req.respond
              id: params.id
              name: params.name

      $.get('/test/23?name=test').done (data) ->

        data.should.deep.equal
          id: '23'
          name: 'test'

        done()

  it 'should support adding POST responses', (done) ->

    @server = new FakeServer
      delay: 0
      responses: (server) ->
        server.post '/test',
          id: 1

    $.post('/test').done (data) ->

      data.should.deep.equal
        id: 1

      done()
