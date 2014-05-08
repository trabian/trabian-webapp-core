gulp = require 'gulp'
watchify = require 'watchify'
browserify = require 'browserify'
duration = require 'gulp-duration'
source = require 'vinyl-source-stream'
_ = require 'underscore'

module.exports = (options) ->

  bundleFunction = if options.watch
    watchify
  else
    browserify

  bundler = bundleFunction
    entries: options.entries
    extensions: ['.coffee']

  _(options).defaults
    dist: './dist'

  options.configBrowserify? bundler

  rebundle = ->

    bundler.bundle
      debug: options.debug

    .on 'error', (err) ->
      console.warn 'error', err

    .pipe(source options.out)
    .pipe(duration 'rebunding bundle')
    .pipe(gulp.dest options.dist)

  if options.watch
    bundler.on 'update', rebundle

  rebundle()
