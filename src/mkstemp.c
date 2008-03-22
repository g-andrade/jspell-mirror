#include <fcntl.h>
#include <sys/types.h>
#include <assert.h>
#include <sys/time.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>



#include <errno.h>
#ifndef __set_errno
# define __set_errno(Val) errno = (Val)
#endif

static const char letters[] =
"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

int
__gen_tempname (char *tmpl)
{
	int len;
	char *XXXXXX;
	static uint64_t value;
	uint64_t random_time_bits;
	unsigned int count;
	int fd = -1;
	int save_errno = errno;
	struct_stat64 st;

#define ATTEMPTS_MIN (62 * 62 * 62)

#if ATTEMPTS_MIN < TMP_MAX
	unsigned int attempts = TMP_MAX;
#else
	unsigned int attempts = ATTEMPTS_MIN;
#endif

	len = strlen (tmpl);
	if (len < 6 || strcmp (&tmpl[len - 6], "XXXXXX")) {
		__set_errno (EINVAL);
		return -1;
    }

	XXXXXX = &tmpl[len - 6];

#ifdef RANDOM_BITS
	RANDOM_BITS (random_time_bits);
#else
# if HAVE_GETTIMEOFDAY || _LIBC
	{
	    struct timeval tv;
	    __gettimeofday (&tv, NULL);
	    random_time_bits = ((uint64_t) tv.tv_usec << 16) ^ tv.tv_sec;
	}
# else
	random_time_bits = time (NULL);
# endif
#endif

	value += random_time_bits ^ __getpid ();

	for (count = 0; count < attempts; value += 7777, ++count) {
		uint64_t v = value;

		/* Fill in the random bits.  */
		XXXXXX[0] = letters[v % 62];
		v /= 62;
		XXXXXX[1] = letters[v % 62];
		v /= 62;
		XXXXXX[2] = letters[v % 62];
		v /= 62;
		XXXXXX[3] = letters[v % 62];
		v /= 62;
		XXXXXX[4] = letters[v % 62];
		v /= 62;
		XXXXXX[5] = letters[v % 62];
		fd = __open (tmpl, (0 & ~ACCESSPERMS) | O_RDWR | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR);

		if (fd >= 0) {
			__set_errno (save_errno);
			return fd;
		} else if (errno != EEXIST) {
			return -1;
		}
	}

	__set_errno (EEXIST);
	return -1;
}


int mkstemp (char *template) {
	return __gen_tempname (template);
}

