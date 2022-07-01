#include "lib.h"
#include "tsh.h"

#define TSH_DEBUG 0

char buf[BUFF_SIZE];

int _hist = 0;

Token tokens[MAX_TOKENS];
int token_cur;

Command commands[MAX_COMMANDS];
int command_cur;

void umain(int_64 argc, char **argv)
{
    print_head();

    while (1)
    {
        print_prompt();

        read_line(buf, sizeof(buf));
        if (!*buf)
        {
            continue;
        }
        save_line(buf);

        eval();
    }
}

void print_head()
{
    writef("\n:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::\n");
    writef("::                                                         ::\n");
    writef("::                      Thysrael Shell                     ::\n");
    writef("::                                                         ::\n");
    writef(":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::\n");
    writef("\n                 Can you hear me, my sweetie?\n\n");
}

void print_prompt()
{
    writef("\n\x1b[32m$\x1b[0m \n\x1b[1A\x1b[2C");
}

static void print_tokens()
{
    int i;
    if (TSH_DEBUG)
    {
        for (i = 0; i < token_cur; i++)
        {
            if (tokens[i].type != TYPE_END)
            {
                writef("token type is %d, token content is %s\n", tokens[i].type, tokens[i].content);
            }
            else
            {
                writef("token type is %d\n", tokens[i].type);
            }
        }
        writef("tokenize end.\n");
    }
}

static void print_commands()
{
    int i;

    writef("command number is %d\n", command_cur);
    if (TSH_DEBUG)
    {
        for (i = 0; i < command_cur; i++)
        {
            writef("command is %s ", commands[i].argv[0]);
            if (commands[i].file_append)
            {
                writef("append file is %s", commands[i].file_append);
            }
            if (commands[i].file_in)
            {
                writef("in file is %s", commands[i].file_in);
            }
            if (commands[i].file_out)
            {
                writef("out file is %s", commands[i].file_out);
            }
            writef("\n");
        }
        writef("parse command end\n");
    }
}

void save_line(char *buf)
{
    if (!*buf)
    {
        return;
    }
    _hist = 0;
    int his = open(".history", O_APPEND | O_WRONLY | O_CREAT);

    if (his < 0)
    {
        fwritef(STDOUT_FILENO, "cannot open history\n");
        return;
    }
    fwritef(his, "%s\n", buf);
    close(his);
}

void eval()
{
    parse_line();

    int fd[2], prev_out_fd = -1;
    int pid = 0;

    for (int i = 0; i < command_cur; i++)
    {
        pipe(fd);
        pid = fork();
        if (pid == 0)
        {
            if (i == command_cur - 1)
                close(fd[1]);
            close(fd[0]);
            execute_command(commands[i], prev_out_fd, (i == command_cur - 1) ? -1 : fd[1]);
            exit();
        }
        close(prev_out_fd);
        prev_out_fd = fd[0];
        close(fd[1]);
    }

    if (prev_out_fd > 0)
    {
        close(prev_out_fd);
    }
    if (pid)
    {
        wait(pid);
    }
}

void parse_line()
{
    parse_init();
    tokenize();
    print_tokens();
    parse_commands();
    print_commands();
}

void parse_init()
{
    user_bzero((void *)tokens, sizeof(tokens));
    token_cur = 0;
    user_bzero((void *)commands, sizeof(tokens));
    command_cur = 0;
}

