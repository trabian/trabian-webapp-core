gulp = require 'gulp'
source = require 'vinyl-source-stream'
watchify = require 'watchify'
duration = require 'gulp-duration'
_ = require 'underscore'
karma = require('karma').server
glob = require 'glob'

browserifyOptions =
  extensions: ['.coffee']

gulp.task 'test', ->

  karma.start
    frameworks: ['mocha', 'chai', 'chai-jquery', 'sinon-chai']
    browsers: ['PhantomJS']
    files: [
      'test/helpers/phantomjs-shim.js'
      'dist/tests.js'
    ]
    autoWatch: true
    singleRun: false

gulp.task 'test-build', ->

  # testFiles = glob.sync './app/**/__tests__/*.{js,coffee}'

  opts = _
    entries: [
      './test/index.coffee'
      './app/components/__tests__/react-test.coffee'
      './app/components/bootstrap/dropdown/__tests__/dropdown-item-test.coffee'
    ]
  .defaults browserifyOptions

  bundler = watchify opts

  rebundle = ->

    bundler.bundle
      debug: true

    .on 'error', (e) ->
      console.error 'Error', e

    .pipe source 'tests.js'
    .pipe duration 'rebunding bundle'
    .pipe gulp.dest './dist'

  bundler.on 'update', rebundle

  return rebundle()

gulp.task 'default', ['test-build']
