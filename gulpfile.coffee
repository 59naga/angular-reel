gulp= require 'gulp'
gulp.task 'default',['build'],->
  gulp.start 'server'

  gulp.watch [
    '*.coffee'
    'lib/*.coffee'
  ],->
    gulp.start 'build'

gulp.task 'release',->
  source= require 'vinyl-source-stream'
  browserify= require 'browserify'
  browserify
      entries: "./angular-reel.coffee"
      extensions: '.coffee'
    .transform 'coffeeify'
    .bundle()
    .pipe source 'angular-reel.js'
    .pipe gulp.dest './'
gulp.task 'build',->
  source= require 'vinyl-source-stream'
  browserify= require 'browserify'
  browserify
      entries: "./angular-reel.coffee"
      extensions: '.coffee'
    .transform 'coffeeify'
    .bundle()
    .pipe source 'angular-reel.js'
    .pipe gulp.dest './public'

gulp.task 'open',['default'],->
  open= require 'open'
  open 'http://localhost:3000'
gulp.task 'server',->
  process.nextTick ->
    jsonServer= require 'json-server'
    morgan= require 'morgan'

    server= jsonServer.create()
    server.use morgan 'dev'
    server.use jsonServer.router db
    server.listen 3000

  faker= require 'faker'
  # faker.locale= 'ja'
  db= {}

  db.alone= []
  for i in [1..1]
    db.alone.push
      id: i
      image: faker.internet.avatar()
      name: faker.name.findName()
      bio: faker.lorem.sentences 5

  db.first_users= []
  for i in [1..5]
    db.first_users.push
      id: i
      image: faker.internet.avatar()
      name: faker.name.findName()
      bio: faker.lorem.sentences 5

  db.second_users= []
  for i in [1..10]
    db.second_users.push
      id: i
      image: faker.internet.avatar()
      name: faker.name.findName()
      bio: faker.lorem.sentences 5

  db.third_users= []
  for i in [1..100]
    db.third_users.push
      id: i
      image: faker.internet.avatar()
      name: faker.name.findName()
      bio: faker.lorem.sentences 5