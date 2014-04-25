{ BaseModel, BaseCollection } = require 'core/models/base'

IdentityCache = require 'core/models/extensions/identity_cache'

describe 'Base model', ->

  describe '@findOrCreate', ->

    beforeEach ->

      IdentityCache.clear()

    it 'should return from the identity cache if record is present', ->

      class Project extends BaseModel

      project = new Project
        id: 1

      cache = IdentityCache.getOrCreate Project

      cache[1] = project

      Project.findOrCreate(id: 1).should.equal project

    it 'should return a new model if the cache has no record', ->

      class Project extends BaseModel

      cache = IdentityCache.getOrCreate Project

      Project.findOrCreate(id: 1).get('id').should.equal 1

  describe 'parse', ->

    beforeEach ->

      class Project extends BaseModel

        resourceName: 'projects'

      @project = new Project

    it 'should look for a single-element array scoped by the resourceName of the model', ->

      parsedData = @project.parse
        projects: [
          id: 1
          name: 'Test Name'
        ]

      parsedData.should.deep.equal
        id: 1
        name: 'Test Name'

    it 'should fall back to looking for data at data["resourceName"]', ->

      parsedData = @project.parse
        data:
          projects:
            id: 1
            name: 'Test Name'

      parsedData.should.deep.equal
        id: 1
        name: 'Test Name'

    it 'should handle the case where a non-scoped response is parsed (for instance, when being parsed by the collection)', ->

      parsedData = @project.parse
        id: 1
        name: 'Test Name'

      parsedData.should.deep.equal
        id: 1
        name: 'Test Name'

    it "shouldn't bomb on empty data", ->

      parsedData = @project.parse()

      expect(parsedData).to.be.undefined

  describe 'event extensions', ->

    it 'should support onAndTrigger', (done) ->

      class Project extends BaseModel

      project = new Project

      project.onAndTrigger 'someEvent', ->
        done()

    it 'should support listenToAndTrigger', (done) ->

      class Project extends BaseModel

      class Todo extends BaseModel

      project = new Project

      todo = new Todo

      project.listenToAndTrigger todo, 'someEvent', ->
        this.should.equal project
        done()

  describe 'sync', ->

    beforeEach ->
      sinon.spy Backbone, 'sync'

    afterEach ->
      Backbone.sync.restore()

    it 'should pass add the method to the "options" object', ->

      class Project extends BaseModel

        url: '/test'

      project = new Project

      project.sync 'create', project, {}

      options = Backbone.sync.getCall(0).args[2]

      options.syncMethod.should.equal 'create'

  describe 'validation', ->

    it 'should support validation', ->

      class Project extends BaseModel

        validation:
          name:
            required: true

      project = new Project

      project.isValid(true).should.be.false

      project.set
        name: 'a name'

      project.isValid(true).should.be.true

describe 'Base collection', ->

  describe 'parse', ->

    beforeEach ->

      class Project extends BaseModel

        resourceName: 'projects'

      class ProjectCollection extends BaseCollection

        resourceName: 'projects'

        model: Project

      @projects = new ProjectCollection

    it 'should look for an array scoped by the resourceName of the collection', ->

      parsedData = @projects.parse
        projects: [
          id: 1
          name: 'Project 1'
        ,
          id: 2
          name: 'Project 2'
        ]

      parsedData.should.have.length 2

      parsedData[0].should.deep.equal
        id: 1
        name: 'Project 1'

      parsedData[1].should.deep.equal
        id: 2
        name: 'Project 2'

    it 'should fall back to a non-scoped array', ->

      parsedData = @projects.parse [
        id: 1
        name: 'Project 1'
      ,
        id: 2
        name: 'Project 2'
      ]

      parsedData.should.have.length 2

      parsedData[0].should.deep.equal
        id: 1
        name: 'Project 1'

      parsedData[1].should.deep.equal
        id: 2
        name: 'Project 2'

  describe 'resourceName', ->

    it 'should inherit from the model if not overridden', ->

      class Project extends BaseModel

        resourceName: 'projects'

      class ProjectCollection extends BaseCollection

        model: Project

      (new ProjectCollection).resourceName().should.equal 'projects'

    it 'should use a static property if provided', ->

      class Project extends BaseModel

        resourceName: 'projects'

      class ProjectCollection extends BaseCollection

        resourceName: 'myProjects'

        model: Project

      (new ProjectCollection).resourceName.should.equal 'myProjects'

  describe 'url', ->

    it "should use the model's urlRoot if not overridden", ->

      class Project extends BaseModel

        urlRoot: '/projects'

      class ProjectCollection extends BaseCollection

        model: Project

      (new ProjectCollection).url().should.equal '/projects'

  describe 'build', ->

    beforeEach ->

      class Project extends BaseModel

        url: '/projects'

      class ProjectCollection extends BaseCollection

        model: Project

      @projects = new ProjectCollection

      @projectClass = Project

      @server = sinon.fakeServer.create()

      @server.respondWith /\/projects/, (req) ->
        req.respond 200, { "Content-Type": "application/json" }, JSON.stringify
          data: {}

    afterEach ->

      @server.restore()

    it 'should build an empty instance of a model by default', ->

      @projects.build().should.be.an.instanceof @projectClass

    it 'should set attributes if given', ->

      @projects.build
        anAttr: 'aValue'
      .get('anAttr').should.equal 'aValue'

    it 'should add the element to the collection on sync', (done) ->

      project = @projects.build
        anAttr: 'aValue'

      project.save().then =>

        @projects.length.should.equal 1

        @projects.first().should.equal project

        @projects.first().get('anAttr').should.equal 'aValue'

        done()

      @server.respond()

    it "shouldn't duplicate an element if saved twice", (done) ->

      project = @projects.build()

      project.save().then =>

        project.save().then =>

          @projects.length.should.equal 1

          done()

      @server.respond()


  describe 'fetch', ->

    beforeEach ->

      class Project extends BaseModel

        urlRoot: '/projects'

      class ProjectCollection extends BaseCollection

        model: Project

      @projects = new ProjectCollection

      @classes = { Project, ProjectCollection }

    it 'should hit the backend by default', (done) ->

      @projects.sync = ->
        done()

      @projects.fetch()

    describe 'synced collection', ->

      beforeEach ->

        @projects.beginSync()
        @projects.finishSync()

      it 'should not hit the backend if the collection is already synced', (done) ->

        @projects.fetch().done ->
          done()

      it 'should hit the backend if forced to do so', (done) ->

        @projects.sync = ->
          done()

        @projects.fetch
          force: true

  describe 'event extensions', ->

    it 'should support onAndTrigger', (done) ->

      class ProjectCollection extends BaseCollection

      projectCollection = new ProjectCollection

      projectCollection.onAndTrigger 'someEvent', ->
        done()

    it 'should support listenToAndTrigger', (done) ->

      class ProjectCollection extends BaseCollection

      class Todo extends BaseModel

      projectCollection = new ProjectCollection

      todo = new Todo

      projectCollection.listenToAndTrigger todo, 'someEvent', ->
        this.should.equal projectCollection
        done()
