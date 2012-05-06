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
}

+(id) node:(mrb_state*)mrb;

@end
