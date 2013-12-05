glob = require 'glob'

# See docs at https://github.com/brunch/brunch/blob/stable/docs/config.md
exports.config =
  conventions:
    assets: /^app\/assets\//

  # Use AngularJS dependency injection as library management
  modules:
    definition: false
    wrapper: false

  server:
    port: 8888

  files:
    javascripts:
      joinTo:
        'app.js': (file) ->
          # Non-spec scripts are application code
          file.match(/^app\/(?!.+\.spec\.)/)? or
          [
            # Include path to specific scripts. Perfect for building AngularJS
            # modules
          ].indexOf(file) > -1
        # Specs are compiled into another file by themselves
        'spec.js': /^app\/.+\.spec\./
        # Vendor code
        'vendor.js': /^(bower_components|vendor)\/(?!.+\.spec\.)/
      order:
        before: [
          # Essential libraries
          'bower_components/lodash/dist/lodash.js'
          'bower_components/jquery/jquery.js'
          'bower_components/angular/angular.js'
        ]
        # Vendor files
        .concat(glob.sync 'bower_components/**/*.js')
        # Entry point. Put your AngularJS module definition here
        .concat(glob.sync 'app/index.*')
        # Common scripts take precedence
        .concat(glob.sync 'app/common/**/*')

    stylesheets:
      joinTo:
        'app.css': /^app/
        'vendor.css': /^(bower_components|vendor)/

    templates:
      joinTo:
        'templates.js': /^app/

  plugins:

    ## Scripts

    coffeescript:
      # Auto-wrap in self-calling function
      bare: false
