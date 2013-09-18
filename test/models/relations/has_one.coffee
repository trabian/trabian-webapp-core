{ BaseModel, BaseCollection } = require 'core/models/base'

describe 'Relations (HasOne)', ->

  beforeEach ->

    class Person extends BaseModel

    class Project extends BaseModel

      relations: [
        type: 'HasOne'
        key: 'owner'
        relatedModel: Person
      ]

    @classes = { Project, Person }

  it 'should populate the model if provided', ->

    { Project, Person } = @classes

    project = new Project

    expect(project.get 'owner').to.be.undefined


