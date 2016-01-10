list(APPEND LIBS core uicommon)

set(SRCS MainiOS.mm)

if(IOS)
	add_dolphin_library(main ${SRCS} ${LIBS})

	# TODO: Copy assets
endif()