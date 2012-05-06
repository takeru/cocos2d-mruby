//
//  MrbSprite.m
//  Hello2
//
//  Created by  on 12/05/06.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MrbSprite.h"
#import "ccTypes.h"

@implementation MrbSprite

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

@end
