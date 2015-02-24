Directive= ($reel,Reel)->
  scope:true
  link:(scope,element,attrs)->
    reel= new Reel scope,element,attrs
    $reel.autoScroll reel if attrs.ngReelAuto?

module.exports= Directive