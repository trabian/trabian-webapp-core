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

  describe 'default links', ->

    it 'should support default links', ->

      class Task extends BaseModel

        defaultLinks:
          settings: '/settings'

      class TaskCollection extends BaseCollection

        model: Task

        defaultLinks:
          project: '/project'

      task = new Task

      task.findLink('settings').should.equal '/settings'

      taskCollection = new TaskCollection

      taskCollection.getLink('project').should.equal '/project'

    it 'should prefer links if provided', ->

      class Task extends BaseModel

        defaultLinks:
          settings: '/settings'

      class TaskCollection extends BaseCollection

        model: Task

        defaultLinks:
          project: '/project'

      task = new Task

      task.set task.parse
        links:
          settings: '/custom-settings-url'

      task.getLink('settings').should.equal '/custom-settings-url'

      tasks = new TaskCollection

      tasks.set tasks.parse
        links:
          project: '/custom-project-url'

      tasks.getLink('project').should.equal '/custom-project-url'

    it 'should support default links as functions', ->

      class Task extends BaseModel

        defaultLinks:
          settings: -> "/tasks/#{@id}/settings"

      class TaskCollection extends BaseCollection

        model: Task

        defaultLinks:
          project: -> "/#{@length}/project"

      task = new Task
        id: 1

      task.findLink('settings').should.equal '/tasks/1/settings'

      taskCollection = new TaskCollection [
        id: 1
      ,
        id: 2
      ]

      taskCollection.getLink('project').should.equal '/2/project'

