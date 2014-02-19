{ BaseModel, BaseCollection } = require 'core/models/base'

describe 'Base model', ->

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

  describe 'mixins', ->

    it 'should extend the prototype with properties added by the mixin', ->

      sampleMixin =

        newProperty: 'test'
        newMethod: -> 'Some new method'

      class Project extends BaseModel

        @mixin sampleMixin

        console.warn ''

      _.keys(Project.prototype).should.include 'newProperty'
      _.keys(Project.prototype).should.include 'newMethod'

    it 'should merge relations', ->

      class Person extends BaseModel

      sampleMixin =

        newProperty: 'test'

        relations: [
          type: 'HasOne'
          key: 'assignee'
          relatedModel: Person
        ]

      class Project extends BaseModel

        relations: [
          type: 'HasOne'
          key: 'owner'
          relatedModel: Person
        ]

        @mixin sampleMixin

      relations = Project.prototype.relations

      relations.should.have.length 2

      class Task extends BaseModel

        @mixin sampleMixin

      relations = Task.prototype.relations

      relations.should.have.length 1

    it 'should merge validation', ->

      sampleMixin =

        newProperty: 'test'

        validation:
          name:
            required: true

      class Project extends BaseModel

        validation:
          date:
            required: true

        @mixin sampleMixin

      validation = Project.prototype.validation

      _.keys(validation).should.include 'date'
      _.keys(validation).should.include 'name'

      class Task extends BaseModel

        @mixin sampleMixin

      validation = Task.prototype.validation

      _.keys(validation).should.not.include 'date'
      _.keys(validation).should.include 'name'

    it 'should merge defaults', ->

      sampleMixin =

        defaults:
          name: 'Sample'

      class Project extends BaseModel

        defaults:
          date: 'now'

        @mixin sampleMixin

      defaults = Project.prototype.defaults

      _.keys(defaults).should.include 'date'
      _.keys(defaults).should.include 'name'

      class Task extends BaseModel

        @mixin sampleMixin

      defaults = Task.prototype.defaults

      _.keys(defaults).should.not.include 'date'
      _.keys(defaults).should.include 'name'

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
