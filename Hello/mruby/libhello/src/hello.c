#include "hello.h"
#include "mruby.h"
#include "mruby/string.h"
#include "mruby/proc.h"
#include "compile.h"
#include <stdio.h>

int hello_hello_clang(int a)
{
  printf("Hello from C-lang a=%d\n", a);
  return a;
}

int hello_hello_mruby(int a)
{
  int n;
  mrb_state* mrb;
  struct mrb_parser_state* st;
  char* code =
    "[1,2,3].each {|x|        " \
    "  puts \"Hello from mruby! x=#{x}\"" \
    "}                        ";

  mrb = mrb_open();
  st = mrb_parse_string(mrb, code);
  n = mrb_generate_code(mrb, st->tree);
  mrb_pool_close(st->pool);
  mrb_run(mrb, mrb_proc_new(mrb, mrb->irep[n]), mrb_nil_value());
    
  return a;
}
