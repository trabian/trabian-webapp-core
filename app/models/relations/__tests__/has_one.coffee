{ BaseModel, BaseCollection } = require 'core/models/base'

describe 'Relations (HasOne)', ->

  beforeEach ->

    class Person extends BaseModel

    class Project extends BaseModel

      relations: [
        type: 'HasOne'
        key: 'owner'
        relatedModel: Person
        reverseRelation:
          key: 'project'
      ,
        type: 'HasOne'
        key: 'address'
        linkKey: 'location'
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

  it 'should use the linkKey instead of the key when provided', ->

    { Project } = @classes

    project = new Project
      links:
        location: '/locations/1'

    address = project.get 'address'

    expect(address).to.be.defined

    _.result(address, 'url').should.equal '/locations/1'

  it 'should create the model if the attributes are passed on creation', ->

    { Project, Person } = @classes

    project = new Project
      owner:
        id: 1
        name: 'John Doe'

    owner = project.get 'owner'

    expect(owner).to.be.ok

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

  it 'should create the model if the related link is provided later', ->

    { Project } = @classes

    project = new Project

    owner = project.get 'owner'

    expect(owner).to.be.undefined

    project.set
      links:
        owner: '/people/1'

    owner = project.get 'owner'

    expect(owner).to.be.ok

    _.result(owner, 'url').should.equal '/people/1'

  it 'should provide the reverse relation to the project', ->

    { Project, Person } = @classes

    project = new Project
      owner:
        id: 1
        name: 'John Doe'

    owner = project.get 'owner'

    expect(owner).to.be.ok

    owner.project.should.equal project
