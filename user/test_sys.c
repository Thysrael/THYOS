#include "lib.h"
#include "env.h"

extern struct Env *env;

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
