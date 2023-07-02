#ifndef WAGENT_LIB_UTILS_H
#define WAGENT_LIB_UTILS_H

#define WAGENT_ONE 1
#define WAGENT_PATH_DELIM '/'
#define WAGENT_STR_TERM '\0'
#define WAGENT_UINT64_BYTES_COUNT 8
#define WAGENT_UINT64_BITS_COUNT 64

#define WAGENT_STATUS_OK 0
#define WAGENT_STATUS_BLB_ENOENT 166

void wagent_utils_btox(char *xp, char *bb, int n);
void wagent_utils_btox_print(char *bb, int bytesLen);

#endif // WAGENT_LIB_UTILS_H