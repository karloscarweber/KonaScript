#ifndef kona_common_h
#define kona_common_h

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

// Common.h has a lot of boring settings to get things rolling, or to trip a 
// debug or feature flag.

#define NAN_BOXING
#define DEBUG_PRINT_CODE
#define DEBUG_TRACE_EXECUTION

#define DBUG_STRESS_GC
#define DEBUG_LOG_GC

#define UINT8_COUNT (UINT8_MAX +1)

#endif

#undef DEBUG_PRINT_CODE
#undef DEBUG_TRACE_EXECUTION
#undef DEBUG_STRESS_GC
#undef DEBUG_LOG_GC
