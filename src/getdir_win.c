/*
 * getdir_win.c - get the library directory at runtime (fow windows)
 *  included from paths.c
 */

#include <string.h>
#include <stdarg.h>

static HINSTANCE hdll;
static int get_install_dir(char *buf, int buflen,
                           void (*errfn)(const char *msg, ...))
{
    DWORD r;
    int len;
    const char *mbpath;
    TCHAR path[MAX_PATH];

    if ((r = GetModuleFileName(hdll, path, MAX_PATH)) == 0) {
        errfn("GetModuleFileName failed");
    }
    /* remove \libgauche.dll */
    if (!PathRemoveFileSpec(path)) {
        errfn("PathRemoveFileSpec failed on %s", SCM_WCS2MBS(path));
    }
    /* remove \bin */
    if (!PathRemoveFileSpec(path)) {
        errfn("PathRemoveFileSpec failed on %s", SCM_WCS2MBS(path));
    }
    mbpath = SCM_WCS2MBS(path);
    len = (int)strlen(mbpath);
    if (len >= buflen-1) {
        errfn("Pathname too long: %s", mbpath);
    }
    strcpy(buf, mbpath);
    return len;
}

static void err(const char *fmt, ...) 
{
    va_list args;
    va_start(args, fmt);

    if (GetConsoleWindow() == NULL) {
	char buf[2048];
	vsnprintf(buf, sizeof(buf), fmt, args);
	MessageBoxA(NULL, buf, NULL, MB_OK | MB_ICONERROR);
    } else {
	vfprintf(stderr, fmt, args);
	fputc('\n', stderr);
    }
    va_end(args);
}

static void add_dll_path(HMODULE hdll, const char *orig)
{
    TCHAR path[MAX_PATH];
    size_t len;
    const char *a;
    int nc;
    DWORD r;

    if (orig[0] == '@') {
	if ((r = GetModuleFileName(hdll, path, MAX_PATH)) == 0) {
	    err("GetModuleFileName failed");
	    return;
	}
	/* remove filename */
	if (!PathRemoveFileSpec(path)) {
	    err("PathRemoveFileSpec failed on %s", SCM_WCS2MBS(path));
	    return;
	}
	/* parent directory */
	if (!PathRemoveFileSpec(path)) {
	    err("PathRemoveFileSpec failed on %s", SCM_WCS2MBS(path));
	    return;
	}
	len = _tcsclen(path);
	a = orig + 1;
    } else {
	len = 0;
	a = orig;
    }
    if ((nc = MultiByteToWideChar(
	     CP_UTF8, 0, a, -1, path + len, 0)) > sizeof(path) - len) {
	err("Pathname too long: %s", gauche_arch);
    }
    MultiByteToWideChar(CP_UTF8, 0, a, -1, path + len, sizeof(path) - len);
    AddDllDirectory(path);
}

void setup_dll_directory(HINSTANCE hmod)
{
    hdll = hmod;
    add_dll_path(hdll, gauche_arch_dir);
    add_dll_path(hdll, gauche_site_arch_dir);
}
