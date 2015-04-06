ngReel= (window)->
  module= window.angular.module 'ngReel',[]

  require('./lib/factory') module
  require('./lib/provider') module
  require('./lib/directive') module

ngReel window if window?.angular?
module.exports= ngReel