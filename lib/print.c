#include "print.h"

#define		IsDigit(x)	( ((x) >= '0') && ((x) <= '9') )
#define		Ctod(x)		( (x) - '0')

/* forward declaration */
static int PrintChar(char *, char, int, int);
static int PrintString(char *, char *, int, int);
static int PrintNum(char *, unsigned long, int, int, int, int, char, int);

/* private variable */
static const char theFatalMsg[] = "fatal error in lp_Print!";

/* 
 * A low level printf() function.
 */

void lp_Print(void (*output)(void *, char *, int), void * arg, char *fmt, va_list ap)
{
// 'arg' I don't know. 's' is the output string, 'l' is the length of 's'
#define OUTPUT(arg, s, l)										            \
        {																	\
            if (((l) < 0) || ((l) > LP_MAX_BUF))							\
            {																\
                (*output)(arg, (char*)theFatalMsg, sizeof(theFatalMsg) - 1);\
                for(;;);													\
            }																\
            else															\
            {																\
                (*output)(arg, s, l);										\
            }																\
        }
    
    char buf[LP_MAX_BUF];

    char c;
    char *s;
    long int num;

    int longFlag;
    int negFlag;
    int width;
    int prec;
    int ladjust;
    char padc;

    int length;

    while(1) 
	{
        /* Part1: your code here */ 
	    /* scan for the next '%' */
		char* cur = fmt;
		while(1)
		{
			if (*cur == '\0')
			{
				break;
			}
			if (*cur == '%')
			{
				break;
			}
			cur++;
		}
	    // flush the string found so far 
		OUTPUT(arg, fmt, cur - fmt);
		fmt = cur;

	    // we found a '\0'
		if (*fmt == '\0')
		{
			break;
		}
        /* we found a '%' */
        else
        {
            fmt++;
        }

		// parse the flags
        // the default flags
		padc = ' ';         // padc means the filled leading charactor
		ladjust = 0;        // ladjust is 1, we need to left adjust
        while((*fmt == '-') || (*fmt == '0'))
        {
            if (*fmt == '-')
            {
                ladjust = 1;
            }
            else if (*fmt == '0')
            {
                padc = '0';
            }

            fmt++;
        }
		
		// parse the width
		width = 0;
		while (IsDigit(*fmt))
		{
			width = width * 10 + Ctod(*fmt);
			fmt++;	
		}

		// parse the precision
		if (*fmt == '.')
		{
			prec = 0;
			fmt++;
			while (IsDigit(*fmt))
			{
				prec = prec * 10 + Ctod(*fmt);
				fmt++;
			}
		}
        // the default precision
		else
		{
			prec = 6;
		}

		// parse the length, which is a flag
		longFlag = 0;
		if (*fmt == 'l')
		{
			longFlag = 1;
			fmt++;
		}

		negFlag = 0;
		switch (*fmt) 
		{
		case 'b':
			if (longFlag) 
			{ 
				num = va_arg(ap, long int); 
			} 
			else 
			{ 
				num = va_arg(ap, int);
			}
			length = PrintNum(buf, num, 2, negFlag, width, ladjust, padc, 0);
            // buf is the string we need to output
			OUTPUT(arg, buf, length);
			break;

		case 'd':
		case 'D':
			if (longFlag) 
			{ 
			    num = va_arg(ap, long int);
			} 
			else 
			{ 
				num = va_arg(ap, int); 
			 }
	    
			if (num < 0)
			{
				negFlag = 1;
				num = -num;
			}
			length = PrintNum(buf, num, 10, negFlag, width, ladjust, padc, 0);
			OUTPUT(arg, buf, length);
			break;

		case 'o':
		case 'O':
			if (longFlag) 
			{ 
				num = va_arg(ap, long int);
			} 
			else 
			{ 
				num = va_arg(ap, int); 
			}
			length = PrintNum(buf, num, 8, negFlag, width, ladjust, padc, 0);
			OUTPUT(arg, buf, length);
			break;

		case 'u':
		case 'U':
			if (longFlag) 
			{ 
				num = va_arg(ap, long int);
			} 
			else 
			{ 
				num = va_arg(ap, int); 
			}
			length = PrintNum(buf, num, 10, negFlag, width, ladjust, padc, 0);
			OUTPUT(arg, buf, length);
			break;
	    
		case 'x':
			if (longFlag) 
			{ 
				num = va_arg(ap, long int);
			} 
			else 
			{ 
				num = va_arg(ap, int); 
			}
			length = PrintNum(buf, num, 16, negFlag, width, ladjust, padc, 0);
			OUTPUT(arg, buf, length);
			break;

		case 'X':
			if (longFlag) 
			{ 
				num = va_arg(ap, long int);
			} 
			else 
			{ 
				num = va_arg(ap, int); 
			}
			length = PrintNum(buf, num, 16, negFlag, width, ladjust, padc, 1);
			OUTPUT(arg, buf, length);
			break;

		case 'c':
			c = (char)va_arg(ap, int);
			length = PrintChar(buf, c, width, ladjust);
			OUTPUT(arg, buf, length);
			break;

		case 's':
			s = (char*)va_arg(ap, char *);
			length = PrintString(buf, s, width, ladjust);
			OUTPUT(arg, buf, length);
	    break;

		case '\0':
			fmt--;
			break;

		default:
			// something like "%%"
			OUTPUT(arg, fmt, 1);
		}	

		fmt ++;
    }

    /* special termination call */
    OUTPUT(arg, "\0", 1);
}


