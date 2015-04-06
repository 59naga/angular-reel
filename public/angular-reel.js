(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var ngReel;

ngReel = function(window) {
  var module;
  module = window.angular.module('ngReel', []);
  require('./lib/factory')(module);
  require('./lib/provider')(module);
  return require('./lib/directive')(module);
};

if ((typeof window !== "undefined" && window !== null ? window.angular : void 0) != null) {
  ngReel(window);
}

module.exports = ngReel;



},{"./lib/directive":2,"./lib/factory":3,"./lib/provider":4}],2:[function(require,module,exports){
module.exports = function(module) {
  return module.directive('ngReel', ["$reel", "Reel", function($reel, Reel) {
    return {
      scope: true,
      link: function(scope, element, attrs) {
        var reel;
        reel = new Reel(scope, element, attrs);
        if (attrs.ngReelAuto != null) {
          return $reel.autoScroll(reel);
        }
      }
    };
  }]);
};



},{}],3:[function(require,module,exports){
module.exports = function(module) {
  return module.factory('Reel', ["$reel", "$http", "$window", function($reel, $http, $window) {
    var Reel;
    return Reel = (function() {
      function Reel(scope, element, attrs) {
        var as, ref, ref1;
        this.scope = scope;
        this.attrs = attrs;
        this.element = element[0];
        ref = this.attrs.ngReel.split(/\s/), this.resource = ref[0], as = ref[1], this.name = ref[2];
        this.scope[this.name] = [];
        this.feed = 10;
        this.log = [];
        if (this.attrs.ngReelRemember != null) {
          ref1 = this.remind(), this.begin = ref1[0], this.end = ref1[1];
        }
        if (this.begin == null) {
          this.begin = 0;
        }
        if (this.end == null) {
          this.end = this.feed;
        }
        setTimeout((function(_this) {
          return function() {
            var scroller;
            _this.response();
            scroller = $window;
            if (_this.attrs.ngReelOverflow != null) {
              scroller = _this.element;
            }
            return scroller.addEventListener('scroll', function() {
              return _this.response();
            });
          };
        })(this));
      }

      Reel.prototype.response = function() {
        var feeds;
        if (this.busy != null) {
          return;
        }
        if (this.attrs.ngReelStack != null) {
          if (this.isEndOfScroll()) {
            this.request((function(_this) {
              return function(data) {
                _this.add(data);
                return _this.response();
              };
            })(this));
          }
          return;
        }
        feeds = this.get(this.feed);
        if (this.isScrollAfter(feeds)) {
          this.request((function(_this) {
            return function(data) {
              _this.add(data);
              _this.remove(feeds);
              return _this.response();
            };
          })(this));
          return;
        }
        if (this.isUnmetFeed() || this.isEndOfScroll()) {
          this.request((function(_this) {
            return function(data) {
              _this.add(data);
              return _this.response();
            };
          })(this));
        }
      };

      Reel.prototype.request = function(callback) {
        this.busy = true;
        return $http({
          url: this.resource,
          method: 'GET',
          params: $reel.getParams(this)
        }).success((function(_this) {
          return function(feeds) {
            if (feeds.length === 0) {
              if (_this.begin === 0) {
                return console.error('resource Not found');
              }
              if (_this.attrs.ngReelStack != null) {
                return;
              }
              _this.begin = 0;
              _this.end = _this.feed;
              return _this.request(callback);
            }
            if (_this.attrs.ngReelRemember != null) {
              if (_this.log.length >= 2) {
                _this.log.shift();
              }
              _this.log.push(_this.begin + "," + _this.end);
              _this.remember(_this.log[0]);
            }
            _this.begin = parseInt(_this.begin) + parseInt(_this.feed);
            _this.end = parseInt(_this.end) + parseInt(_this.feed);
            _this.busy = null;
            return callback(feeds);
          };
        })(this));
      };

      Reel.prototype.add = function(feeds) {
        var feed, j, len, results;
        results = [];
        for (j = 0, len = feeds.length; j < len; j++) {
          feed = feeds[j];
          results.push(this.scope[this.name].push(feed));
        }
        return results;
      };

      Reel.prototype.remove = function(feeds) {
        var i, j, len, results;
        this.scroll(-feeds.height);
        results = [];
        for (j = 0, len = feeds.length; j < len; j++) {
          i = feeds[j];
          results.push(this.scope[this.name].shift());
        }
        return results;
      };

      Reel.prototype.get = function(length) {
        var childs, feed, feeds, i, j, len;
        if (length == null) {
          length = null;
        }
        childs = this.element.querySelectorAll('[ng-repeat]');
        feeds = [];
        feeds.height = 0;
        for (i = j = 0, len = childs.length; j < len; i = ++j) {
          feed = childs[i];
          if ((length != null) && i >= length) {
            break;
          }
          feeds.push(feed);
          feeds.height += feed.offsetHeight;
        }
        return feeds;
      };

      Reel.prototype.scroll = function(y) {
        if (y == null) {
          y = 3;
        }
        if (this.attrs.ngReelOverflow != null) {
          return this.element.scrollTop += y;
        } else {
          return $window.scrollBy(0, y);
        }
      };

      Reel.prototype.getName = function() {
        return "ngReel:" + this.attrs.ngReel;
      };

      Reel.prototype.remember = function(value) {
        return localStorage.setItem(this.getName(), value);
      };

      Reel.prototype.remind = function() {
        var ref;
        return ((ref = localStorage.getItem(this.getName())) != null ? ref.split(',') : void 0) || [null, null];
      };

      Reel.prototype.forget = function() {
        return localStorage.removeItem(this.getName());
      };

      Reel.prototype.isUnmetFeed = function() {
        return this.get().length < this.feed;
      };

      Reel.prototype.isScrollAfter = function(feeds) {
        var isScrollAfter, scrollY;
        if (this.attrs.ngReelOverflow != null) {
          scrollY = this.element.scrollTop;
        } else {
          scrollY = $window.scrollY - this.element.offsetTop;
        }
        return isScrollAfter = feeds.height < scrollY;
      };

      Reel.prototype.isEndOfScroll = function() {
        var isEndOfScroll;
        if (this.attrs.ngReelOverflow != null) {
          isEndOfScroll = this.element.scrollHeight <= this.element.scrollTop + this.element.offsetHeight;
        } else {
          isEndOfScroll = $window.document.body.offsetHeight <= $window.scrollY + $window.innerHeight;
        }
        return isEndOfScroll;
      };

      return Reel;

    })();
  }]);
};



},{}],4:[function(require,module,exports){
module.exports = function(module) {
  return module.provider('$reel', function() {
    var enableZeroMargin, getParams;
    getParams = function(Reel) {
      return {
        _start: Reel.begin,
        _end: Reel.end
      };
    };
    enableZeroMargin = true;
    return {
      getParams: function(config) {
        return getParams = config;
      },
      disableZeroMargin: function() {
        return enableZeroMargin = false;
      },
      $get: ["$window", function($window) {
        if (enableZeroMargin) {
          $window.angular.element(document).find('head').append('<style type="text/css">\n  @charset "UTF-8";\n  [ng-reel],[ng-reel] *{margin:0;}\n</style>');
        }
        return {
          getParams: getParams,
          autoScroll: function(Reel) {
            var nextFrame;
            $window.requestAnimationFrame(function() {
              return nextFrame();
            });
            return nextFrame = (function(_this) {
              return function() {
                Reel.scroll();
                return $window.requestAnimationFrame(nextFrame);
              };
            })(this);
          }
        };
      }]
    };
  });
};



},{}]},{},[1]);
