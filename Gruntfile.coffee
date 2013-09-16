'use strict'

path = require 'path'

module.exports = (grunt) ->

  # Load all grunt tasks from modules beginning with grunt-*. This leverages
  # the naming convention used by almost all grunt plugins.
  require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks

  grunt.initConfig

    # Watch the specified files and run the specified tasks when any of those
    # files change.
    watch:

      options:
        spawn: false # This reuses the same process, speeding up task running

      # Watch all app-related .js and .coffee files and regenerate app.js as
      # needed. If any other extensions are used, add them in the 'files'
      # expression below.
      browserify:
        files: ['app/**/*.{coffee,js}']
        tasks: ['coffeelint:app', 'browserify:app', 'karma:unit:run']

      karma:
        files: ['test/**/*.coffee']
        tasks: ['coffeelint:test', 'karma:unit:run']

    bower:
      install:
        options:
          copy: false

    # Remove generated files from public/generated
    clean:
      js: '.tmp'

    # Convert CommonJS source files to browser-ready .js files.
    browserify:

      # Libraries that need to be available to the app via CommonJS but don't
      # need to be rebuilt on a regular basis.
      lib:
        src: []
        dest: '.tmp/lib.js'
        options:
          alias: [
            'bower_components/underscore/underscore.js:underscore'
            'bower_components/backbone/backbone.js:backbone'
            'bower_components/backbone.stickit/backbone.stickit.js:stickit'
            'bower_components/jquery/jquery.js:jquery'
            'bower_components/bootstrap-sass/dist/js/bootstrap.js:bootstrap'
          ]

      app:
        src: []
        dest: '.tmp/app.js'
        options:
          debug: true
          external: ['backbone', 'underscore', 'jquery', 'bootstrap', 'stickit']

          # Chaplin needs the ability to reference modules within the app, so
          # it needs to be included in the same .js file as the app. For
          # example, the Chaplin dispatcher finds the correct controller class
          # for a route by requiring app/controllers/{controller_name}.
          alias: [
            'bower_components/chaplin/chaplin.js:chaplin'
          ]

          # Allow direct module reference to any files with the following
          # extensions.
          extensions: [
            '.js', '.coffee'
          ]

          # Transform .coffee files into their javascript equivalents.
          transform: [
            'coffeeify'
          ]

          # Alias all modules within client/app to the 'app' namespace. For
          # example, require('app/controllers/hello') will reference
          # 'client/app/controllers/hello'. Without this all references within
          # the app would need to be relative.
          aliasMappings: [
            cwd: 'app'
            src: ['**/*.{coffee,js}']
            dest: 'core'
            rename: (src, dest) ->

              # Rename index.coffee files so they can be referenced externally
              # without the index.coffee. For example, app/views/hello/index
              # will be exposed as app/views/hello.
              dest = dest.replace /\/index\.(\w*)$/, '.$1'
              "core/#{dest}"
          ]

    coffeelint:
      app: ['app/**/*.coffee']
      test:
        files:
          src: [
            'test/**/*.coffee'
          ]
        options:
          max_line_length:
            level: 'ignore'

    karma:
      options:
        frameworks: ['mocha', 'chai', 'chai-jquery', 'sinon-chai']
        preprocessors:
          'test/**/*.coffee': ['coffee']
        reporters: ['spec', 'osx']
        autoWatch: false
        browsers: ['PhantomJS']
        coffeePreprocessor:
          options:
            bare: true
            sourceMap: false
        files: [
          '.tmp/lib.js'
          '.tmp/app.js'
          'test/index.coffee'
          'test/**/*.coffee'
        ]
      unit:
        background: true
        singleRun: false
      single:
        singleRun: true

  # Run the server and watch for changes.
  grunt.registerTask 'server', [
    'build'
    'karma:unit'
    'watch'
  ]

  # Build the .css and .js files.
  grunt.registerTask 'build', [
    'bower:install'
    'clean:js'
    'coffeelint'
    'browserify'
  ]

  grunt.registerTask 'test', [
    'build'
    'karma:single'
  ]

  grunt.registerTask 'test:watch', [
    'karma:unit'
    'watch'
  ]

  # Run the 'server' task by default.
  grunt.registerTask 'default', ['server']
