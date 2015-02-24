ngReel= (window)->
  module= window.angular.module 'ngReel',[]
  module.factory 'Reel',require './lib/factory'
  module.provider '$reel',require './lib/provider'
  module.directive 'ngReel',require './lib/directive'

ngReel window if window?.angular?
module.exports= ngReel