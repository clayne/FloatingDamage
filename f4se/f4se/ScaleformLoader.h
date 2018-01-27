#pragma once

#include "f4se_common/Relocation.h"
#include "f4se_common/Utilities.h"

#include "f4se/ScaleformState.h"

class GImageInfoBase;
class IMenu;
class GFxMovieView;

class GFxImageLoader : public GFxState
{
public:
	virtual GImageInfoBase*	LoadImage(const char * url) = 0;
};

class BSScaleformImageLoader : public GFxImageLoader
{
public:
	virtual ~BSScaleformImageLoader();
	virtual GImageInfoBase*	LoadImage(const char * url);
	virtual void Unk_02(void);
	virtual void Unk_03(void);
	virtual void Unk_04(void);
	virtual void Unk_06(void);
};

class BSScaleformManager
{
public:
	virtual ~BSScaleformManager();
	virtual void Unk_01(void); // Init image loader?

	UInt64					unk08;			// 08 - 0
	GFxStateBag				* stateBag;		// 10
	void					* unk18;		// 18
	void					* unk20;		// 20
	BSScaleformImageLoader	* imageLoader;	// 28

	MEMBER_FN_PREFIX(BSScaleformManager);
	DEFINE_MEMBER_FN(LoadMovie, bool, 0x021108E0, IMenu * menu, GFxMovieView *&, const char * name, const char * stagePath, UInt32 flags);
};

extern RelocPtr <BSScaleformManager *> g_scaleformManager;
