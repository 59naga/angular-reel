# angular-reel
Infinite scroll for ng-repeat

## Installation
```bash
$ bower install angular-reel
```

### Usage
```html
<head>
  <script src="bower_components/angular/angular.js"></script>
  <script src="bower_components/angular-reel/angular-reel.js"></script>
  <script>
    angular.module('myApp',['ngReel'])
  </script>
</head>
<body ng-app="myApp">
  <h1>ng-reel is ng-repeat wrapper</h1>
  <article ng-reel="http://jsonplaceholder.typicode.com/posts as posts">
    <section ng-repeat="post in posts">
      <h2><i ng-bind="post.id"></i>. <span ng-bind="post.title"></span></h2>
      <pre ng-bind="post.body"></pre>
    </section>
  </article>
</body>
```

## ng-reel
Append to `posts` by Request `URL`
```html
<nav ng-reel="URL as posts">
  <a ng-repeat="post in posts">
    {{post.body}}
  </a>
</nav>
```

### ng-reel-overflow
Enable scroll for Directive element (default $window)
```html
<nav ng-reel="URL as posts" ng-reel-overflow style="height:500px;overflow:scroll">
  <a ng-repeat="post in posts">
    {{post.body}}
  </a>
</nav>
```
### ng-reel-remember
Remember scroll position by use $window.localStorage.setItem(`"URL as posts"`)
```html
<nav ng-reel="URL as posts" ng-reel-remember>
  <a ng-repeat="post in posts">
    {{post.body}}
  </a>
</nav>
```
### ng-reel-auto
Auto scroll by use $window.requestAnimationFrame
```html
<nav ng-reel="URL as posts" ng-reel-auto>
  <a ng-repeat="post in posts">
    {{post.body}}
  </a>
</nav>
```

## $reelProvider
### getParams
Custmize URL parameters
```js
module.config(function($reelProvider){
  $reelProvider.getParams(function(Reel){
    // ng-reel default
    return {
      _start:Reel.begin,
      _end:Reel.end,
    };
    // becomes "URL?_start=Reel.begin&_end=Reel.begin"
  });
});
```

### disableZeroMargin
Disable default css `[ng-reel],[ng-reel] *{margin:0;}`
```js
module.config(function($reelProvider){
  $reelProvider.disableZeroMargin();
});
```

## Examples
```bash
$ npm test
```

## Feture
**DEMO**
**TEST**

# License
MIT by 59naga
