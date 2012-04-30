
#import "Cocos2dMrb.h"
#include "mruby/proc.h"
#include "mruby/hash.h"
#include "mruby/variable.h"
#include "compile.h"


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


void objc_object_free(mrb_state *mrb, void *p)
{
    printf("objc_object_free p=%x\n", (unsigned int)p);
    [((NSObject*)p) release];
}

struct mrb_data_type mrb_objc_object_data_type = {
    "objc_object", objc_object_free,
};

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
    // printf("cNode_initialize\n");

    return self;
}

void cNode__set_CCNode(mrb_state *mrb, mrb_value self, CCNode *ccNode)
{
    mrb_value node;
    struct RClass *cObjCObject;

    [ccNode retain];
    cObjCObject = mrb_class_get(mrb, "ObjCObject");
    node = mrb_obj_value(Data_Wrap_Struct(mrb, cObjCObject, &mrb_objc_object_data_type, (void*)ccNode));
    mrb_iv_set(mrb, self, mrb_intern(mrb, "@_CCNode"), node);
}

CCNode* cNode__get_CCNode(mrb_state *mrb, mrb_value self)
{
    CCNode *ccNode;
    mrb_value node;

    node = mrb_iv_get(mrb, self, mrb_intern(mrb, "@_CCNode"));
    Data_Get_Struct(mrb, node, &mrb_objc_object_data_type, ccNode);

    return ccNode;
}

mrb_value cNode_position_SET(mrb_state *mrb, mrb_value self)
{
    CCNode *ccNode;
    mrb_float width;
    mrb_float height;
    
    mrb_value size;
    mrb_get_args(mrb, "o", &size);
    
    ccNode = cNode__get_CCNode(mrb, self);
    
    width  = mrb_float(mrb_iv_get(mrb, size, mrb_intern(mrb, "@width" )));
    height = mrb_float(mrb_iv_get(mrb, size, mrb_intern(mrb, "@height")));
    ccNode.position = ccp(width, height);

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

    childCCNode = cNode__get_CCNode(mrb, child);
    
    // TODO z, tag
    
    selfCCNode = cNode__get_CCNode(mrb, self);
    // mrb_p(mrb, self);
    [selfCCNode addChild:childCCNode];

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

    CCLayer *ccLayer;
    ccLayer = [CCLayer node];
    cNode__set_CCNode(mrb, self, ccLayer);

    return self;
}

mrb_value cSprite_initialize(mrb_state *mrb, mrb_value self)
{
    self = cNode_initialize(mrb, self);
    // printf("cSprite_initialize\n");

    mrb_value opts;
    mrb_value file;
    CCSprite *ccSprite;

    mrb_get_args(mrb, "o", &opts);

    file = mrb_hash_get(mrb, opts, mrb_symbol_value(mrb_intern(mrb, "file")));
    // mrb_p(mrb, file);
    char* cstr_file = mrb_string_value_cstr(mrb, &file);

    ccSprite = [CCSprite spriteWithFile:[NSString stringWithUTF8String:cstr_file]];
    cNode__set_CCNode(mrb, self, ccSprite);

    return self;
}

-(void) initClasses
{
    struct RClass *cObjCObject; // class  ObjCObject
    struct RClass *mCocos2d;    // module Cocos2d
    struct RClass *cNode;       // class  Cocos2d::Node
    struct RClass *cScene;      // class  Cocos2d::Scene
    struct RClass *cLayer;      // class  Cocos2d::Layer
    struct RClass *cSprite;     // class  Cocos2d::Sprite

    cObjCObject = mrb_define_class(mrb, "ObjCObject", mrb_class_obj_get(mrb, "Object"));
    
    mCocos2d = mrb_define_module(mrb, "Cocos2d");
    mrb_define_class_method(mrb, mCocos2d, "test", mCocos2d_test, ARGS_REQ(1));
    mrb_define_class_method(mrb, mCocos2d, "winSize", mCocos2d_winSize, ARGS_NONE());

    cNode   = mrb_define_class_under(mrb, mCocos2d, "Node",   mrb_class_obj_get(mrb, "Object")); // Node < Object
    mrb_define_method(mrb, cNode, "initialize", cNode_initialize,   ARGS_ANY());
    mrb_define_method(mrb, cNode, "position=",  cNode_position_SET, ARGS_REQ(1));
    mrb_define_method(mrb, cNode, "addChild",   cNode_addChild,     ARGS_ANY());

    cLayer  = mrb_define_class_under(mrb, mCocos2d, "Layer",  cNode); // Layer  < Node
    mrb_define_method(mrb, cLayer, "initialize", cLayer_initialize, ARGS_ANY());

    cScene  = mrb_define_class_under(mrb, mCocos2d, "Scene",  cNode); // Scene  < Node
    mrb_define_method(mrb, cScene, "initialize", cScene_initialize, ARGS_ANY());
    
    cSprite = mrb_define_class_under(mrb, mCocos2d, "Sprite", cNode); // Sprite < Node
    mrb_define_method(mrb, cSprite, "initialize", cSprite_initialize, ARGS_ANY());
}

-(void) loadFile:(NSString*)file
{
    // NSLog(@"loadFile:%@", file);
    
    FILE* f = fopen([file cStringUsingEncoding:1], "r");
    int n = mrb_compile_file(mrb, f);
    fclose(f);
    mrb_run(mrb, mrb_proc_new(mrb, mrb->irep[n]), mrb_nil_value());
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
    return (CCLayer*)cNode__get_CCNode(mrb, layer);
}

@end
