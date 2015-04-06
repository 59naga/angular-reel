module.exports= (module)->
  module.directive 'ngReel',($reel,Reel)->
    scope:true
    link:(scope,element,attrs)->
      reel= new Reel scope,element,attrs
      $reel.autoScroll reel if attrs.ngReelAuto?

