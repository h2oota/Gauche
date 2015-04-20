/*
 * dl_win.c - windows LoadLibrary interface
 *
 *   Copyright (c) 2000-2015  Shiro Kawai  <shiro@acm.org>
 *
 *   Redistribution and use in source and binary forms, with or without
 *   modification, are permitted provided that the following conditions
 *   are met:
 *
 *   1. Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *
 *   2. Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 *
 *   3. Neither the name of the authors nor the names of its contributors
 *      may be used to endorse or promote products derived from this
 *      software without specific prior written permission.
 *
 *   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 *   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 *   OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 *   TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 *   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 *   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/* This file is included in load.c */

/* NB: if we use MT, we need a special wrapper around LoadLibrary
   (see gc/gc_dlopen.c).   For the time being we assume MT is off
   on Windows version. */

#include <windows.h>

static void *dl_open(const char *path)
{
    LPTSTR xpath;
    if (strchr("/\\", path[0])
	|| isalpha(path[0]) && path[1] == ':' && strchr("/\\", path[2])
	/* don't allow filename only */
	|| strchr(path, '/') == NULL && strchr(path, '\\') == NULL) {
	xpath = (LPTSTR)SCM_MBS2WCS(path);
    } else {
	char p[PATH_MAX];
	DWORD l = GetCurrentDirectoryA(PATH_MAX, p);
	p[l++] = '/';
	strcpy_s(p + l, PATH_MAX - l, path);
	xpath = (LPTSTR)SCM_MBS2WCS(p);
    }
    return (void*)LoadLibraryEx(
	xpath, NULL, LOAD_LIBRARY_SEARCH_DEFAULT_DIRS);
}

static const char *dl_error(void)
{
    char buf[80];
    DWORD code = GetLastError();
    snprintf(buf, sizeof(buf), "error code %ld", code);
    return SCM_STRDUP(buf);
}

static ScmDynLoadInitFn dl_sym(void *handle, const char *name)
{
    return (ScmDynLoadInitFn)GetProcAddress((HMODULE)handle, name);
}

static void dl_close(void *handle)
{
    (void)FreeLibrary((HMODULE)handle);
}

