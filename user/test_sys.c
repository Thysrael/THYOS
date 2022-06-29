#include "lib.h"
#include "env.h"

extern struct Env *env;

// void func(uint_64 x1, uint_64 x2, uint_64 x3)
// {
//     register uint_64 r1 asm("x0");
//     register uint_64 r2 asm("x1");
//     register uint_64 r3 asm("x2");

//     // writef("x1 = %lx\n", r1);
//     writef("x2 = %lx\n", r2);
//     //writef("x3 = %lx\n", r3);
// }

void umain()
{
    writef("env id is 0x%lx.\n", env->env_id);
    writef(" _    _  ______  _   _ ______\n");
    writef("| |  | ||___  / | \\ | || ___ \\\n");
    writef("| |  | |   / /  |  \\| || |_/ /\n");
    writef("| |/\\| |  / /   | . ` || ___ \\\n");
    writef("\\  /\\  /./ /___ | |\\  || |_/ /\n");
    writef(" \\/  \\/ \\_____/ \\_| \\_/\\____/\n");
    writef("\n");
}
