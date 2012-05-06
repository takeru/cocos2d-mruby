//
//  MrbLayer.m
//  Hello2
//
//  Created by  on 12/05/04.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MrbLayer.h"

@implementation MrbLayer

-(void) setMrb:(mrb_state*)mrb_ andValue:(mrb_value)value_
{
    self->mrb   = mrb_;
    self->value = value_;
}

-(void) released
{
    self->mrb   = NULL;
    self->value = mrb_nil_value();
}

-(void) scheduleTick:(ccTime)interval
{
    if(0.0 < interval){
        [self schedule: @selector(tick:) interval:interval];
    }else{
        [self unschedule: @selector(tick:)];
    }
}

-(void) tick:(ccTime)dt
{
    if(mrb_nil_p(value)){
        return;
    }
    mrb_funcall(mrb, value, "tick", 1, mrb_float_value(dt));
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(mrb_nil_p(value)){
        return;
    }
    mrb_value ev = mrb_nil_value(); // TODO convert from event
    mrb_funcall(mrb, value, "touchesBegan", 1, ev);
    
    //mrb_value str = mrb_str_new_cstr(mrb, "B");
    //mrb_funcall(mrb, mrb_top_self(mrb), "print", 1, str);
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(mrb_nil_p(value)){
        return;
    }
    mrb_value ev = mrb_nil_value(); // TODO convert from event
    mrb_funcall(mrb, value, "touchesMoved", 1, ev);

    //mrb_value str = mrb_str_new_cstr(mrb, "C");
    //mrb_funcall(mrb, mrb_top_self(mrb), "print", 1, str);
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(mrb_nil_p(value)){
        return;
    }
    mrb_value ev = mrb_nil_value(); // TODO convert from event
    mrb_funcall(mrb, value, "touchesEnded", 1, ev);

    //mrb_value str = mrb_str_new_cstr(mrb, "E");
    //mrb_funcall(mrb, mrb_top_self(mrb), "print", 1, str);
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(mrb_nil_p(value)){
        return;
    }
    mrb_value ev = mrb_nil_value(); // TODO convert from event
    mrb_funcall(mrb, value, "touchesCancelled", 1, ev);
    
    //mrb_value str = mrb_str_new_cstr(mrb, "C");
    //mrb_funcall(mrb, mrb_top_self(mrb), "print", 1, str);
}

@end
