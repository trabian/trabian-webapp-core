{ BaseModel, BaseCollection } = require 'core/models/base'

IdentityCache = require 'core/models/extensions/identity_cache'

describe 'Relations links', ->

  beforeEach ->

    IdentityCache.clear()

    class CommentCollection extends BaseCollection

      resourceName: 'comments'

    class Todo extends BaseModel

      resourceName: 'todos'

    class TodoCollection extends BaseCollection

      model: Todo

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
      ,
        type: 'HasOne'
        key: 'owner'
        relatedModel: Person
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

      describe 'compound documents', ->

        it 'should load compound documents on fetch', (done) ->

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

          todos.should.have.length 0

          todos.fetch().done ->

            todos.should.have.length 2
            todos.at(1).get('title').should.equal 'Todo #4'

            otherTodos = projects.get(2).get 'todos'

            url = _.result otherTodos, 'url'

            url.should.equal '/todos/1,3,4'

            otherTodos.fetch().done ->

              otherTodos.should.have.length 3
              otherTodos.at(1).get('title').should.equal 'Todo #3'

              done()

        it 'should load compound documents using the resourceName of the collection', (done) ->

          { ProjectCollection, TodoCollection } = @classes

          projects = new ProjectCollection

          TodoCollection::resourceName = 'tasks'

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
            tasks: [
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

          todos.fetch().done ->

            todos.should.have.length 2

            done()

        describe '(self-referential)', ->

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

          it 'should support first-level children', (done) ->

            children = @projects.get(1).get 'children'

            url = _.result children, 'url'

            url.should.equal '/projects/1/children'

            children.fetch().done ->

              children.should.have.length 2

              done()

          it 'should use the same model as in the parent collection', (done) ->

            children = @projects.get(1).get 'children'

            children.fetch().done =>

              children.get(2).should.equal @projects.get 2

              done()

          describe 'nested children', ->

            beforeEach (done) ->

              children = @projects.get(1).get 'children'

              children.fetch().done =>

                @child = children.get 3

                done()

            it 'should support nested children', (done) ->

              grandChildren = @child.get 'children'

              grandChildren.fetch().done ->

                grandChildren.should.have.length 1

                done()

  describe 'HasOne relationships', ->

    it 'should load the url from the parent', ->

      { Project } = @classes

      project = new Project

      data =
        projects: [
          id: 1
          name: 'My Project'
          links:
            owner: '/people/1'
        ]

      project.set project.parse data

      url = _.result project.get('owner'), 'url'

      url.should.equal '/people/1'

    it 'should load the url from the parent collection', ->

      { ProjectCollection } = @classes

      projects = new ProjectCollection

      data =
        links:
          "projects.owner": "/people/{projects.owner}"
        projects: [
          id: 1
          name: 'My Project'
          links:
            owner: '3'
        ]

      projects.set projects.parse data

      project = projects.first()

      url = _.result project.get('owner'), 'url'

      url.should.equal '/people/3'

      projects.add
        id: 2
        name: 'My Other Project'
        links:
          owner: 5

      project = projects.get 2

      url = _.result project.get('owner'), 'url'

      url.should.equal '/people/5'
