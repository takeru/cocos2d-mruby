//
//  HelloWorldLayer.h
//  Hello2
//
//  Created by  on 12/04/22.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#include "mruby.h"
#include "compile.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
}

- (void) initRuby;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
