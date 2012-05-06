//
//  MrbSprite.h
//  Hello2
//
//  Created by  on 12/05/06.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCSprite.h"

@interface MrbSprite : CCSprite
{
    mrb_state* mrb;
    mrb_value value;
}

-(void) setMrb:(mrb_state*)mrb andValue:(mrb_value)value;
-(void) released;
-(void) scheduleTick:(ccTime)interval;

@end
