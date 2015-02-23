ngReel= (window)->
  module= window.angular.module 'ngReel',['ngResource']
  module.factory 'Spec0',($resource)-> $resource 'http://localhost:3000/alone'
  module.factory 'Spec1',($resource)-> $resource 'http://localhost:3000/first_users'
  module.factory 'Spec2',($resource)-> $resource 'http://localhost:3000/second_users'
  module.factory 'Spec3',($resource)-> $resource 'http://localhost:3000/third_users'
  module.directive 'ngReel',($reel)->
    scope:true
    link:(scope,element,attrs)->
      scope.reelElement= element[0]

      scope.autoScroll= attrs.ngReelAuto
      scope.overflow= attrs.ngReelOverflow
      scope.remember= attrs.ngReelRemember

      scope.ngReel= attrs.ngReel
      [resource,as,model]= attrs.ngReel.split /\s/
      scope.resource= resource
      scope.model= model

      scope[scope.model]= []
      scope.read= $reel.remind scope
      scope.load= scope.read

      scope.step= 10
      scope.feed= scope.step*2

      setTimeout ->
        $reel.autoScroll scope if scope.autoScroll?
        $reel.scrollInfinite scope

        if scope.overflow?
          scope.reelElement.addEventListener 'scroll',->
            $reel.scrollInfinite scope
        else
          window.addEventListener 'scroll',->
            $reel.scrollInfinite scope

  module.provider '$reel',->
    $reel= {}
    $reel.$get= ($injector,$resource)->
      scrollInfinite: (scope)->
        return if scope.busy?

        reel= scope.reelElement

        scrollBottom= document.body.offsetHeight <= window.scrollY+window.innerHeight
        scrollBottom= reel.scrollHeight <= reel.scrollTop+reel.offsetHeight if scope.overflow?
        if scrollBottom
          @request scope,=> @scrollInfinite scope
          return

        if @getFeeds(scope).length < scope.feed
          @request scope,=> @scrollInfinite scope
          return

        scrollY= window.scrollY-reel.offsetTop
        scrollY= scope.reelElement.scrollTop if scope.overflow?
        feeds= @getFeeds scope,scope.step
        if scrollY> feeds.height
          @read feeds,scope
          @request scope,=> @scrollInfinite scope
          return

      request: (scope,callback=null)->
        params= @getParams scope

        scope.busy= true

        @getResource(scope.resource).query params,(resources)=>
          if resources.length
            scope[scope.model].push resource for resource in resources
            scope.load+= resources.length
            scope.busy= null

            callback resources if callback?
          else
            throw new Error 'Resource not found' if scope.load is 0

            scope.busy= null
            scope.read= 0
            scope.load= 0
            @request scope,callback

      response: (scope,resources)->

      read: (feeds,scope)->
        window.scrollTo 0,window.scrollY- feeds.height if scope.overflow is undefined
        scope.reelElement.scrollTop-= feeds.height
        scope[scope.model].shift() for i in feeds
        scope.read+= feeds.length
        scope.$apply()

        @mind scope

      getName: (scope)->
        name= 'ngReel:'+scope.remember
        name= scope.ngReel if scope.remember is ''
      mind: (scope)->
        localStorage.setItem @getName(scope),scope.read if scope.remember?
      remind: (scope)->
        return new Number(localStorage.getItem @getName(scope)) if scope.remember?
        return 0
      reset: (name)->
        reel= @reels[name]
        localStorage.removeItem @getName reel
        console.log reel

      getResource: (name,paramDefaults=null)->
        Resource= getResourceConfig arguments...
        if Resource is undefined
          Resource= $injector.get name if $injector.has name
          Resource= $resource name,paramDefaults if Resource is undefined
        Resource

      getParams: (scope)->
        params= getParamsConfig arguments...
        if params is undefined
          params=
            _start: scope.load
            _end: scope.load+ (scope.feed - @getFeeds(scope).length)
          params._end= params._start+1 if params._end<= params._start
        params

      getFeeds: (scope,length=null)->
        feeds= []
        feeds.height= 0
        for feed,i in scope.reelElement.querySelectorAll '[ng-repeat]'
          break if length? and i>=length
          feeds.push feed
          feeds.height+= feed?.offsetHeight ? feed?.clientHeight
        feeds

      autoScroll: (scope)->
        scrollY= ~~scope.autoScroll
        scrollY= 3 if scrollY<=0

        timeout -> nextFrame()
        nextFrame= ->
          scope.reelElement.scrollTop+= scrollY if scope.overflow?
          window.scrollTo 0,window.scrollY+scrollY if scope.overflow is undefined

          timeout nextFrame

    timeout= window?.requestAnimationFrame ? setTimeout

    $reel.getResource= (config)-> getResource= config
    $reel.getParams= (config)-> getParams= config

    getResourceConfig= -> undefined
    getParamsConfig= -> undefined

    $reel

ngReel window if window?.angular?
module.exports= ngReel if module?