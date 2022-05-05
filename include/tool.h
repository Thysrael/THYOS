#ifndef _TOOL_H_
#define _TOOL_H_

void alouha();

void print_stack();

void print_exception_level();

int get_EL();

void bcopy(const void *src, void *dst, unsigned long len);

void bzero(void *b, unsigned long len);

#endif