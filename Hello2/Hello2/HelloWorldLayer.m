//
//  HelloWorldLayer.m
//  Hello2
//
//  Created by  on 12/04/22.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

#include "mruby.h"
#include "compile.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
    int n;
    mrb_state* mrb;
    struct mrb_parser_state* st;
    char* code =
      "(1..10).each {|x|" \
      "  puts \"Hello from mruby! x=#{x}\"" \
      "}";
    mrb = mrb_open();
    st = mrb_parse_string(mrb, code);
    n = mrb_generate_code(mrb, st->tree);
    mrb_pool_close(st->pool);
    mrb_run(
        mrb,
        mrb_proc_new(mrb, mrb->irep[n]),
        mrb_nil_value()
    );


    // always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
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
@end
