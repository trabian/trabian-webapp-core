gulp = require 'gulp'
source = require 'vinyl-source-stream'
watchify = require 'watchify'
duration = require 'gulp-duration'
karma = require('karma').server

gulp.task 'test', ->

  karma.start
    frameworks: ['mocha', 'chai']
    # frameworks: ['mocha', 'chai', 'chai-jquery', 'sinon-chai']
    browsers: ['PhantomJS']
    files: [
      'test/helpers/phantomjs-shim.js'
      'dist/bundle.js'
      'dist/react.js'
      'test/gulp-test.coffee'
    ]
    singleRun: true
    coffeePreprocessor:
      options:
        bare: true
        sourceMap: false
    preprocessors:
      'test/**/*.coffee': ['coffee']

gulp.task 'watch', ->

  bundler = watchify
    entries: ['./app/index.coffee']
    extensions: ['.coffee']
    exposeAll: true

  .require './app/index.coffee',
    expose: 'core'

  .transform 'coffeeify'

  rebundle = ->

    bundler.bundle
      debug: true

    .on 'error', (e) ->
      console.error 'Error', e

    .pipe source 'bundle.js'
    .pipe duration 'rebunding bundle'
    .pipe gulp.dest './dist'

  bundler.on 'update', rebundle

  return rebundle()

gulp.task 'default', ['watch']
