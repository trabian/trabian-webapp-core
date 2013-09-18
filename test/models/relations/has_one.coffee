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

  it 'should not create the model by default', ->

    { Project } = @classes

    project = new Project

    expect(project.get 'owner').to.be.undefined

  it 'should create the model if the related link is provided', ->

    { Project } = @classes

    project = new Project
      links:
        owner: '/people/1'

    owner = project.get 'owner'

    expect(owner).to.be.defined

    _.result(owner, 'url').should.equal '/people/1'

  it 'should create the model if the attributes are passed on creation', ->

    { Project, Person } = @classes

    project = new Project
      owner:
        id: 1
        name: 'John Doe'

    owner = project.get 'owner'

    expect(owner).to.be.defined

    owner.should.be.an.instanceof Person

  it 'should create the model if the attributes are passed later', ->

    { Project, Person } = @classes

    project = new Project

    expect(project.get 'owner').to.be.undefined

    project.set
      owner:
        id: 1
        name: 'John Doe'

    owner = project.get 'owner'

    expect(owner).to.be.defined

    owner.should.be.an.instanceof Person
