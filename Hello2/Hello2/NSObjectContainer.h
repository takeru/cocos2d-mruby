#ifndef __cNSObjectContainer_H
#define __cNSObjectContainer_H

void cNSObjectContainer_DEFINE(mrb_state *mrb);
void cNSObjectContainer__ATTACH(mrb_state *mrb, mrb_value target, NSObject *obj, const char* ivName);
NSObject* cNSObjectContainer__GET(mrb_state *mrb, mrb_value target, const char* ivName);

#endif // __cNSObjectContainer_H
