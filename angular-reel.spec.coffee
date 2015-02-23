faker= require 'faker'
# faker.locale= 'ja'

db= {}

first_users= []
for i in [1..5]
  first_users.push
    id: i
    image: faker.internet.avatar()
    name: faker.name.findName()
    bio: faker.lorem.sentences 5
db.first_users= first_users

second_users= []
for i in [1..10]
  second_users.push
    id: i
    image: faker.internet.avatar()
    name: faker.name.findName()
    bio: faker.lorem.sentences 5
db.second_users= second_users

third_users= []
for i in [1..100]
  third_users.push
    id: i
    image: faker.internet.avatar()
    name: faker.name.findName()
    bio: faker.lorem.sentences 5
db.third_users= third_users


alone= []
for i in [1..1]
  alone.push
    id: i
    image: faker.internet.avatar()
    name: faker.name.findName()
    bio: faker.lorem.sentences 5
db.alone= alone


jsonServer= require 'json-server'
server= jsonServer.create()
server.use require('morgan') 'dev'
server.use jsonServer.router db
server.listen 3000

require('open') 'http://localhost:3000'