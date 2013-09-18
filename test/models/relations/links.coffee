{ BaseModel, BaseCollection } = require 'core/models/base'

describe 'Relations links', ->

  beforeEach ->

    class CommentCollection extends BaseCollection

      resourceName: 'comments'

    class TodoCollection extends BaseCollection

      resourceName: 'todos'

      url: '/todos'

    class Person extends BaseModel

      resourceName: 'people'

    class Project extends BaseModel

      resourceName: 'projects'

      relations: [
        type: 'HasMany'
        key: 'todos'
        collectionType: TodoCollection
      ,
        type: 'HasMany'
        key: 'comments'
        collectionType: CommentCollection
      # ,
      #   type: 'HasMany'
      #   key: 'owner'
      #   relatedModel: Person
      ]

    class ProjectCollection extends BaseCollection

      model: Project

    @classes = { Project, ProjectCollection, TodoCollection }

  describe 'HasMany relationships', ->

    it 'should provide the links to the related model', ->

      { Project, TodoCollection } = @classes

      project = new Project

      data =
        projects: [
          id: 1
          name: 'My Project'
          links:
            todos: '/projects/1/todos'
        ]

      project.set project.parse data

      url = _.result project.get('todos'), 'url'

      url.should.equal '/projects/1/todos'

    it 'should provide the links to the related models when provided in each model in the collection', ->

      { ProjectCollection, TodoCollection } = @classes

      projects = new ProjectCollection

      data =
        projects: [
          id: 1
          name: 'My Project'
          links:
            todos: '/projects/1/todos'
        ,
          id: 2
          name: 'My Other Project'
        ]

      projects.set projects.parse data

      todos = projects.first().get 'todos'

      url = _.result todos, 'url'

      url.should.equal '/projects/1/todos'

    it 'should provide the links to the related models when provided as a URL template', ->

      { ProjectCollection, TodoCollection } = @classes

      projects = new ProjectCollection

      data =
        links:
          "projects.todos": '/projects/{projects.id}/todos?key={projects.key}'
          "projects.comments": '/projects/{projects.id}/comments'
        projects: [
          id: 3
          name: 'My Project'
          key: 'test'
        ,
          id: 2
          name: 'My Other Project'
        ]

      projects.set projects.parse data

      project = projects.first()

      checkRelationUrl = (relation, expectedUrl) ->

        collection = project.get relation

        url = _.result collection, 'url'

        url.should.equal expectedUrl

      checkRelationUrl 'todos', '/projects/3/todos?key=test'
      checkRelationUrl 'comments', '/projects/3/comments'

      project.set
        id: 15
        key: 'new-key'

      checkRelationUrl 'todos', '/projects/15/todos?key=new-key'

    it 'should handle new models', ->

      { ProjectCollection, TodoCollection } = @classes

      projects = new ProjectCollection

      data =
        links:
          "projects.todos": '/projects/{projects.id}/todos'
        projects: [
          id: 3
          name: 'My Project'
          key: 'test'
        ,
          id: 2
          name: 'My Other Project'
        ]

      projects.set projects.parse data

      projects.add
        id: 4
        name: 'My New Project'

      project = projects.get 4

      url = _.result project.get('todos'), 'url'

      url.should.equal '/projects/4/todos'

    describe 'compound documents', ->

      it 'should handle links as ids', ->

        { ProjectCollection, TodoCollection } = @classes

        projects = new ProjectCollection

        data =
          links:
            "projects.todos": "/todos/{projects.todos}"
          projects: [
            id: 3
            name: 'My Project'
            links:
              todos: ['1', '2']
          ,
            id: 2
            name: 'My Other Project'
          ]

        projects.set projects.parse data

        project = projects.first()

        url = _.result project.get('todos'), 'url'

        url.should.equal '/todos/1,2'

      it 'should handle links as hrefs', ->

        { ProjectCollection, TodoCollection } = @classes

        projects = new ProjectCollection

        data =
          links:
            "projects.todos":
              href: '/projects/{projects.id}/todos'
          projects: [
            id: 3
            name: 'My Project'
          ,
            id: 2
            name: 'My Other Project'
          ]

        projects.set projects.parse data

        project = projects.first()

        url = _.result project.get('todos'), 'url'

        url.should.equal '/projects/3/todos'

      it 'should load compound documents', ->

        { ProjectCollection, TodoCollection } = @classes

        projects = new ProjectCollection

        data =
          links:
            "projects.todos":
              href: '/todos/{projects.todos}'
              type: 'todos'
          projects: [
            id: 1
            name: 'My Project'
            links:
              todos: ['2', '4']
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

        projects.set projects.parse data

        todos = projects.get(1).get 'todos'

        url = _.result todos, 'url'

        url.should.equal '/todos/2,4'

        todos.should.have.length 2
        todos.at(1).get('title').should.equal 'Todo #4'

        otherTodos = projects.get(2).get 'todos'

        url = _.result otherTodos, 'url'

        url.should.equal '/todos/1,3,4'

        otherTodos.should.have.length 3
        otherTodos.at(1).get('title').should.equal 'Todo #3'
