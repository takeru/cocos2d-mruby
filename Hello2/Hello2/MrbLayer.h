//
//  MrbLayer.h
//  Hello2
//
//  Created by  on 12/05/04.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"

@interface MrbLayer : CCLayer
{
    mrb_state* mrb;
    mrb_value value;
}

-(void) setMrb:(mrb_state*)mrb andValue:(mrb_value)value;
-(void) released;
-(void) scheduleTick:(ccTime)interval;

@end
