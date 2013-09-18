{ BaseModel, BaseCollection } = require 'core/models/base'

describe 'Relations', ->

  describe 'Has Many', ->

    beforeEach ->

      class TodoCollection extends BaseCollection

      class Project extends BaseModel

        relations: [
          key: 'todos'
          collectionType: TodoCollection
        ]

      @classes = { Project, TodoCollection }

    it 'should set the related attribute as an empty collection by default', ->

      { Project, TodoCollection } = @classes

      project = new Project

      project.get('todos').should.be.an.instanceOf TodoCollection

    it 'should populate the related collection if provided as an array attribute', ->

      { Project, TodoCollection } = @classes

      project = new Project
        todos: [
          id: 1
          name: 'My Todo'
        ,
          id: 2
          name: 'My Other Todo'
        ]

      project.get('todos').should.be.an.instanceOf TodoCollection
      project.get('todos').should.have.length 2

    it 'should use the collection directly if provided as the CollectionType', ->

      { Project, TodoCollection } = @classes

      project = new Project
        todos: new TodoCollection [
          id: 1
          name: 'My Todo'
        ,
          id: 2
          name: 'My Other Todo'
        ,
          id: 3
          name: 'My Third Todo'
        ]

      project.get('todos').should.be.an.instanceOf TodoCollection
      project.get('todos').should.have.length 3

    it 'should use the existing collection when updating', ->

      { Project, TodoCollection } = @classes

      project = new Project

      todos = project.get 'todos'

      project.set
        todos: [
          id: 1
          name: 'My Todo'
        ,
          id: 2
          name: 'My Other Todo'
        ,
          id: 3
          name: 'My Third Todo'
        ]

      todos.should.have.length 3

      project.get('todos').should.equal todos

      project.unset 'todos'

      todos.should.have.length 0

      project.get('todos').should.equal todos



