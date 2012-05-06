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
  class Node
    def _CCNode
      @_CCNode
    end
    def hello
      p "hello"
    end
  end
end

class NSObjectContainer
  def inspect
    "#<NSObjectContainer p="+self.nsobject_pointer.to_s(16)+" retainCount="+self.retainCount+">"
  end
end

class HelloLayer < Cocos2d::Layer
  def initialize
    super
    # puts "HelloLayer#initialize"
    self.isTouchEnabled = true

    player = Cocos2d::Sprite.new(:file=>"Icon-Small.png")
    puts "player=" + player.inspect
    # p player._CCNode.nsobject_pointer.to_s(16)
    # puts("player._CCNode.nsobject_pointer=%s" % 1) #player._CCNode.nsobject_pointer
    # player.hello

    size = Cocos2d.winSize
    # p size
    size.width  /= 2
    size.height /= 2
    # p size
    player.position = size

    addChild(player)

    player2 = Cocos2d::Sprite.new(:file=>"Icon-72.png")
    size = Cocos2d.winSize
    size.width  *= 0.8
    size.height *= 0.3
    player2.position = size
    puts "A: player2=" + player2.inspect
    addChild(player2)
    puts "B: player2=" + player2.inspect
    
    logo = Cocos2d::Sprite.new(:file=>"ruby.png")
    size = Cocos2d.winSize
    size.width  *= 0.3
    size.height *= 0.7
    logo.position = size
    puts "A: logo=" + logo.inspect
    addChild(logo)
    puts "B: logo=" + logo.inspect
    @logo = logo

    # GC.start
  end
end

def createLayer
  $layer = HelloLayer.new
  return $layer
#rescue # !!BUG!!
#  p e
end

rescue => e
  p e
end

