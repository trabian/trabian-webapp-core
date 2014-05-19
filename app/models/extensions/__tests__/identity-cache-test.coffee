{ BaseModel, BaseCollection } = require 'core/models/base'

IdentityCache = require 'core/models/extensions/identity_cache'

describe 'Identity cache', ->

  beforeEach ->

    IdentityCache.clear()

  it 'should return separate caches for classes of the same name', ->

    class A extends BaseModel

    cache1 = IdentityCache.getOrCreate A

    class A extends BaseModel

    cache2 = IdentityCache.getOrCreate A

    cache1.should.not.equal cache2

    cache3 = IdentityCache.getOrCreate A

    cache2.should.equal cache3

    class B extends A

      @CACHE_KEY: 'B'

    cache4 = IdentityCache.getOrCreate B

    cache4.should.not.equal cache3


