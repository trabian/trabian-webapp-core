{ BaseModel, BaseCollection } = require 'core/models/base'

IdentityCache = require 'core/models/extensions/identity_cache'

describe 'Identity map', ->

  beforeEach ->

    IdentityCache.clear()

    class Project extends BaseModel

    class ProjectCollection extends BaseCollection

      model: Project

    @classes = { Project, ProjectCollection }

  describe '_prepareModel', ->

    it 'should use the idAttribute even if the model needs to be parsed first', ->

      class Project extends BaseModel

        idAttribute: 'nestedId'

        parse: (resp) ->
          nestedId: resp.nested.id

      class ProjectCollection extends BaseCollection

        model: Project

      projects = new ProjectCollection

      projects._prepareModel
        nested:
          id: 3

      cache = IdentityCache.getOrCreate Project

      expect(cache[3]).to.be.ok

  describe 'collection.add', ->

    it 'should use the same model', ->

      { ProjectCollection } = @classes

      projectCollection = new ProjectCollection

      projectCollection.add
        id: 1
        name: 'Testing'

      project = projectCollection.get 1

      otherProjectCollection = new ProjectCollection

      otherProjectCollection.add
        id: 1
        name: 'Testing'

      sameProject = otherProjectCollection.get 1

      project.should.equal sameProject

    it 'should handle adding an existing model', ->

      { Project, ProjectCollection } = @classes

      projectCollection = new ProjectCollection

      project = new Project

      projectCollection.should.have.length 0

      projectCollection.add project

      projectCollection.should.have.length 1

      project.collection.should.equal projectCollection

    it 'should handle adding a model via attributes', ->

      { Project, ProjectCollection } = @classes

      projectCollection = new ProjectCollection

      project = projectCollection._prepareModel
        name: 'New Model'

      project.get('name').should.equal 'New Model'

  describe 'clear', ->

    it 'should be able to clear the cache', ->

      { ProjectCollection } = @classes

      projectCollection = new ProjectCollection

      projectCollection.add
        id: 1
        name: 'Testing'

      project = projectCollection.get 1

      IdentityCache.clear()

      otherProjectCollection = new ProjectCollection

      otherProjectCollection.add
        id: 1
        name: 'Testing'

      sameProject = otherProjectCollection.get 1

      project.should.not.equal sameProject