void tokenize()
{
    char *cur = buf;
    char *start;
    State state = STATE_NORMAL;
    // skip the ' '
    while (*cur && (*cur == ' '))
        cur++;

    start = cur;
    buf[strlen(buf)] = '\0';

    while (1)
    {
        if (state == STATE_NORMAL)
        {
            if (*cur == ' ' || *cur == '>' || *cur == '<' || *cur == '|' || *cur == '\0')
            {
                tokens[token_cur].content = start;
                tokens[token_cur++].type = TYPE_NORMAL;
                if (*cur == ' ')
                    state = STATE_INTERVAL;
                else if (*cur == '>')
                    state = STATE_OUT_REDIRECT;
                else if (*cur == '<')
                    state = STATE_IN_REDIRECT;
                else if (*cur == '|')
                    state = STATE_PIPE;
                else if (*cur == '\0')
                    state = STATE_END;

                *cur = '\0';
            }
        }
        else if (state == STATE_INTERVAL)
        {
            if (*cur == '>')
            {
                start = cur;
                state = STATE_OUT_REDIRECT;
            }
            else if (*cur == '<')
            {
                start = cur;
                state = STATE_IN_REDIRECT;
            }
            else if (*cur == '|')
            {
                start = cur;
                state = STATE_PIPE;
            }
            else if (*cur == ' ')
            {
                state = STATE_INTERVAL;
            }
            else if (*cur == '\'')
            {
                start = cur + 1;
                state = STATE_SINGLE_STR;
            }
            else if (*cur == '\"')
            {
                start = cur + 1;
                state = STATE_DOUBLE_STR;
            }
            else if (*cur == '\0')
            {
                state = STATE_END;
            }
            else
            {
                start = cur;
                state = STATE_NORMAL;
            }
        }
        else if (state == STATE_SINGLE_STR)
        {
            if (*cur == '\'')
            {
                *cur = '\0';
                tokens[token_cur].content = start;
                tokens[token_cur++].type = TYPE_NORMAL;
                state = STATE_INTERVAL;
            }
        }
        else if (state == STATE_DOUBLE_STR)
        {
            if (*cur == '\"')
            {
                *cur = '\0';
                tokens[token_cur].content = start;
                tokens[token_cur++].type = TYPE_NORMAL;
                state = STATE_INTERVAL;
            }
        }
        else if (state == STATE_PIPE)
        {
            tokens[token_cur].content = "|";
            tokens[token_cur++].type = TYPE_PIPE;
            if (*cur == ' ')
            {
                state = STATE_INTERVAL;
            }
            else
            {
                start = cur;
                state = STATE_NORMAL;
            }
        }
        else if (state == STATE_IN_REDIRECT)
        {
            tokens[token_cur].content = "<";
            tokens[token_cur++].type = TYPE_IN_REDIRECT;
            if (*cur == ' ')
            {
                state = STATE_INTERVAL;
            }
            else
            {
                start = cur;
                state = STATE_NORMAL;
            }
        }
        else if (state == STATE_OUT_REDIRECT)
        {
            if (*cur == '>')
            {
                state = STATE_OUT_APPEND;
            }
            else
            {
                tokens[token_cur].content = ">";
                tokens[token_cur++].type = TYPE_OUT_REDIRECT;
                if (*cur == ' ')
                {
                    state = STATE_INTERVAL;
                }
                else
                {
                    start = cur;
                    state = STATE_NORMAL;
                }
            }
        }
        else if (state == STATE_OUT_APPEND)
        {
            tokens[token_cur].content = ">>";
            tokens[token_cur++].type = TYPE_OUT_APPEND;
            if (*cur == ' ')
            {
                state = STATE_INTERVAL;
            }
            else
            {
                start = cur;
                state = STATE_NORMAL;
            }
        }
        else if (state == STATE_END)
        {
            tokens[token_cur].content = NULL;
            tokens[token_cur++].type = TYPE_END;
            break;
        }
        cur++;
    }
}

void parse_commands()
{
    token_cur = 0;
    command_cur = 0;
    while (tokens[token_cur].type != TYPE_END)
    {
        while (tokens[token_cur].type != TYPE_END && tokens[token_cur].type != TYPE_PIPE)
        {
            if (tokens[token_cur].type == TYPE_NORMAL)
            {
                commands[command_cur].argv[commands[command_cur].argc++] = tokens[token_cur].content;
            }
            else if (tokens[token_cur].type == TYPE_IN_REDIRECT)
            {
                commands[command_cur].file_in = tokens[++token_cur].content;
            }
            else if (tokens[token_cur].type == TYPE_OUT_REDIRECT)
            {
                commands[command_cur].file_out = tokens[++token_cur].content;
            }
            else if (tokens[token_cur].type == TYPE_OUT_APPEND)
            {
                commands[command_cur].file_append = tokens[++token_cur].content;
            }
            token_cur++;
        }
        // we need it to execvp
        command_cur++;
        if (tokens[token_cur].type == TYPE_PIPE)
        {
            token_cur++;
        }
    }
}

void execute_command(Command command, int fd_in, int fd_out)
{
    //writef("execute:fd in is %d, fd out is %d\n", fd_in, fd_out);
    if (!builtin_command(command))
    {
        int command_pid;
        if (command.file_in)
        {
            int in = open(command.file_in, O_RDONLY);
            dup(in, STDIN_FILENO);
            close(in);
            close(fd_in);
        }
        else if (fd_in > 0)
        {
            dup(fd_in, STDIN_FILENO);
            close(fd_in);
        }

        if (command.file_out)
        {
            int out = open(command.file_out, O_RDWR | O_CREAT | O_TRUNC);
            dup(out, STDOUT_FILENO);
            close(out);
            close(fd_out);
        }
        else if (command.file_append)
        {
            int append = open(command.file_append, O_WRONLY | O_CREAT | O_APPEND);
            dup(append, STDOUT_FILENO);
            close(append);
            close(fd_out);
        }
        else if (fd_out > 0)
        {
            dup(fd_out, STDOUT_FILENO);
            close(fd_out);
        }
        command_pid = spawn(command.argv[0], command.argv);
        close_all();
        wait(command_pid);
    }
}

