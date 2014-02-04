{ BaseModel, BaseCollection } = require 'core/models/base'

IdentityCache = require 'core/models/extensions/identity_cache'

describe 'Pagination', ->

  beforeEach ->

    IdentityCache.clear()

    class Project extends BaseModel

    class ProjectCollection extends BaseCollection

      model: Project

    @projects = new ProjectCollection

  it 'should provide a canFetchMore method', ->

    @projects.canFetchMore().should.be.false

    @projects.links =
      next: '/some-next-link'

    @projects.canFetchMore().should.be.true

  it.only 'should have a fetchMore method that calls "fetch" with force=true, remove=false, and the url from the "next" link', ->

    @projects.links =
      next: '/some-next-link'

    @projects.fetch = sinon.spy()

    @projects.fetchMore()

    @projects.fetch.should.have.been.called

    options = @projects.fetch.firstCall.args[0]

    options.force.should.be.true
    options.remove.should.be.false
    options.url.should.equal '/some-next-link'
