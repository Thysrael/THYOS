/*
 * Copyright (C) 2018 bzt (bztsrc@github)
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 */
#include "types.h"
#include "mbox.h"
#include "mmu.h"
#include "printf.h"

unsigned int width, height, pitch, isrgb; /* dimensions and channel order */
unsigned char *lfb;                       /* raw frame buffer address */

/**
 * Set screen resolution to 1024x768
 */
void lfb_init()
{
    mbox[0] = 35 * 4;
    mbox[1] = MBOX_REQUEST;

    mbox[2] = 0x48003; // set phy wh
    mbox[3] = 8;
    mbox[4] = 8;
    mbox[5] = 1024; // FrameBufferInfo.width
    mbox[6] = 768;  // FrameBufferInfo.height

    mbox[7] = 0x48004; // set virt wh
    mbox[8] = 8;
    mbox[9] = 8;
    mbox[10] = 1024; // FrameBufferInfo.virtual_width
    mbox[11] = 768;  // FrameBufferInfo.virtual_height

    mbox[12] = 0x48009; // set virt offset
    mbox[13] = 8;
    mbox[14] = 8;
    mbox[15] = 0; // FrameBufferInfo.x_offset
    mbox[16] = 0; // FrameBufferInfo.y.offset

    mbox[17] = 0x48005; // set depth
    mbox[18] = 4;
    mbox[19] = 4;
    mbox[20] = 32; // FrameBufferInfo.depth

    mbox[21] = 0x48006; // set pixel order
    mbox[22] = 4;
    mbox[23] = 4;
    mbox[24] = 1; // RGB, not BGR preferably

    mbox[25] = 0x40001; // get framebuffer, gets alignment on request
    mbox[26] = 8;
    mbox[27] = 8;
    mbox[28] = 4096; // FrameBufferInfo.pointer
    mbox[29] = 0;    // FrameBufferInfo.size

    mbox[30] = 0x40008; // get pitch
    mbox[31] = 4;
    mbox[32] = 4;
    mbox[33] = 0; // FrameBufferInfo.pitch

    mbox[34] = MBOX_TAG_LAST;

    // this might not return exactly what we asked for, could be
    // the closest supported resolution instead
    if (mbox_call(MBOX_CH_PROP) && mbox[20] == 32 && mbox[28] != 0)
    {
        mbox[28] &= 0x3FFFFFFF; // convert GPU address to ARM address
        width = mbox[5];        // get actual physical width
        height = mbox[6];       // get actual physical height
        pitch = mbox[33];       // get number of bytes per line
        isrgb = mbox[24];       // get the actual channel order
        lfb = (void *)((unsigned long)mbox[28]);
        lfb = lfb + KERNEL_BASE;
    }
    else
    {
        printf("Unable to set screen resolution to 1024x768x32\n");
    }
}

/**
 * Show a picture
 */
void lfb_showpicture()
{
    int x, y;
    unsigned char *ptr = lfb;
    char pixel[4];

    // ptr += (height - homer_height) / 2 * pitch + (width - homer_width) * 2;
    for (y = 0; y < height; y++)
    {
        for (x = 0; x < width; x++)
        {
            // HEADER_PIXEL(data, pixel);
            //  the image is in RGB. So if we have an RGB framebuffer, we can copy the pixels
            //  directly, but for BGR we must swap R (pixel[0]) and B (pixel[2]) channels.
            pixel[0] = y * 255 / height;
            pixel[1] = x * 255 / width;
            pixel[2] = 100;
            *((unsigned int *)ptr) = isrgb ? (unsigned int)(pixel[2] << 16 | pixel[1] << 8 | pixel[0]) : (unsigned int)(pixel[0] << 16 | pixel[1] << 8 | pixel[2]);
            ptr += 4;
        }
        ptr += pitch - width * 4;
    }
}

void lfb_draw_area(int ix, int iy, int user_width, int user_height, unsigned char *user_ptr)
{
    unsigned char *ptr = lfb;
    unsigned char *pixel = user_ptr;
    ptr += ix + iy * pitch;
    int x, y;
    for (y = 0; y < user_height; y++)
    {
        for (x = 0; x < user_width; x++)
        {
            // HEADER_PIXEL(data, pixel);
            //  the image is in RGB. So if we have an RGB framebuffer, we can copy the pixels
            //  directly, but for BGR we must swap R (pixel[0]) and B (pixel[2]) channels.
            *((unsigned int *)ptr) = *((unsigned int *)pixel);
            ptr += 4;
            pixel += 4;
        }
        ptr += pitch - user_width * 4;
    }
}