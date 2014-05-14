describe 'init', ->

  it 'should not load Backbone as a global', ->

    expect(window.Backbone).to.not.exist
