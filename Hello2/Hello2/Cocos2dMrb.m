
#import "Cocos2dMrb.h"
#import "MrbLayer.h"
#import "MrbSprite.h"
#import "NSObjectContainer.h"
#include "mruby/proc.h"
#include "mruby/hash.h"
#include "mruby/variable.h"
#include "mruby/data.h"
#include "mruby/compile.h"


@implementation Cocos2dMrb

//@synthesize mrb;

-(id) init
{
	if( (self=[super init])) {
        //self.mrb = mrb_open();
        mrb = mrb_open();
        //[self loadFile:@"aa"];
        [self initClasses];
	}
	return self;
}


mrb_value mCocos2d_test(mrb_state *mrb, mrb_value self)
{
    printf("mCocos2d_test\n");
    return mrb_nil_value();
}

mrb_value mCocos2d_winSize(mrb_state *mrb, mrb_value self)
{
    mrb_value size;
    mrb_value object;
    mrb_value cocos2d;
    mrb_value cocos2d_size;
    CGSize cgSize = [[CCDirector sharedDirector] winSize];

    object       = mrb_obj_value(mrb->object_class);
    cocos2d      = mrb_const_get(mrb, object,  mrb_intern(mrb,"Cocos2d"));
    cocos2d_size = mrb_const_get(mrb, cocos2d, mrb_intern(mrb,"Size"));
    size = mrb_funcall(mrb, cocos2d_size, "new", 0);
    mrb_iv_set(mrb, size, mrb_intern(mrb, "@width" ), mrb_float_value(cgSize.width ));
    mrb_iv_set(mrb, size, mrb_intern(mrb, "@height"), mrb_float_value(cgSize.height));

    return size;
}

mrb_value cNode_initialize(mrb_state *mrb, mrb_value self)
{
    //printf("cNode_initialize p=%x\n", (unsigned int)self);
    return self;
}

mrb_value cNode_position_SET(mrb_state *mrb, mrb_value self)
{
    CCNode *ccNode;
    mrb_float x;
    mrb_float y;
    
    mrb_value size;
    mrb_get_args(mrb, "o", &size);
    
    ccNode = (CCNode*)cNSObjectContainer__GET(mrb, self, "@_CCNode");
    
    x = mrb_float(mrb_iv_get(mrb, size, mrb_intern(mrb, "@x" )));
    y = mrb_float(mrb_iv_get(mrb, size, mrb_intern(mrb, "@y")));
    ccNode.position = ccp(x, y);

    return mrb_nil_value();
}

/**
 * addChild(child)
 * addChild(child, :z=>123)
 * addChild(child, :z=>123, :tag=>456)
 */
mrb_value cNode_addChild(mrb_state *mrb, mrb_value self)
{
    CCNode *selfCCNode;
    CCNode *childCCNode;
    mrb_value child;
    mrb_value *argv;
    int argc;
    
    mrb_get_args(mrb, "o*", &child, &argv, &argc);
    // mrb_p(mrb, child);

    childCCNode = (CCNode*)cNSObjectContainer__GET(mrb, child, "@_CCNode");
    
    // TODO z, tag
    
    selfCCNode = (CCNode*)cNSObjectContainer__GET(mrb, self, "@_CCNode");
    // mrb_p(mrb, self);
    [selfCCNode addChild:childCCNode];

    return mrb_nil_value();
}

/**
 * removeChild(child)
 * removeChild(child, :cleanup=>true)
 */
mrb_value cNode_removeChild(mrb_state *mrb, mrb_value self)
{
    CCNode *selfCCNode;
    CCNode *childCCNode;
    mrb_value child;
    mrb_value *argv;
    int argc;
    
    mrb_get_args(mrb, "o*", &child, &argv, &argc);
    // mrb_p(mrb, child);
    
    childCCNode = (CCNode*)cNSObjectContainer__GET(mrb, child, "@_CCNode");
    
    // TODO cleanup
    
    selfCCNode = (CCNode*)cNSObjectContainer__GET(mrb, self, "@_CCNode");
    // mrb_p(mrb, self);
    [selfCCNode removeChild:childCCNode cleanup:YES];
    
    return mrb_nil_value();
    
}


mrb_value cScene_initialize(mrb_state *mrb, mrb_value self)
{
    self = cNode_initialize(mrb, self);
    // printf("cScene_initialize\n");

    return self;
}

mrb_value cLayer_initialize(mrb_state *mrb, mrb_value self)
{
    self = cNode_initialize(mrb, self);
    // printf("cLayer_initialize\n");

    MrbLayer *mrbLayer;
    mrbLayer = [MrbLayer node];
    [mrbLayer setMrb:mrb andValue:self];
    cNSObjectContainer__ATTACH(mrb, self, mrbLayer, "@_CCNode");
    // mrb_p(mrb, self);
    return self;
}

mrb_value cLayer_isTouchEnabled_SET(mrb_state *mrb, mrb_value self)
{
    CCLayer *ccLayer;
    
    mrb_value enabled;
    mrb_get_args(mrb, "o", &enabled);
    
    ccLayer = (CCLayer*)cNSObjectContainer__GET(mrb, self, "@_CCNode");

    ccLayer.isTouchEnabled = mrb_test(enabled) ? TRUE : FALSE;
    
    return mrb_nil_value();
}

