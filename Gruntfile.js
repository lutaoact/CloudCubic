'use strict';

module.exports = function (grunt) {

  // Load grunt tasks automatically, when needed
  require('jit-grunt')(grunt, {
    express: 'grunt-express-server',
    useminPrepare: 'grunt-usemin',
    ngtemplates: 'grunt-angular-templates',
    cdnify: 'grunt-cdnify',
    protractor: 'grunt-protractor-runner',
    injector: 'grunt-asset-injector',
    replace: 'grunt-replace',
    processhtml: 'grunt-processhtml',
    webfont: 'grunt-webfont',
    qiniu: 'grunt-qiniu-deploy'
  });

  var config = {
    cdn: 'http://7u2mnb.com1.z0.glb.clouddn.com/',
    qiniu_ak: '_NXt69baB3oKUcLaHfgV5Li-W_LQ-lhJPhavHIc_',
    qiniu_sk: 'qpIv4pTwAQzpZk6y5iAq14Png4fmpYAMsdevIzlv',
    qiniu_cdn_bucket: 'cloud3cdn',
    randomCdnPath: (new Date()).valueOf()+ '/'
  };

  // Time how long tasks take. Can help when optimizing build times
  require('time-grunt')(grunt);

  // Define the configuration for all the tasks
  grunt.initConfig({
    // Project settings
    yeoman: {
      // configurable paths
      client: require('./bower.json').appPath || 'client',
      dist: 'dist'
    },
    express: {
      options: {
        port: process.env.PORT || 9000
      },
      dev: {
        options: {
          script: 'server/app.js',
          debug: true
        }
      },
      prod: {
        options: {
          script: 'dist/server/app.js'
        }
      }
    },
    open: {
      server: {
        url: 'http://localhost:<%= express.options.port %>'
      }
    },
    watch: {
      injectJS: {
        files: [
        '<%= yeoman.client %>/{app,components}/**/*.js',
        '!<%= yeoman.client %>/{app,components}/**/*.spec.js',
        '!<%= yeoman.client %>/{app,components}/**/*.mock.js',
        '!<%= yeoman.client %>/app/app.js'],
        tasks: ['injector:scripts']
      },
      injectCss: {
        files: [
        '<%= yeoman.client %>/{app,components}/**/*.css'
        ],
        tasks: ['injector:css']
      },
      mochaTest: {
        files: ['server/**/*.spec.js'],
        tasks: ['env:test', 'mochaTest']
      },
      jsTest: {
        files: [
        '<%= yeoman.client %>/{app,components}/**/*.spec.js',
        '<%= yeoman.client %>/{app,components}/**/*.mock.js'
        ],
        tasks: ['newer:jshint:all', 'karma']
      },
      injectLess: {
        files: [
        '<%= yeoman.client %>/{app,components}/**/*.less'],
        tasks: ['injector:less']
      },
      less: {
        files: [
        '<%= yeoman.client %>/{app,components}/**/*.less'],
        tasks: ['less', 'autoprefixer']
      },
      coffee: {
        files: [
        '<%= yeoman.client %>/{app,components}/**/*.{coffee,litcoffee,coffee.md}',
        '!<%= yeoman.client %>/{app,components}/**/*.spec.{coffee,litcoffee,coffee.md}'
        ],
        tasks: ['newer:coffee', 'injector:scripts']
      },
      coffeeServer: {
        files: [
        'server/{*,*/*,*/*/*}.{coffee,litcoffee,coffee.md}'
        ],
        tasks: ['coffee:server']
      },
      coffeeTest: {
        files: [
        '<%= yeoman.client %>/{app,components}/**/*.spec.{coffee,litcoffee,coffee.md}'
        ],
        tasks: ['karma']
      },
      gruntfile: {
        files: ['Gruntfile.js']
      },
      livereload: {
        files: [
        '{.tmp,<%= yeoman.client %>}/{app,components}/**/*.css',
        '{.tmp,<%= yeoman.client %>}/{app,components}/**/*.html',
        '{.tmp,<%= yeoman.client %>}/{app,components}/**/*.js',
        '!{.tmp,<%= yeoman.client %>}{app,components}/**/*.spec.js',
        '!{.tmp,<%= yeoman.client %>}/{app,components}/**/*.mock.js',
        '<%= yeoman.client %>/assets/images/{,*//*}*.{png,jpg,jpeg,gif,webp,svg}'
        ],
        options: {
          livereload: true
        }
      },
      express: {
        files: [
        'server/**/*.{js,json}'
        ],
        tasks: ['express:dev', 'wait'],
        options: {
          livereload: true,
          nospawn: true //Without this option specified express won't be reloaded
        }
      }
    },

    // Make sure code styles are up to par and there are no obvious mistakes
    jshint: {
      options: {
        jshintrc: '<%= yeoman.client %>/.jshintrc',
        reporter: require('jshint-stylish')
      },
      server: {
        options: {
          jshintrc: 'server/.jshintrc'
        },
      src: [ 'server/{,*/}*.js']
    },
    all: [
    '<%= yeoman.client %>/{app,components}/**/*.js',
    '!<%= yeoman.client %>/{app,components}/**/*.spec.js',
    '!<%= yeoman.client %>/{app,components}/**/*.mock.js'
    ],
    test: {
      src: [
      '<%= yeoman.client %>/{app,components}/**/*.spec.js',
      '<%= yeoman.client %>/{app,components}/**/*.mock.js'
      ]
    }
  },

    // Empties folders to start fresh
    clean: {
      dist: {
        files: [{
          dot: true,
          src: [
          '.tmp',
          '<%= yeoman.dist %>/*',
          '!<%= yeoman.dist %>/.git*',
          '!<%= yeoman.dist %>/.openshift',
          '!<%= yeoman.dist %>/Procfile'
          ]
        }]
      },
      server: '.tmp'
    },

    // Add vendor prefixed styles
    autoprefixer: {
      options: {
        browsers: ['last 1 version']
      },
      dist: {
        files: [{
          expand: true,
          cwd: '.tmp/',
        src: '{,*/}*.css',
        dest: '.tmp/'
      }]
    }
  },

    // Debugging with node inspector
    'node-inspector': {
      custom: {
        options: {
          'web-host': 'localhost'
        }
      }
    },

    // Use nodemon to run server in debug mode with an initial breakpoint
    nodemon: {
      debug: {
        script: 'server/app.js',
        options: {
          nodeArgs: ['--debug-brk'],
          env: {
            PORT: process.env.PORT || 9000
          },
          callback: function (nodemon) {
            nodemon.on('log', function (event) {
              console.log(event.colour);
            });

            // opens browser on initial server start
            nodemon.on('config:update', function () {
              setTimeout(function () {
                require('open')('http://localhost:8080/debug?port=5858');
              }, 500);
            });
          }
        }
      }
    },

    // Automatically inject Bower components into the app
    bowerInstall: {
      target: {
        src: '<%= yeoman.client %>/index.html',
        ignorePath: '<%= yeoman.client %>/',
        exclude: [/bootstrap-sass-official/, /bootstrap.js/, /bootstrap.css/, /font-awesome.css/, /videogular.css/ ]
      }
    },

    // Renames files for browser caching purposes
    rev: {
      dist: {
        files: {
          src: [
            '<%= yeoman.dist %>/public/{,*/}*.js',
            '<%= yeoman.dist %>/public/{,*/}*.css',
            '<%= yeoman.dist %>/public/assets/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}',
            '<%= yeoman.dist %>/public/assets/fonts/{,*/}*.*'
          ]
        }
      }
    },

    // Reads HTML for usemin blocks to enable smart builds that automatically
    // concat, minify and revision files. Creates configurations in memory so
    // additional tasks can operate on them
    useminPrepare: {
      html: ['<%= yeoman.client %>/index.html'],
      options: {
        dest: '<%= yeoman.dist %>/public'
      }
    },

    // Performs rewrites based on rev and the useminPrepare configuration
    usemin: {
    html: ['<%= yeoman.dist %>/public/{,*/}*.html'],
  css: ['<%= yeoman.dist %>/public/{,*/}*.css'],
js: ['<%= yeoman.dist %>/public/{,*/}*.js'],
options: {
  assetsDirs: [
  '<%= yeoman.dist %>/public',
  '<%= yeoman.dist %>/public/assets/images'
  ],
        // This is so we update image references in our ng-templates
        patterns: {
          js: [
          [/(assets\/images\/.*?\.(?:gif|jpeg|jpg|png|webp|svg))/gm, 'Update the JS to reference our revved images']
          ]
        }
      }
    },

    // The following *-min tasks produce minified files in the dist folder
    imagemin: {
      dist: {
        files: [{
          expand: true,
          cwd: '<%= yeoman.client %>/assets/images',
        src: '{,*/}*.{png,jpg,jpeg,gif}',
        dest: '<%= yeoman.dist %>/public/assets/images'
      }]
    }
  },

  svgmin: {
    dist: {
      files: [{
        expand: true,
        cwd: '<%= yeoman.client %>/assets/images',
      src: '{,*/}*.svg',
      dest: '<%= yeoman.dist %>/public/assets/images'
    }]
  }
},

    // Allow the use of non-minsafe AngularJS files. Automatically makes it
    // minsafe compatible so Uglify does not destroy the ng references
    ngmin: {
      dist: {
        files: [{
          expand: true,
          cwd: '.tmp/concat',
          src: '*/**.js',
          dest: '.tmp/concat'
        }]
      }
    },

    // Package all the html partials into a single javascript payload
    ngtemplates: {
      options: {
        // This should be the name of your apps angular module
        module: 'budweiserApp',
        // remove htmlmin because it is not compatible with angular
        // htmlmin: {
        //   collapseBooleanAttributes: true,
        //   collapseWhitespace: true,
        //   removeAttributeQuotes: true,
        //   removeEmptyAttributes: true,
        //   removeRedundantAttributes: true,
        //   removeScriptTypeAttributes: true,
        //   removeStyleLinkTypeAttributes: true
        // },
        usemin: 'app/app.js'
      },
      main: {
        cwd: '<%= yeoman.client %>',
        src: ['{app,components}/**/*.html'],
        dest: '.tmp/templates.js'
      },
      tmp: {
        cwd: '.tmp',
        src: ['{app,components}/**/*.html'],
        dest: '.tmp/tmp-templates.js'
      }
    },

    // Replace Google CDN references
    cdnify: {
      dev:{
        options: {
          base: 'http://localhost:9000/'
        },
        files: [{
          expand: true,
          cwd: 'client',
          src: 'index.html',
          dest:'client'
        }]
      },
      mobile: {
        options: {
          base: config.cdn+config.randomCdnPath
        },
        files: [{
          expand: true,
          cwd: 'dist/public/mobile',
          src: ['index.html','**/*.css'],
          dest:'dist/public/mobile'
        }]
      },
      dist: {
        options: {
          base: config.cdn
        },
        files: [{
          expand: true,
          cwd: 'dist/public',
          src: ['index.html','app/**/*.css'],
          dest:'dist/public'
        }]
      }
    },

    qiniu: {
      dist: {
        options: {
          ignoreDup: false,
          accessKey: config.qiniu_ak,
          secretKey: config.qiniu_sk,
          bucket: config.qiniu_cdn_bucket,
          domain: 'http://' + config.qiniu_cdn_bucket + '.qiniudn.com',
          resources: [{
            cwd: 'dist/public',
            pattern: ['app/**/*.*','assets/**/*.*']
          }]
        }
      },
      mobile: {
        options: {
          ignoreDup: false,
          accessKey: config.qiniu_ak,
          secretKey: config.qiniu_sk,
          bucket: config.qiniu_cdn_bucket,
          domain: 'http://' + config.qiniu_cdn_bucket + '.qiniudn.com',
          keyGen: function(cwd, file){
            return config.randomCdnPath+file;
          },
          resources: [{
            cwd: 'dist/public/mobile',
            pattern: ['**/*.*']
          }]
        }
      }
    },

    // Copies remaining files to places other tasks can use
    copy: {
      dist: {
        files: [{
          expand: true,
          dot: true,
          cwd: '<%= yeoman.client %>',
          dest: '<%= yeoman.dist %>/public',
          src: [
            '*.{ico,png,txt}',
            '.htaccess',
            'bower_components/**/*',
            'assets/**/*',
            'mobile/**/*',
            'index.html'
          ]
      }, {
        expand: true,
        cwd: '.tmp/images',
        dest: '<%= yeoman.dist %>/public/assets/images',
        src: ['generated/*']
      }, {
        expand: true,
        dest: '<%= yeoman.dist %>',
        src: [
        'package.json',
        'server/**/*'
        ]
      },{
        expand: true,
        dest: '<%= yeoman.dist %>/public/app',
        cwd: '.tmp/concat/app',
        src: [
        '**/*.js'
        ]
      }]
    },
    styles: {
      expand: true,
      cwd: '<%= yeoman.client %>',
      dest: '.tmp/',
      src: ['{app,components}/**/*.css']
    },
    index:{
      dest: '<%= yeoman.client %>/index.html',
      src: '<%= yeoman.client %>/index.tmpl.html'
    }
  },

    // Run some tasks in parallel to speed up the build process
    concurrent: {
      server: [
      'coffee',
      'less',
      ],
      test: [
      'coffee',
      'less',
      ],
      debug: {
        tasks: [
        'nodemon',
        'node-inspector'
        ],
        options: {
          logConcurrentOutput: true
        }
      },
      dist: [
      'coffee:clientDist',
      'coffee:server',
      'less',
      'imagemin',
      'svgmin'
      ]
    },

    // Test settings
    karma: {
      unit: {
        configFile: 'karma.conf.js',
        singleRun: true
      }
    },

    mochaTest: {
      options: {
        reporter: 'spec'
      },
      src: ['server/**/*.spec.js']
    },

    protractor: {
      options: {
        configFile: 'protractor.conf.js'
      },
      chrome: {
        options: {
          args: {
            browser: 'chrome'
          }
        }
      }
    },

    env: {
      test: {
        NODE_ENV: 'test'
      },
      prod: {
        NODE_ENV: 'production'
      },
      all: require('./server/config/local.env')
    },

    // Compiles CoffeeScript to JavaScript
    coffee: {
      options: {
        sourceRoot: ''
      },
      client: {
        files: [{
          expand: true,
          cwd: 'client',
          src: [
          '{app,components}/**/*.coffee',
          '!{app,components}/**/*.spec.coffee'
          ],
          dest: '.tmp',
          ext:'.js'
          //rename: function (dest, src) {
          //    return dest + '/' + src.replace(/\.coffee$/, '.js');
          //}
        }]
      },
      clientDist: {
        files: [{
          expand: true,
          cwd: 'client',
          src: [
          '{app,components}/**/*.coffee',
          '!{app,components}/**/*.spec.coffee',
          '!{app,components}/**/*.mock.coffee',
          '!app/mock.coffee'
          ],
          dest: '.tmp',
          ext:'.js'
          //rename: function (dest, src) {
          //    return dest + '/' + src.replace(/\.coffee$/, '.js');
          //}
        }]
      },
      server: {
        files: [{
          expand: true,
          cwd: 'server',
          src: [
          '{*,*/*,*/*/*}.{coffee,litcoffee,coffee.md}'
          ],
          dest: 'server',
          rename: function (dest, src) {
            return dest + '/' + src.replace(/\.coffee$/, '.js');
          }
        }]
      }
    },

    // Compiles Less to CSS
    less: {
      options: {
        ieCompat: false,
        paths: [
        '<%= yeoman.client %>/bower_components',
        '<%= yeoman.client %>/app',
        '<%= yeoman.client %>/components'
        ]
      },
      server: {
        files: {
          '.tmp/app/app.css' : '<%= yeoman.client %>/app/app.less'
        }
      },
    },

    injector: {
      options: {

      },
      // Inject application script files into index.html (doesn't include bower)
      scripts: {
        options: {
          transform: function(filePath) {
            filePath = filePath.replace('/client/', '');
            filePath = filePath.replace('/.tmp/', '');
            return '<script src="' + filePath + '"></script>';
          },
          starttag: '<!-- injector:js -->',
          endtag: '<!-- endinjector -->'
        },
        files: {
          '<%= yeoman.client %>/index.html': [
          ['{.tmp,<%= yeoman.client %>}/{app,components}/**/*.js',
          '!{.tmp,<%= yeoman.client %>}/app/app.js',
          '!{.tmp,<%= yeoman.client %>}/{app,components}/**/*.spec.js',
          '!{.tmp,<%= yeoman.client %>}/{app,components}/**/*.mock.js']
          ]
        }
      },

      // Inject component less into app.less
      less: {
        options: {
          transform: function(filePath) {
            filePath = filePath.replace('/client/app/', '');
            filePath = filePath.replace('/client/components/', '');
            return '@import \'' + filePath + '\';';
          },
          starttag: '// injector',
          endtag: '// endinjector'
        },
        files: {
          '<%= yeoman.client %>/app/app.less': [
          '<%= yeoman.client %>/{app,components}/**/*.less',
          '!<%= yeoman.client %>/app/app.less'
          ]
        }
      },

      // Inject component css into index.html
      css: {
        options: {
          transform: function(filePath) {
            filePath = filePath.replace('/client/', '');
            filePath = filePath.replace('/.tmp/', '');
            return '<link rel="stylesheet" href="' + filePath + '">';
          },
          starttag: '<!-- injector:css -->',
          endtag: '<!-- endinjector -->'
        },
        files: {
          '<%= yeoman.client %>/index.html': [
          '<%= yeoman.client %>/{app,components}/**/*.css',
          ]
        }
      }
    },
    replace: {
      dist:{
        options: {
          patterns: [
          {
            match: /budweiserAppDev/g,
            replacement: 'budweiserApp'
          }
          ]
        },
        files: [
        {expand: true, flatten: true, src: ['client/index.html'],dest:'client/'}
        ]
      },
      template:{
        options: {
          patterns: [
          {
            match: /(|\/)assets\//g,
            replacement: config.cdn + 'assets/'
          }
          ]
        },
        files: [
        {expand: true, flatten: true, src: ['.tmp/templates.js'],dest:'.tmp/'}
        ]
      },
      mobile: {
        options: {
          patterns: [
          {
            match: /..\/lib\//g,
            replacement: 'lib/'
          }
          ]
        },
        files: [
        {expand: true, flatten: true, src: ['dist/public/mobile/css/*.css'],dest:'dist/public/mobile/css/'}
        ]
      }
    },
    processhtml: {
      options: {
        data: {
          message: 'Hello world!'
        }
      },
      dist: {
        files: {
          'client/index.html': ['client/index.html']
        }
      }
    },

    // svg to webfont
    webfont: {
      icons: {
        src: '<%= yeoman.client %>/assets/images/vectors/**/*.svg',
        dest: '<%= yeoman.client %>/assets/fonts/bud-font',
        destCss: '<%= yeoman.client %>/app/theme',
        options: {
          font: 'bud-font',
          hashes: false,
          relativeFontPath: '/assets/fonts/bud-font/',
          templateOptions:{
            classPrefix: 'budon-',
            baseClass: "budon"
          },
          stylesheet: 'less'
        }
      }
    }
  });

  // Used for delaying livereload until after server has restarted
  grunt.registerTask('wait', function () {
    grunt.log.ok('Waiting for server reload...');

    var done = this.async();

    setTimeout(function () {
      grunt.log.writeln('Done waiting!');
      done();
    }, 1000);
  });

  grunt.registerTask('express-keepalive', 'Keep grunt running', function() {
    this.async();
  });

  grunt.registerTask('serve', function (target) {
    if (target === 'dist') {
      return grunt.task.run(['build', 'env:all', 'env:prod', 'express:prod', 'open', 'express-keepalive']);
    }

    if (target === 'debug') {
      return grunt.task.run([
        'clean:server',
        'copy:index',
        'env:all',
        'injector:less',
        'concurrent:server',
        'injector',
        'bowerInstall',
        'autoprefixer',
        'concurrent:debug'
        ]);
    }

    if (target === 'mock'){
      return grunt.task.run([
        'clean:server',
        'copy:index',
        'env:all',
        'injector:less',
        'concurrent:server',
        'injector',
        'bowerInstall',
        'autoprefixer',
        'express:dev',
        'wait',
        'open',
        'watch'
        ]);
    }
    grunt.task.run([
      'clean:server',
      'copy:index',
      'env:all',
      'injector:less',
      'concurrent:server',
      'injector',
      'replace:dist',
      'processhtml',
      'bowerInstall',
      'autoprefixer',
      'express:dev',
      'wait',
      'open',
      'watch'
      ]);
  });

grunt.registerTask('server', function () {
  grunt.log.warn('The `server` task has been deprecated. Use `grunt serve` to start a server.');
  grunt.task.run(['serve']);
});

grunt.registerTask('test', function(target) {
  if (target === 'server') {
    return grunt.task.run([
      'env:all',
      'env:test',
      'mochaTest'
      ]);
  }

  else if (target === 'client') {
    return grunt.task.run([
      'clean:server',
      'copy:index',
      'env:all',
      'injector:less',
      'concurrent:test',
      'injector',
      'autoprefixer',
      'karma'
      ]);
  }

  else if (target === 'e2e') {
    return grunt.task.run([
      'clean:server',
      'copy:index',
      'env:all',
      'env:test',
      'injector:less',
      'concurrent:test',
      'injector',
      'bowerInstall',
      'autoprefixer',
      'express:dev',
      'protractor'
      ]);
  }

  else grunt.task.run([
    'test:server',
    'test:client'
    ]);
});

grunt.registerTask('build', [
  'clean:dist',
  'copy:index',
  'injector:less',
  'concurrent:dist',
  'injector',
  'replace:dist',
  'processhtml',
  'bowerInstall',
  'useminPrepare',
  'autoprefixer',
  'ngtemplates',
  'replace:template',
  'concat',
  // 'ngmin',
  'copy:dist',
  'cssmin',
  // 'uglify',
  'rev',
  'usemin',
  'replace:mobile',
  'cdnify:dist',
  'cdnify:mobile',
  'qiniu:dist',
  'qiniu:mobile'
  ]);


grunt.registerTask('default', [
  'newer:jshint',
  'test',
  'build'
  ]);

};