int builtin_command(Command command)
{
    if (!strcmp(command.argv[0], "quit"))
    {
        exit();
        return 1;
    }
    else if (!strcmp(command.argv[0], "clear"))
    {
        writef("\x1b[2J\x1b[H");
        return 1;
    }
    return 0;
}

int hist(char *buf, int up)
{
    static int last = 0;
    static char history_info[1024];
    if (!_hist)
    {
        struct Stat state;
        if (stat(".history", &state) < 0)
        {
            return 0;
        }
        int his = open(".history", O_RDONLY);
        if (his < 0)
        {
            return 0;
        }
        read(his, history_info, state.st_size);
        history_info[state.st_size] = 0;
        close(his);
    }
    int i, j, ofst;
    if (_hist <= 1 && !up)
    {
        _hist = 0;
        last = _hist == 1 ? up : 0;
        return 0;
    }
    if (!last)
    {
        ofst = _hist + (up ? 1 : -1);
    }
    else
    {
        if (last > 0)
        {
            if (up)
                return 0;
            else
                ofst = _hist;
        }
        else
        {
            if (!up)
                return 0;
            else
                ofst = _hist;
        }
    }

    for (j = 0; history_info[j] && ofst != 0; ++j)
    {
        if (history_info[j] == '\n')
        {
            ofst--;
        }
    }
    if (ofst != 0)
    {
        last = up ? 1 : -1;
        return 0;
    }

    for (i = 0; history_info[j]; ++j)
    {
        if (history_info[j] == '\n')
        {
            while (history_info[i] != '\n')
                ++i;
            ++i;
        }
    }
    char *ptr = buf;
    for (;; i++)
    {
        if (history_info[i] == '\n')
        {
            *ptr = 0;
            break;
        }
        *ptr = history_info[i];
        ++ptr;
    }
    fwritef(STDOUT_FILENO, "%s", buf);
    if (!last)
    {
        if (up)
        {
            _hist++;
        }
        else
        {
            _hist--;
        }
    }
    last = 0;
    return ptr - buf;
}

void read_line(char *buf, u_int n)
{
    int i, r;
    char tmp;
    r = 0;
    for (i = 0; i < n; i++)
    {
        if ((r = read(0, buf + i, 1)) != 1)
        {
            if (r < 0)
            {
                writef("read error: %e", r);
            }
            exit();
        }

        // 0x7f means backspace
        if (buf[i] == 0x7f)
        {
            if (i > 0)
            {
                // D means move the cursor backward, K means erase the char
                fwritef(STDOUT_FILENO, "\x1b[1D\x1b[K");
                i -= 2;
            }
            else
            {
                i = -1;
            }
        }
        else if (buf[i] == '\x1b')
        {
            read(0, &tmp, 1);
            if (tmp != '[')
            {
                user_panic("\\x1b is not followed by '['");
            }
            read(0, &tmp, 1);

            // means UP
            if (tmp == 'A')
            {
                if (i)
                {
                    // delete the existed line
                    fwritef(STDOUT_FILENO, "\x1b[1B\x1b[%dD\x1b[K", i);
                }
                else
                {
                    fwritef(STDOUT_FILENO, "\x1b[1B");
                }
                i = hist(buf, 1);
            }
            else if (tmp == 'B')
            {
                if (i)
                {
                    fwritef(STDOUT_FILENO, "\x1b[1A\x1b[%dD\x1b[K", i);
                }
                else
                {
                    fwritef(STDOUT_FILENO, "\x1b[1A");
                }
                i = hist(buf, 0);
            }
            else if (tmp == 'C')
            {
                fwritef(STDOUT_FILENO, "\x1b[1D");
            }
            else if (tmp == 'D')
            {
                fwritef(STDOUT_FILENO, "\x1b[1C");
            }
            i--;
        }

        else if (buf[i] == '\r' || buf[i] == '\n')
        {
            buf[i] = 0;
            return;
        }
    }
    writef("line too long\n");
    while ((r = read(0, buf, 1)) == 1 && buf[0] != '\n')
        ;
    buf[0] = 0;
}
