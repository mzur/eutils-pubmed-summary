module.exports = (grunt) ->
	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'

		path:
			test: 'test-src/'
			src: 'src/'
			scriptSrc: 'src/scripts/'
		
		dest:
			dist: 'dist/'
			distScript: 'dist/scripts/'
			dev: 'dev/'
			test: 'test/'

		copy:
			dist:
				expand: yes
				cwd: '<%= path.src %>'
				src: '*'
				dest: '<%= dest.dist %>'
				filter: 'isFile'
			dev:
				expand: yes
				cwd: '<%= path.src %>'
				src: '*'
				dest: '<%= dest.dev %>'
				filter: 'isFile'
			test:
				expand: yes
				cwd: '<%= path.test %>'
				src: '*'
				dest: '<%= dest.test %>'
				filter: 'isFile'

		coffee:
			dist:
				files: '<%= dest.distScript %><%= pkg.name %>.js':
					['<%= path.scriptSrc %>**/*.coffee']
			dev:
				cwd: '<%= path.src %>'
				src: '**/*.coffee'
				dest: '<%= dest.dev %>'
				options:
					bare: yes
				expand: yes
				ext: '.js'
			test:
				cwd: '<%= path.test %>'
				src: '**/*.coffee'
				dest: '<%= dest.test %>'
				options:
					bare: yes
				expand: yes
				ext: '.js'

		clean:
			dist: ['<%= dest.dist %>']
			dev: ['<%= dest.dev %>']
			test: ['<%= dest.test %>']

		uglify:
			options:
				banner: '/*! <%= pkg.name %> <%= grunt.template.today("dd-mm-yyyy") %> */\n'
			dist:
				files:
					'<%= dest.distScript %><%= pkg.name %>.min.js':
						['<%= dest.distScript %><%= pkg.name %>.js']

		karma:
			unit:
				configFile: 'karma.conf.js'
				background: yes
			continuous:
				configFile: 'karma.conf.js'
				singleRun: yes
				browsers: ['PhantomJS']

		coffeelint:
			app: [
				'Gruntfile.coffee'
				'<%= path.src %>**/*.coffee'
				'<%= path.test %>**/*.coffee'
			]
			options:
				configFile: 'coffeelint.json'

		watch:
			files: ['<%= coffeelint.app %>']
			tasks: [
				'coffeelint'
				'clean:dev'
				'coffee:dev'
				'copy:dev'
				'clean:test'
				'coffee:test'
				'copy:test'
				'karma:unit:run'
			]

	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-coffeelint'
	grunt.loadNpmTasks 'grunt-karma'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-copy'

	grunt.registerTask 'test', [
		'coffeelint'
		'clean'
		'coffee:dev'
		'coffee:test'
		'karma:continuous'
	]

	grunt.registerTask 'default', ['test', 'coffee:dist', 'uglify', 'copy:dist']
