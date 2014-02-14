'use strict'

path = require 'path'

TEST_PORT = 9880

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
        files: [
          'app/**/*.{coffee,js}'
          'development/**/*.{coffee,js}'
          '!app/**/__tests__/**'
        ]
        tasks: ['coffeelint:app', 'browserify:app', 'karma:unit:run']

      karma:
        files: [
          'test/**/*.coffee'
          'app/**/__tests__/**'
        ]
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
            'bower_components/uritemplates/bin/uritemplate.js:uritemplate'
            'bower_components/select2/select2.js:select2'
            'bower_components/backbone.validation/dist/backbone-validation.js:backbone-validation'
            'bower_components/moment/moment.js:moment'
          ]

      app:
        src: []
        dest: '.tmp/app.js'
        options:
          debug: true
          external: ['backbone', 'underscore', 'jquery', 'stickit', 'uritemplate', 'backbone-validation', 'moment', 'select2']

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
            src: [
              '**/*.{coffee,js}'
              '!app/**/__tests__/**'
            ]
            dest: 'core'
            rename: (src, dest) ->

              if dest is 'index.coffee'
                'core.coffee'
              else

                # Rename index.coffee files so they can be referenced externally
                # without the index.coffee. For example, app/views/hello/index
                # will be exposed as app/views/hello.
                dest = dest.replace /\/index\.(\w*)$/, '.$1'
                "core/#{dest}"

          ,
            cwd: 'development'
            src: [
              '**/*.{coffee,js,jade}'
              '!app/**/__tests__/**'
            ]
            dest: 'core/dev'
            rename: (src, dest) ->

              # Rename index.coffee files so they can be referenced externally
              # without the index.coffee. For example, app/views/hello/index
              # will be exposed as app/views/hello.
              dest = dest.replace /\/index\.(\w*)$/, '.$1'
              "core/dev/#{dest}"
          ]

    coffeelint:
      app: [
        'app/**/*.coffee'
        '!app/**/__tests__/**'
      ]
      test:
        files:
          src: [
            'test/**/*.coffee'
            'app/**/__tests__/**/*.coffee'
          ]
        options:
          max_line_length:
            level: 'ignore'

    karma:
      options:
        frameworks: ['mocha', 'chai', 'chai-jquery', 'sinon-chai']
        preprocessors:
          'test/**/*.coffee': ['coffee']
          'app/**/__tests__/**/*.coffee': ['coffee']
        reporters: ['spec', 'osx']
        autoWatch: false
        port: TEST_PORT
        browsers: ['PhantomJS']
        coffeePreprocessor:
          options:
            bare: true
            sourceMap: false
        files: [
          'test/helpers/phantomjs-shim.js'
          'test/helpers/react-with-tests.js'
          '.tmp/lib.js'
          '.tmp/app.js'
          'test/index.coffee'
          'test/**/*.coffee'
          'app/**/__tests__/**/*.coffee'
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
    'browserify'
    'karma:unit'
    'watch'
  ]

  # Run the 'test' task by default.
  grunt.registerTask 'default', ['test']