mrb_value cLayer_isAccelerometerEnabled_SET(mrb_state *mrb, mrb_value self)
{
    CCLayer *ccLayer;
    
    mrb_value enabled;
    mrb_get_args(mrb, "o", &enabled);

    ccLayer = (CCLayer*)cNSObjectContainer__GET(mrb, self, "@_CCNode");
    
    ccLayer.isAccelerometerEnabled = mrb_test(enabled) ? TRUE : FALSE;
    
    return mrb_nil_value();
}

mrb_value cLayer_tickInterval_SET(mrb_state *mrb, mrb_value self)
{
    MrbLayer *mrbLayer;
    
    mrb_value interval;
    mrb_get_args(mrb, "o", &interval);
    
    mrbLayer = (MrbLayer*)cNSObjectContainer__GET(mrb, self, "@_CCNode");
    [mrbLayer scheduleTick:mrb_float(interval)];

    return mrb_nil_value();
}

mrb_value cSprite_initialize(mrb_state *mrb, mrb_value self)
{
    self = cNode_initialize(mrb, self);
    // printf("cSprite_initialize\n");

    mrb_value opts;
    mrb_value file;
    MrbSprite *mrbSprite;

    mrb_get_args(mrb, "o", &opts);

    file = mrb_hash_get(mrb, opts, mrb_symbol_value(mrb_intern(mrb, "file")));
    // mrb_p(mrb, file);
    char* cstr_file = mrb_string_value_cstr(mrb, &file);

    mrbSprite = [MrbSprite spriteWithFile:[NSString stringWithUTF8String:cstr_file]];
    [mrbSprite setMrb:mrb andValue:self];
    cNSObjectContainer__ATTACH(mrb, self, mrbSprite, "@_CCNode");
    // mrb_p(mrb, self);
    return self;
}

mrb_value cSprite_tickInterval_SET(mrb_state *mrb, mrb_value self)
{
    MrbSprite *mrbSprite;
    
    mrb_value interval;
    mrb_get_args(mrb, "o", &interval);
    
    mrbSprite = (MrbSprite*)cNSObjectContainer__GET(mrb, self, "@_CCNode");
    [mrbSprite scheduleTick:mrb_float(interval)];

    return mrb_nil_value();
}

-(void) initClasses
{
    struct RClass *mCocos2d;    // module Cocos2d
    struct RClass *cNode;       // class  Cocos2d::Node
    struct RClass *cScene;      // class  Cocos2d::Scene
    struct RClass *cLayer;      // class  Cocos2d::Layer
    struct RClass *cSprite;     // class  Cocos2d::Sprite

    cNSObjectContainer_DEFINE(mrb);
    
    mCocos2d = mrb_define_module(mrb, "Cocos2d");
    mrb_define_class_method(mrb, mCocos2d, "test", mCocos2d_test, ARGS_REQ(1));
    mrb_define_class_method(mrb, mCocos2d, "winSize", mCocos2d_winSize, ARGS_NONE());

    cNode   = mrb_define_class_under(mrb, mCocos2d, "Node",   mrb_class_obj_get(mrb, "Object")); // Node < Object
    mrb_define_method(mrb, cNode, "initialize", cNode_initialize,   ARGS_ANY());
    mrb_define_method(mrb, cNode, "position=",  cNode_position_SET, ARGS_REQ(1));
    mrb_define_method(mrb, cNode, "addChild",   cNode_addChild,     ARGS_ANY());
    mrb_define_method(mrb, cNode, "removeChild",cNode_removeChild,  ARGS_ANY());

    cLayer  = mrb_define_class_under(mrb, mCocos2d, "Layer",  cNode); // Layer  < Node
    mrb_define_method(mrb, cLayer, "initialize", cLayer_initialize, ARGS_ANY());
    mrb_define_method(mrb, cLayer, "isTouchEnabled=",         cLayer_isTouchEnabled_SET,         ARGS_REQ(1));
    mrb_define_method(mrb, cLayer, "isAccelerometerEnabled=", cLayer_isAccelerometerEnabled_SET, ARGS_REQ(1));
    mrb_define_method(mrb, cLayer, "tickInterval=", cLayer_tickInterval_SET, ARGS_REQ(1));

    cScene  = mrb_define_class_under(mrb, mCocos2d, "Scene",  cNode); // Scene  < Node
    mrb_define_method(mrb, cScene, "initialize", cScene_initialize, ARGS_ANY());
    
    cSprite = mrb_define_class_under(mrb, mCocos2d, "Sprite", cNode); // Sprite < Node
    mrb_define_method(mrb, cSprite, "initialize", cSprite_initialize, ARGS_ANY());
    mrb_define_method(mrb, cSprite, "tickInterval=", cSprite_tickInterval_SET, ARGS_REQ(1));
}

-(void) loadFile:(NSString*)file
{
    // NSLog(@"loadFile:%@", file);
    
    FILE* f = fopen([file cStringUsingEncoding:1], "r");
    mrb_value ret = mrb_load_file(mrb, f);
    fclose(f);
}

-(void) dealloc
{
    mrb_close(mrb);
	[super dealloc];
}

-(CCLayer*) createLayer // tmp
{
    mrb_value layer = mrb_funcall(mrb, mrb_top_self(mrb), "createLayer", 0);
    // mrb_p(mrb, layer);
    return (CCLayer*)cNSObjectContainer__GET(mrb, layer, "@_CCNode");
}

@end
