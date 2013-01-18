//
//  Globals.h
//  TBES
//
//  Created by Danny Westfall on 12/4/12.
//  Copyright (c) 2012 TCU. All rights reserved.
//


#define VERBOSE_LOGGING

#ifdef VERBOSE_LOGGING
#define TLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define TLog(format, ...)
#endif