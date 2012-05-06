//
//  MrbLayer.m
//  Hello2
//
//  Created by  on 12/05/04.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MrbLayer.h"

@implementation MrbLayer

+(id) node:(mrb_state*)mrb_
{
    MrbLayer* node = [super node];
    node->mrb = mrb_;
    return node;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    mrb_value str = mrb_str_new_cstr(mrb, "B");
    mrb_funcall(mrb, mrb_top_self(mrb), "print", 1, str);
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    mrb_value str = mrb_str_new_cstr(mrb, "C");
    mrb_funcall(mrb, mrb_top_self(mrb), "print", 1, str);
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    mrb_value str = mrb_str_new_cstr(mrb, "E");
    mrb_funcall(mrb, mrb_top_self(mrb), "print", 1, str);
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    mrb_value str = mrb_str_new_cstr(mrb, "C");
    mrb_funcall(mrb, mrb_top_self(mrb), "print", 1, str);
}

@end
