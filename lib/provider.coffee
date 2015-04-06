module.exports= (module)->
  module.provider '$reel',->
    getParams= (Reel)->
      _start:Reel.begin
      _end:Reel.end
    enableZeroMargin= true

    getParams: (config)-> getParams= config
    disableZeroMargin: -> enableZeroMargin= false
    $get: ($window)->
      if enableZeroMargin
        $window.angular.element(document).find('head').append '''
        <style type="text/css">
          @charset "UTF-8";
          [ng-reel],[ng-reel] *{margin:0;}
        </style>
        '''

      getParams:getParams
      autoScroll: (Reel)->
        $window.requestAnimationFrame -> nextFrame()
        nextFrame= =>
          Reel.scroll()

          $window.requestAnimationFrame nextFrame