/* --------------- local help functions --------------------- */
int PrintChar(char * buf, char c, int length, int ladjust)
{
    int i;
    
    if (length < 1) 
        length = 1;
    if (ladjust) 
	{
		*buf = c;
		for (i = 1; i < length; i++) 
			buf[i] = ' ';
    } 
	else 
	{
		for (i = 0; i < length-1; i++) 
			buf[i] = ' ';
		buf[length - 1] = c;
    }
    return length;
}

int PrintString(char * buf, char* s, int length, int ladjust)
{
    int i;
    int len = 0;
    // get the length of string
    char* cur = s;
    while (*cur++) 
		len++;
    
    if (length < len) 
		length = len;

    if (ladjust) 
	{
		for (i = 0; i < len; i++) 
			buf[i] = s[i];
		for (i = len; i < length; i++) 
			buf[i] = ' ';
    } 
	else 
	{
		for (i = 0; i < length-len; i++) 
			buf[i] = ' ';
		for (i = length - len; i < length; i++) 
			buf[i] = s[i - length + len];
    }
    return length;
}

// u is the num need to output
// this function only process the unsigned number !!!
int PrintNum(char * buf, unsigned long u, int base, int negFlag, 
	        int length, int ladjust, char padc, int upcase)
{
    /* algorithm :
     *  1. prints the number from left to right in reverse form.
     *  2. fill the remaining spaces with padc if length is longer than
     *     the actual length
     *     TRICKY : if left adjusted, no "0" padding.
     *		    if negtive, insert  "0" padding between "0" and number.
     *  3. if (!ladjust) we reverse the whole string including paddings
     *  4. otherwise we only reverse the actual string representing the num.
     */

    int actualLength = 0;
    char *p = buf;
    int i;

    do 
	{
		int tmp = u % base;
		if (tmp <= 9) 
		{
			*p++ = '0' + tmp;
		} 
		else if (upcase) 
		{
			*p++ = 'A' + tmp - 10;
		} 
		else 
		{
			*p++ = 'a' + tmp - 10;
		}
		u /= base;
    } while (u != 0);

    if (negFlag) 
	{
		*p++ = '-';
    }

    // figure out actual length and adjust the maximum length
    actualLength = p - buf;
    if (length < actualLength) 
		length = actualLength;

    // if the format is left adjust, the padc must be space
    if (ladjust) 
	{
		padc = ' ';
    }
    // when the num is negative, format is right adjust and the padc is '0'
    if (negFlag && !ladjust && (padc == '0')) 
	{
		for (i = actualLength-1; i< length-1; i++) 
			buf[i] = padc;

		buf[length -1] = '-';
    } 
	else 
	{
		for (i = actualLength; i< length; i++) 
            buf[i] = padc;
    }
	    
    // reverse the string
	int begin = 0;
	int end;
	if (ladjust) 
	{
	    end = actualLength - 1;
	} 
	else 
	{
	    end = length -1;
	}

	while (end > begin) 
	{
	    char tmp = buf[begin];
	    buf[begin] = buf[end];
	    buf[end] = tmp;
	    begin++;
	    end--;
	}
    
    /* adjust the string pointer */
    return length;
}
