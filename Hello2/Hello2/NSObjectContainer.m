

#include "mruby/data.h";
#include "mruby/variable.h";


void nsobject_container_free(mrb_state *mrb, void *p)
{
    id obj = (NSObject*)p;
    NSUInteger c = [obj retainCount];
    printf("nsobject_container_free p=%x retain_count=%d->%d \n", (unsigned int)p, c, c-1);
    if([obj respondsToSelector:@selector(released)]){
        [obj released];
    }
    [obj release];
}

struct mrb_data_type mrb_data_type_nsobject_container = {
    "nsobject_container", nsobject_container_free,
};

mrb_value cNSObjectContainer_nsobject_pointer(mrb_state *mrb, mrb_value self)
{
    NSObject* p;
    Data_Get_Struct(mrb, self, &mrb_data_type_nsobject_container, p);
    return mrb_fixnum_value((mrb_int)p);
}

mrb_value cNSObjectContainer_retain_count(mrb_state *mrb, mrb_value self)
{
    NSObject* p;
    Data_Get_Struct(mrb, self, &mrb_data_type_nsobject_container, p);
    return mrb_fixnum_value((mrb_int)([p retainCount]));
}

void cNSObjectContainer__ATTACH(mrb_state *mrb, mrb_value target, NSObject *obj, const char* ivName)
{
    mrb_value container;
    struct RClass *cNSObjectContainer;

    [obj retain];
    cNSObjectContainer = mrb_class_get(mrb, "NSObjectContainer");
    container = mrb_obj_value(Data_Wrap_Struct(mrb, cNSObjectContainer, &mrb_data_type_nsobject_container, (void*)obj));
    mrb_iv_set(mrb, target, mrb_intern(mrb, ivName), container);
}

NSObject* cNSObjectContainer__GET(mrb_state *mrb, mrb_value target, const char* ivName)
{
    NSObject *obj;
    mrb_value container;
    
    container = mrb_iv_get(mrb, target, mrb_intern(mrb, ivName));
    Data_Get_Struct(mrb, container, &mrb_data_type_nsobject_container, obj);
    
    return obj;
}

void cNSObjectContainer_DEFINE(mrb_state *mrb)
{
    struct RClass *cNSObjectContainer;

    cNSObjectContainer = mrb_define_class(mrb, "NSObjectContainer", mrb_class_obj_get(mrb, "Object"));
    mrb_define_method(mrb, cNSObjectContainer, "nsobject_pointer", cNSObjectContainer_nsobject_pointer, ARGS_NONE());
    mrb_define_method(mrb, cNSObjectContainer, "retain_count",     cNSObjectContainer_retain_count,     ARGS_NONE());
}


