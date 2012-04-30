begin

puts "Hello2.rb"
Cocos2d.test

module Cocos2d
  class Size
    def width;  @width;  end
    def height; @height; end
    def width=(w);  @width  = w.to_f; end
    def height=(h); @height = h.to_f; end
  end
  class Sprite
    def _objc_object
      @_objc_object
    end
    def hello
      p "hello"
    end
  end
end

class HelloLayer < Cocos2d::Layer
  def initialize
    super
    puts "HelloLayer#initialize"

    player = Cocos2d::Sprite.new(:file=>"Icon-Small.png")
    p player
    p player._objc_object
    player.hello

    size = Cocos2d.winSize
    p size
    size.width  /= 2
    size.height /= 2
    p size
    player.position = size

    # addChild(player)
  end
end

HelloLayer.new

rescue => e
  p e
end

