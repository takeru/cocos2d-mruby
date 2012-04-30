cocos2d-mruby
=============

http://takeru.github.com/cocos2d-mruby/

![ss2012-04-30.png](http://takeru.github.com/cocos2d-mruby/images/ss2012-04-30.png)

    class HelloLayer < Cocos2d::Layer
      def initialize
        super
     
        player = Cocos2d::Sprite.new(:file=>"Icon-Small.png")
        size = Cocos2d.winSize
        size.width  /= 2
        size.height /= 2
        player.position = size
        addChild(player)
     
        player2 = Cocos2d::Sprite.new(:file=>"Icon-72.png")
        size = Cocos2d.winSize
        size.width  *= 0.8
        size.height *= 0.3
        player2.position = size
        addChild(player2)
     
        logo = Cocos2d::Sprite.new(:file=>"ruby.png")
        size = Cocos2d.winSize
        size.width  *= 0.3
        size.height *= 0.7
        logo.position = size
        addChild(logo)
      end
    end
  
