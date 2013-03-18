/*
 
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 
*/

/* ---------------------------------------------------------------------------
 ** Texas Christian University
 **
 ** Global.h
 ** TBES
 **
 ** Created on 12/4/12
 ** Kenneth Leising
 ** Catherine Urbano
 ** Danny Westfall
 ** 
 ** -------------------------------------------------------------------------*/

#define VERBOSE_LOGGING

#ifdef VERBOSE_LOGGING
#define TLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define TLog(format, ...)
#endif

#define TString(key) [[NSBundle mainBundle] localizedStringForKey:key value:@"None" table: @"TBES"]