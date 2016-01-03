// Copyright 2014 Dolphin Emulator Project
// Licensed under GPLv2
// Refer to the license.txt file included.

#pragma once

#include "VideoBackends/OGL/GLInterfaceBase.h"

class cInterfaceEAGL : public cInterfaceBase
{
private:
public:
	void Swap();
	bool Create(void *window_handle);
	bool MakeCurrent();
	bool ClearCurrent();
	void Shutdown();
	void Update();
	void SwapInterval(int interval);
};
