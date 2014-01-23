{ BaseModel, BaseCollection } = require 'core/models/base'

IdentityCache = require 'core/models/extensions/identity_cache'

describe 'Relations (Has Many)', ->

  beforeEach ->

    IdentityCache.clear()

    class Todo extends BaseModel

    class TodoCollection extends BaseCollection

      model: Todo

    class Person extends BaseModel

    class PersonCollection extends BaseCollection

      model: Person

    class Project extends BaseModel

      relations: [
        type: 'HasMany'
        key: 'todos'
        collectionType: TodoCollection
        reverseRelation:
          key: 'project'
      ,
        type: 'HasMany'
        key: 'participants'
        linkKey: 'people'
        collectionType: PersonCollection
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

  it 'should use the linkKey instead of the key when provided', ->

    { Project } = @classes

    project = new Project
      links:
        people: '/projects/1/people'

    participants = project.get 'participants'

    participants.should.be.ok

    _.result(participants, 'url').should.equal '/projects/1/people'

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

  it 'should pass the reverseRelation to the collection', ->

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

    todos = project.get 'todos'

    todos.project.should.equal project

    todo = todos.get 1

    todo.collection.project.should.equal project

    otherProject = new Project
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

    todos = otherProject.get 'todos'

    todos.project.should.equal otherProject
