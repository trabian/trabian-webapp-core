{ BaseModel, BaseCollection } = require 'core/models/base'

IdentityCache = require 'core/models/extensions/identity_cache'

describe 'Allow only one', ->

  beforeEach ->

    IdentityCache.clear()

    class Project extends BaseModel

    class ProjectCollection extends BaseCollection

      model: Project

      initialize: ->

        @allowOnlyOne 'current'

        super

    @projects = new ProjectCollection [
      id: 1
      current: true
    ,
      id: 2
      current: false
    ]

  it 'should reset existing "current" attributes when a new one is selected', ->

    @projects.get(1).get('current').should.be.true
    @projects.get(2).get('current').should.be.false

    @projects.get(2).set
      current: true

    @projects.get(1).get('current').should.be.false
    @projects.get(2).get('current').should.be.true

  it 'should trigger the "choose" event when a new one is selected', (done) ->

    @projects.on 'choose:current', (project) ->
      project.id.should.equal 2
      done()

    @projects.get(2).set
      current: true

  it 'should support "chooseForField"', ->

    @projects.chooseForField('current').id.should.equal 1

    @projects.get(2).set
      current: true

    @projects.chooseForField('current').id.should.equal 2

  it 'should support "resetChoice"', ->

    @projects.chooseForField('current').id.should.equal 1

    @projects.resetChoice 'current'

    expect(@projects.chooseForField('current')).to.not.exist
