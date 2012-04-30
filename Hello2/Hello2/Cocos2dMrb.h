
#import <Foundation/Foundation.h>

#include "Cocos2dMrb.h"
#include "mruby.h"

@interface Cocos2dMrb : NSObject
{
    mrb_state* mrb;
}
//@property mrb_state* mrb;

-(void) loadFile:(NSString*)file;

@end
