#ifndef _TSH_H_
#define _TSH_H_

#define MAX_TOKENS      128
#define MAX_ARGS        64
#define MAX_COMMANDS    16
#define BUFF_SIZE       256

// 'Type' is the command word type
typedef enum
{
    TYPE_NORMAL,
    TYPE_IN_REDIRECT,
    TYPE_OUT_REDIRECT,
    TYPE_OUT_APPEND,
    TYPE_PIPE,
    TYPE_END
} Type;

// 'STATE' is the FSM state
typedef enum
{
    STATE_NORMAL,
    STATE_END,
    STATE_INTERVAL,
    STATE_PIPE,
    STATE_OUT_REDIRECT,
    STATE_OUT_APPEND,
    STATE_IN_REDIRECT,
    STATE_SINGLE_STR,
    STATE_DOUBLE_STR
} State;

typedef struct
{
    int argc;
    char *argv[MAX_ARGS];
    char *file_in;
    char *file_out;
    char *file_append;
} Command;

typedef struct
{
    char *content;
    Type type;
} Token;

void print_head();
void print_prompt();
void save_line(char *buf);
int hist(char *buf, int up);
void read_line(char *buf, u_int n);
void eval();
void parse_line();
void parse_init();
void tokenize();
void parse_commands();
void execute_command(Command command, int fd_in, int fd_out);
int builtin_command(Command command);

#endif
