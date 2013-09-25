{ BaseModel, BaseCollection } = require 'core/models/base'

describe 'Deferred', ->

  describe 'models', ->

    beforeEach ->

      class Project extends BaseModel

      @project = new Project

      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    it 'should be pending by default', ->

      @project.state().should.equal 'pending'

    it 'should add deferreds to the model', (done) ->

      @project.done -> done()

      @project.resolve()

    it "should resolve the model the first time it's fetched", (done) ->

      @project.done -> done()

      @project.beginSync()

      @project.finishSync()

    it "should resolve the model when fetched", (done) ->

      @project.done -> done()

      @project.url = '/projects/1'

      @server.respondWith /\/projects\/(\d+)/, (req, id) ->

        req.respond 200, { "Content-Type": "application/json" }, JSON.stringify
          projects: [
            id: parseInt id # Use whatever ID is passed
            name: 'My Project'
          ]

      @project.fetch()

      @server.respond()

  describe 'collections', ->

    beforeEach ->

      class Project extends BaseModel

      class ProjectCollection extends BaseCollection

        model: Project

      @projects = new ProjectCollection

      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    it 'should be pending by default', ->

      @projects.state().should.equal 'pending'

    it 'should add deferreds to the collection', (done) ->

      @projects.done -> done()

      @projects.resolve()

    it "should resolve the collection the first time it's fetched", (done) ->

      @projects.done -> done()

      @projects.beginSync()

      @projects.finishSync()

    it "should resolve the collection when fetched", (done) ->

      @projects.done -> done()

      @projects.url = '/projects'

      @server.respondWith "/projects", (req) ->

        req.respond 200, { "Content-Type": "application/json" }, JSON.stringify
          projects: [
            id: 1
            name: 'My Project'
          ]

      @projects.fetch()

      @server.respond()
