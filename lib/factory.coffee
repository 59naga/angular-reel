Factory= ($reel,$http,$window)->
  class Reel
    constructor:(@scope,element,@attrs)->
      @element= element[0]

      [@resource,as,@name]= @attrs.ngReel.split /\s/
      @scope[@name]= []
      @feed= 10
      @log= []

      [@begin,@end]= @remind() if @attrs.ngReelRemember?
      @begin?= 0
      @end?= @feed

      setTimeout =>
        @response()

        scroller= $window
        scroller= @element if @attrs.ngReelOverflow?
        scroller.addEventListener 'scroll',=>
          @response()

    response: ->
      return if @busy?

      if @attrs.ngReelStack?
        if @isEndOfScroll()
          @request (data)=>
            @add data
            @response()
        return

      feeds= @get @feed
      if @isScrollAfter feeds
        @request (data)=> 
          @add data
          @remove feeds
          @response()
        return

      if @isUnmetFeed() or @isEndOfScroll()
        @request (data)=>
          @add data
          @response()
        return

    request: (callback)->
      @busy= true

      $http
        url:@resource
        method:'GET'
        params:$reel.getParams this
      .success (feeds)=>
        if feeds.length is 0
          throw new Error 'resource Not found' if @begin is 0
          return if @attrs.ngReelStack?

          @begin= 0
          @end= @feed
          return @request callback

        if @attrs.ngReelRemember?
          @log.shift() if @log.length >= 2
          @log.push "#{@begin},#{@end}"
          @remember @log[0]

        @begin= parseInt(@begin)+ parseInt(@feed)
        @end= parseInt(@end)+ parseInt(@feed)

        @busy= null

        callback feeds

    add: (feeds)->
      @scope[@name].push feed for feed in feeds
    remove: (feeds)->
      @scroll -feeds.height
      @scope[@name].shift() for i in feeds

    get: (length=null)->
      childs= @element.querySelectorAll '[ng-repeat]'

      feeds= []
      feeds.height= 0
      for feed,i in childs
        break if length? and i>=length
  
        feeds.push feed
        feeds.height+= feed.offsetHeight
      feeds

    scroll: (y=3)->
      if @attrs.ngReelOverflow?
        @element.scrollTop+= y
      else
        $window.scrollBy 0,y

    getName: -> "ngReel:#{@attrs.ngReel}"
    remember: (value)->
      localStorage.setItem @getName(),value
    remind: ->
      localStorage.getItem(@getName())?.split(',') or [null,null]
    forget: ->
      localStorage.removeItem @getName()

    isUnmetFeed: ->
      @get().length < @feed

    isScrollAfter: (feeds)->
      if @attrs.ngReelOverflow?
        scrollY= @element.scrollTop 
      else
        scrollY= $window.scrollY-@element.offsetTop

      isScrollAfter= feeds.height< scrollY

    isEndOfScroll: ->
      if @attrs.ngReelOverflow?
        isEndOfScroll= @element.scrollHeight <= @element.scrollTop+@element.offsetHeight 
      else
        isEndOfScroll= $window.document.body.offsetHeight <= $window.scrollY+$window.innerHeight
      isEndOfScroll

module.exports= Factory