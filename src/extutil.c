#include "gauche.h"
#include "gauche/collection.h"
#include "gauche/builtin-classes.h"
#pragma data_seg()
#include "gauche/builtin-classes.ci"

/* class.c */
ScmClass *Scm_DefaultCPL[] = {
    SCM_CLASS_STATIC_PTR(Scm_TopClass),
    NULL
};
ScmClass *Scm_ObjectCPL[] = {
    SCM_CLASS_STATIC_PTR(Scm_ObjectClass),
    SCM_CLASS_STATIC_PTR(Scm_TopClass),
    NULL
};
/* collection.c */
ScmClass *Scm__OrderedDictionaryCPL[] = {
    SCM_CLASS_STATIC_PTR(Scm_OrderedDictionaryClass),
    SCM_CLASS_STATIC_PTR(Scm_SequenceClass),
    SCM_CLASS_STATIC_PTR(Scm_DictionaryClass),
    SCM_CLASS_STATIC_PTR(Scm_CollectionClass),
    SCM_CLASS_STATIC_PTR(Scm_TopClass),
    NULL
};
ScmClass *Scm__SequenceCPL[] = {
    SCM_CLASS_STATIC_PTR(Scm_SequenceClass),
    SCM_CLASS_STATIC_PTR(Scm_CollectionClass),
    SCM_CLASS_STATIC_PTR(Scm_TopClass),
    NULL
};

#include <windows.h>
#include <Imagehlp.h>
#include <winnt.h>
#include <malloc.h>
#include <tchar.h>
#pragma comment(lib, "psapi.lib")
#if 0
static HMODULE find_gauche(void)
{
    DWORD cb = 0;
    EnumProcessModules(
	GetCurrentProcess(), NULL, 0, &cb);
    if (cb == 0)
      return NULL;

    HMODULE *m = alloca(cb);
    if (!EnumProcessModules(
	    GetCurrentProcess(), m, cb, &cb))
      return NULL;
    const int n = cb / sizeof(HMODULE);
    for (int i = 0; i < n; i++) {
	TCHAR name[MAX_PATH], *p;
	if (GetModuleFileName(
		m[i], name, MAX_PATH) < 1)
	  continue;
	if ((p = _tcsrchr(name, _T('\\'))) != NULL
	    || (p = _tcsrchr(name, _T('/'))) != NULL)
	  p++;
	else
	  p = name;

	if (_tcsicmp(p, _T("libgauche-0.9.dll")) == 0)
	  return m[i];
    }
    return NULL;
}
#endif

struct section_range {
    void *start, *end;
};

static BOOL get_section_range(
    HINSTANCE h, const char *name,
    struct section_range *range)
{
    PIMAGE_NT_HEADERS header = (PIMAGE_NT_HEADERS)
	((BYTE *)h + ((PIMAGE_DOS_HEADER)h)->e_lfanew);
    PIMAGE_SECTION_HEADER section = IMAGE_FIRST_SECTION(header);

    for (int i = 0; i < header->FileHeader.NumberOfSections; i++) {
	if (strcmp(section[i].Name, name))
	  continue;
	range->end = (BYTE *)h
	    + section[i].VirtualAddress 
	    + section[i].Misc.VirtualSize;
	range->start = (BYTE *)h + section[i].VirtualAddress;
	return TRUE;
    }
    return FALSE;
}
#include <malloc.h>

static void patch_cpls(void)
{
#define PATCH_CPL(cpl) do {		\
	for (int i = 0; cpl[i]; i++)	\
	  cpl[i] = *(ScmClass**)*(ScmClass**)cpl[i];	\
    } while(0)
    PATCH_CPL(Scm_DefaultCPL);
    PATCH_CPL(Scm_ObjectCPL);
    PATCH_CPL(Scm__OrderedDictionaryCPL);
    PATCH_CPL(Scm__SequenceCPL);
}

static void patch_gauche_classes()
{
    for (int i = 0; i < _countof(gauche_classes); i++)
      gauche_classes[i] = *(ScmClass**)gauche_classes[i];
}

BOOL WINAPI DllMain(HINSTANCE h, DWORD fdwReason,LPVOID lpvReserved)
{
    switch(fdwReason) {
    case DLL_PROCESS_ATTACH:
	{
	    struct section_range pts, gauche_text, gauche_data;

	    if (!get_section_range(h, ".pts", &pts))
	      return FALSE;
	    
	    patch_cpls();
	    patch_gauche_classes();

	    for (void **p = pts.start;
		 (uintptr_t)p < (uintptr_t)pts.end; p++) {
		int tag;

#define RANGE(p, a) (((uintptr_t)*p) >= ((uintptr_t)a) && ((uintptr_t)*p) < ((uintptr_t)a) + sizeof(a))
		if (!RANGE(p, gauche_classes))
		  continue;

		switch(tag = (intptr_t)*p & 7) {
		case 1: case 5: /* fixnum */
		case 2: case 6: /* float */
		case 3: /* character, Miscellaneous, Pattern variable */
		case 4: /* pointer */
		    continue;
		    break;

		case 0: /* cpl */
		case 7: /* ScmClass */
		    *p = (char *)*(ScmClass **)((uintptr_t)*p & ~7) + tag;
		    break;
		}
	    }
	    return TRUE;
	}
	//patch_imported_syms(h);
	break;
    case DLL_PROCESS_DETACH:
	break;
    case DLL_THREAD_ATTACH:
	break;
    case DLL_THREAD_DETACH:
	break;
    }
    return  TRUE;
}
