{ BaseModel, BaseCollection } = require 'core/models/base'

describe 'findLink', ->

  beforeEach ->

    class Project extends BaseModel

      resourceName: 'projects'

    class ProjectCollection extends BaseCollection

      model: Project

    @classes = { Project, ProjectCollection }

  it 'should find links as direct descendants', ->

    { Project } = @classes

    project = new Project

    data =
      projects: [
        id: 1
        name: 'My Project'
        links:
          todos: '/projects/1/todos'
      ]

    project.set project.parse data

    project.findLink('todos').should.equal '/projects/1/todos'

  it 'should find links from the collection', ->

    { ProjectCollection } = @classes

    projects = new ProjectCollection

    data =
      links:
        'projects.todos': '/projects/{projects.id}/todos'
      projects: [
        id: 1
        name: 'My Project'
      ,
        id: 2
        name: 'My Other Project'
      ]

    projects.set projects.parse data

    project = projects.get 2

    project.findLink('todos').should.equal '/projects/2/todos'

  it 'should find links from the collection when provided as an array', ->

    { ProjectCollection } = @classes

    projects = new ProjectCollection

    data =
      links:
        next: '/next-url'
      data: [
        id: 1
        name: 'My Project'
      ,
        id: 2
        name: 'My Other Project'
      ]

    projects.set projects.parse data

    projects.links.should.be.ok

    projects.getLink('next').should.equal '/next-url'

    data =
      data: [
        id: 3
        name: 'My Third Project'
      ]

    projects.set projects.parse data

    expect(projects.links).to.not.exist
