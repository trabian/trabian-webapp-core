{ BaseModel, BaseCollection } = require 'core/models/base'

IdentityCache = require 'core/models/extensions/identity_cache'

describe 'Compound documents', ->

  beforeEach ->

    IdentityCache.clear()

    class Todo extends BaseModel

    class TodoCollection extends BaseCollection

      model: Todo

      resourceName: 'todos'

      url: '/todos'

    class Project extends BaseModel

      resourceName: 'projects'

      relations: [
        type: 'HasMany'
        key: 'todos'
        collectionType: TodoCollection
      ]

    class ProjectCollection extends BaseCollection

      model: Project

    @classes = { Project, ProjectCollection, TodoCollection }

  describe 'Single level', ->

    beforeEach ->

      { ProjectCollection, TodoCollection } = @classes

      @projects = new ProjectCollection

      data =
        links:
          'projects.todos': '/todos/{projects.todos}'
        projects: [
          id: 1
          name: 'My Project'
          links:
            todos: [2, 4]
        ,
          id: 2
          name: 'My Other Project'
          links:
            todos: [1, 3, 4]
        ]
        todos: [
          id: 1
          title: 'Todo #1'
        ,
          id: 2
          title: 'Todo #2'
        ,
          id: 3
          title: 'Todo #3'
        ,
          id: 4
          title: 'Todo #4'
        ]

      @projects.set @projects.parse data

      @project = @projects.get 1

      @todos = @project.get 'todos'

    it 'should create an empty collection by default', ->

      @todos.should.have.length 0

    it 'should have related models', ->

      models = @project._getResourceArray 'todos'

      expect(models).to.be.ok

      models.should.have.length 4

    it 'should be able to load only the models linked to this project', ->

      todoObjects = @project.loadRelatedObjects 'todos'

      todoObjects.should.have.length 2

    it 'should load the collection on fetch without hitting the API', (done) ->

      @todos.fetch().done =>

        @todos.should.have.length 2

        @todos.isSynced().should.be.true

        done()

    it 'should hit the API if forced to do so', (done) ->

      @todos.sync = ->
        done()

      @todos.fetch
        force: true

  describe 'Nested sets', ->

    beforeEach ->

      { Project, ProjectCollection, TodoCollection } = @classes

      Project::relations.push
        type: 'HasMany'
        key: 'children'
        collectionType: ProjectCollection

      @projects = new ProjectCollection

      data =
        links:
          "projects.children": '/projects/{projects.id}/children'
        projects: [
          id: 1
          name: 'My Project'
          links:
            children: [2, 3]
        ,
          id: 2
          name: 'Project #2'
        ,
          id: 3
          name: 'Project #3'
          links:
            children: [4]
        ,
          id: 4
          name: 'Project #4'
        ]

      @projects.set @projects.parse data

      @project = @projects.get 1

      @children = @project.get 'children'

    it 'should create an empty collection by default', ->

      @children.should.have.length 0

    it 'should have related models', ->

      models = @project._getResourceArray 'projects'

      expect(models).to.be.ok

      models.should.have.length 4

    it 'should be able to load only the models linked to this project', ->

      childObjects = @project.loadRelatedObjects 'children'

      childObjects.should.have.length 2

    it 'should load the collection on fetch without hitting the API', (done) ->

      @children.fetch().done =>

        @children.should.have.length 2

        @children.isSynced().should.be.true

        done()

    it 'should load the collection at lower levels', (done) ->

      @children.fetch().done =>

        child = @children.get 3

        grandChildren = child.get 'children'

        grandChildren.should.have.length 0

        grandChildren.fetch().done ->

          grandChildren.should.have.length 1

          done()
