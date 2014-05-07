gulp = require 'gulp'
source = require 'vinyl-source-stream'
watchify = require 'watchify'
duration = require 'gulp-duration'
_ = require 'underscore'
karma = require('karma').server
glob = require 'glob'
gutil = require 'gulp-util'

bundle = require './development/gulp/bundle'

gulp.task 'build:tests', ->

  testFiles = glob.sync './app/**/__tests__/**/*.{js,coffee}'
  testFiles.unshift './test/index.coffee'

  bundle
    entries: testFiles
    out: 'tests.js'
    watch: !! gutil.env.watch
    debug: true

gulp.task 'test', ['build:tests'], ->

  watch = !! gutil.env.watch

  karma.start
    frameworks: ['mocha', 'chai', 'chai-jquery', 'sinon-chai']
    browsers: ['PhantomJS']
    autoWatch: watch
    singleRun: not watch
    files: [
      'test/helpers/phantomjs-shim.js'
      'dist/tests.js'
    ]
    preprocessors:
      'dist/tests.js': ['sourcemap']

gulp.task 'default', ['test']
