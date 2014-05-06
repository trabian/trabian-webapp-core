gulp = require 'gulp'
source = require 'vinyl-source-stream'
watchify = require 'watchify'
duration = require 'gulp-duration'
_ = require 'underscore'
karma = require('karma').server
glob = require 'glob'

browserifyOptions =
  extensions: ['.coffee']

gulp.task 'test-run', ->

  karma.start
    frameworks: ['mocha', 'chai', 'chai-jquery', 'sinon-chai']
    browsers: ['PhantomJS']
    files: [
      'test/helpers/phantomjs-shim.js'
      'dist/tests.js'
    ]
    autoWatch: true

gulp.task 'test-build', ->

  testFiles = glob.sync './app/**/__tests__/**/*.{js,coffee}'
  testFiles.unshift './test/index.coffee'

  opts = _
    entries: testFiles
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

gulp.task 'test', ['test-build', 'test-run']
gulp.task 'default', ['test-build']
