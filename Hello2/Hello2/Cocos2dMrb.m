
#import "Cocos2dMrb.h"
#include "mruby/proc.h"
#include "mruby/hash.h"
#include "mruby/variable.h"
#include "compile.h"
#import "cocos2d.h"


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

mrb_value cLayer_initialize(mrb_state *mrb, mrb_value self)
{
    printf("cLayer_initialize\n");
    return mrb_nil_value();
}

mrb_value cSprite_initialize(mrb_state *mrb, mrb_value self)
{
    printf("cSprite_initialize\n");

    mrb_value opts;
    mrb_value file;
    mrb_value sprite;
    CCSprite *ccSprite;
    struct RClass *cObjCObject;

    mrb_get_args(mrb, "o", &opts);

    file = mrb_hash_get(mrb, opts, mrb_symbol_value(mrb_intern(mrb, "file")));
    mrb_p(mrb, file);
    char* cstr_file = mrb_string_value_cstr(mrb, &file);

    ccSprite = [CCSprite spriteWithFile:[NSString stringWithUTF8String:cstr_file]];
    [ccSprite retain];
    cObjCObject = mrb_class_get(mrb, "ObjCObject");
    sprite = mrb_obj_value(Data_Wrap_Struct(mrb, cObjCObject, &mrb_objc_object_data_type, (void*)ccSprite));
    mrb_iv_set(mrb, self, mrb_intern(mrb, "@_objc_object"), sprite);
    
    return mrb_nil_value();
}

mrb_value cSprite_position_SET(mrb_state *mrb, mrb_value self)
{
    CCSprite *ccSprite;
    mrb_value sprite;
    mrb_float width;
    mrb_float height;

    mrb_value size;
    mrb_get_args(mrb, "o", &size);
    
    sprite = mrb_iv_get(mrb, self, mrb_intern(mrb, "@_objc_object"));
    Data_Get_Struct(mrb, sprite, &mrb_objc_object_data_type, ccSprite);
    
    width  = mrb_float(mrb_iv_get(mrb, size, mrb_intern(mrb, "@width" )));
    height = mrb_float(mrb_iv_get(mrb, size, mrb_intern(mrb, "@height")));
    ccSprite.position = ccp(width, height);

    return mrb_nil_value();
}

-(void) initClasses
{
    struct RClass *cObjCObject; // class  ObjCObject
    struct RClass *mCocos2d;    // module Cocos2d
    struct RClass *cNode;       // class  Cocos2d::Node
    struct RClass *cLayer;      // class  Cocos2d::Layer
    struct RClass *cScene;      // class  Cocos2d::Scene
    struct RClass *cSprite;     // class  Cocos2d::Sprite

    cObjCObject = mrb_define_class(mrb, "ObjCObject", mrb_class_obj_get(mrb, "Object"));
    
    mCocos2d = mrb_define_module(mrb, "Cocos2d");
    mrb_define_class_method(mrb, mCocos2d, "test", mCocos2d_test, ARGS_REQ(1));
    mrb_define_class_method(mrb, mCocos2d, "winSize", mCocos2d_winSize, ARGS_NONE());

    cNode   = mrb_define_class_under(mrb, mCocos2d, "Node",   mrb_class_obj_get(mrb, "Object")); // Node < Object
    cLayer  = mrb_define_class_under(mrb, mCocos2d, "Layer",  cNode); // Layer  < Node
    mrb_define_method(mrb, cLayer, "initialize", cLayer_initialize, ARGS_ANY());
    cScene  = mrb_define_class_under(mrb, mCocos2d, "Scene",  cNode); // Scene  < Node
    cSprite = mrb_define_class_under(mrb, mCocos2d, "Sprite", cNode); // Sprite < Node
    mrb_define_method(mrb, cSprite, "initialize", cSprite_initialize, ARGS_ANY());
    mrb_define_method(mrb, cSprite, "position=",  cSprite_position_SET, ARGS_REQ(1));    
}

-(void) loadFile:(NSString*)file
{
    NSLog(@"loadFile:%@", file);
    
    FILE* f = fopen([file cStringUsingEncoding:1], "r");
    int n = mrb_compile_file(mrb, f);
    fclose(f);
    mrb_run(mrb, mrb_proc_new(mrb, mrb->irep[n]), mrb_nil_value());
}

- (void) dealloc
{
    mrb_close(mrb);
	[super dealloc];
}

@end
