#ifndef _PRINT_H_
#define _PRINT_H_

#include <stdarg.h>

/* this is the maximum width for a variable */
#define		LP_MAX_BUF	1000

/* -*-
 * output function takes an void pointer which is passed in as the
 * second argument in lp_Print().  This black-box argument gives output
 * function a way to track state.
 *
 * The second argument in output function is a pointer to char buffer.
 * The third argument specifies the number of chars to outputed.
 *
 * output function cannot assume the buffer is null-terminated after
 * l number of chars.
 */
void lp_Print(void (*output)(void *, char *, int),
			  void *arg,
			  char *fmt,
			  va_list ap);

#endif