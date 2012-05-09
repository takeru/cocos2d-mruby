begin

puts "Hello2.rb"
Cocos2d.test

module Cocos2d
  class Size
    def width;      @width;  end
    def height;     @height; end
    def width=(w);  @width  = w.to_f; end
    def height=(h); @height = h.to_f; end
  end

  class Position
    def initialize(x, y)
      @x = x
      @y = y
    end
    def x;     @x; end
    def y;     @y; end
    def x=(x); @x = x.to_f; end
    def y=(y); @y = y.to_f; end
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

class RubyLogo < Cocos2d::Sprite
  def initialize
    super(:file=>"ruby.png")
    @winSize = Cocos2d.winSize

    @x, @y = @winSize.width*0.3, @winSize.height*0.7
    self.position = Cocos2d::Position.new(@x, @y)
    self.tickInterval = 0.01
    @dx =  1
    @dy = -1
  end

  def tick(dt)
    100.times do |n|
      "#{dt} #{n}"
    end

    @x += @dx
    @y += @dy
    if @x < 0
      @dx *= -1.1
    end
    if @y < 0
      @dy *= -1.1
    end
    if @winSize.width < @x
      @dx *= -1.1
    end
    if @winSize.height < @y
      @dy *= -1.1
    end
    self.position = Cocos2d::Position.new(@x, @y)
  end
end

class HelloLayer < Cocos2d::Layer
  def initialize
    super
    # puts "HelloLayer#initialize"
    self.isTouchEnabled = true

    @winSize = Cocos2d.winSize

    player1 = Cocos2d::Sprite.new(:file=>"Icon-Small@2x.png")
    player1.position = Cocos2d::Position.new(@winSize.width/2, @winSize.height/2)
    addChild(player1)

    player2 = Cocos2d::Sprite.new(:file=>"Icon-72.png")
    player2.position = Cocos2d::Position.new(@winSize.width*0.8, @winSize.height+0.3)
    addChild(player2)
    
    logo = RubyLogo.new
    addChild(logo)
    @logo = logo

    self.tickInterval = 1.0
    
    # GC.start
    @touch_count = 0
    @players = []
  end

  def tick(dt)
    puts "HelloLayer#tick dt=#{dt}"
  end

  def touchBegan(t, e)
    # convertTouchToNodeSpace(t)
    # convertTouchToNodeSpaceAR
    touchesBegan(e)
  end

  def touchesBegan(e)
    print "#{@touch_count} B"

    player = Cocos2d::Sprite.new(:file=>"Icon-Small.png")
    player.position = Cocos2d::Position.new(@winSize.width * (@touch_count % 10) * 0.1, @winSize.height * (@touch_count / 10) * 0.1)
    addChild(player)
    @players.push(player)
    while 7 < @players.size
      old_player = @players.shift
      removeChild(old_player)
    end
    @touch_count = (@touch_count+1) % 100
  end
  def touchesMoved(e)
    print "M"
  end
  def touchesEnded(e)
    puts "E"
  end
  def touchesCancelled(e)
    puts "C"
  end
end

def createLayer
  layer = HelloLayer.new
  $layer = layer
  return layer
#rescue # !!BUG!!
#  p e
end

rescue => e
  p e
end

