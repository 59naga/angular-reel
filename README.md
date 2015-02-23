# angular-reel
Infinite scroll like a carousel

## Installation
```bash
$ bower install angular-reel
```

## Usage
```html
<head>
  <script src="bower_components/angular/angular.js"></script>
  <script src="bower_components/angular-resource/angular-resource.js"></script>
  <script src="bower_components/angular-reel/angular-reel.js"></script>
  <script>
    angular
    .module('myApp',['ngReel'])
    .factory('Post',function($resource){
      return $resource('http://jsonplaceholder.typicode.com/posts');
    });
  </script>
</head>
<body ng-app="myApp">
  <h1>ng-reel is ng-repeat wrapper</h1>
  <article ng-reel="Post as posts">
    <section ng-repeat="post in posts">
      <h2><i ng-bind="post.id"></i>. <span ng-bind="post.title"></span></h2>
      <pre ng-bind="post.body"></pre>
    </section>
  </article>
</body>
```html

## Examples
```bash
$ git clone https://github.com/59naga/angular-reel.git && cd angular-reel
$ npm i && bower i
$ npm test
```

# License
MIT by 59naga