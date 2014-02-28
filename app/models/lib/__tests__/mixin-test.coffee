describe 'classMixin', ->

  it 'should extend the prototype with properties added by the mixin', ->

    sampleMixin =

      newProperty: 'test'
      newMethod: -> 'Some new method'

    class Project extends BaseModel

      @mixin sampleMixin

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

  it 'should merge default links', ->

    sampleMixin =

      defaultLinks:
        task: '/task'

    class Project extends BaseModel

      defaultLinks:
        settings: '/settings'

      @mixin sampleMixin

    defaultLinks = Project.prototype.defaultLinks

    _.keys(defaultLinks).should.include 'settings'
    _.keys(defaultLinks).should.include 'task'

    class Task extends BaseModel

      @mixin sampleMixin

    defaultLinks = Task.prototype.defaultLinks

    _.keys(defaultLinks).should.not.include 'settings'
    _.keys(defaultLinks).should.include 'task'
