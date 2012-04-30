//
//  HelloWorldLayer.m
//  Hello2
//
//  Created by  on 12/04/22.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "Cocos2dMrb.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	// HelloWorldLayer *layer = [HelloWorldLayer node];
    Cocos2dMrb *mrb = [[Cocos2dMrb alloc] init];
    NSString* path = [[NSBundle mainBundle] pathForResource: @"Hello2" ofType: @"rb"];
    [mrb loadFile:path];
    
    
    // mrb_value l = mrb_funcall(mrb, mrb_top_self(mrb), "createLayer", 0);
    //CCLayer *layer = 

	// add layer as a child to scene
	// [scene addChild: layer];

	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
    // always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        [self initRuby];
        
        self.isTouchEnabled = YES;

		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#include "mruby/proc.h"

- (void) initRuby
{
    /*
    char* code = "(1..10).each {|x| puts \"Hello from mruby! x=#{x}\" }; i=0;";
    mrb = mrb_open();
    struct mrb_parser_state* st = mrb_parse_string(mrb, code);
    int n = mrb_generate_code(mrb, st->tree);
    mrb_pool_close(st->pool);
    mrb_run(
        mrb,
        mrb_proc_new(mrb, mrb->irep[n]),
        mrb_nil_value()
    );
    */
}

- (void) tick
{
    /*
    char* code = "i+=1; puts i;";
    struct mrb_parser_state* st = mrb_parse_string(mrb, code);
    int n = mrb_generate_code(mrb, st->tree);
    mrb_pool_close(st->pool);
    
    mrb_run(
            mrb,
            mrb_proc_new(mrb, mrb->irep[n]),
            mrb_nil_value()
            );
     */
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	if( touch ) {
		CGPoint location = [touch locationInView: [touch view]];
        printf("location = (%6.2f, %6.2f)\n", location.x, location.y);
        
        [self tick];
        /*
		// IMPORTANT:
		// The touches are always in "portrait" coordinates. You need to convert them to your current orientation
		CGPoint convertedPoint = [[CCDirector sharedDirector] convertToGL:location];
		
		CCNode *sprite = [self getChildByTag:kTagSprite];
		
		// we stop the all running actions
		[sprite stopAllActions];
		
		// and we run a new action
		[sprite runAction: [CCMoveTo actionWithDuration:1 position:convertedPoint]];
		*/
	}	
}

@end

