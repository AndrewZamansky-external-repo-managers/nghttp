
INCLUDE_THIS_COMPONENT := $(CONFIG_INCLUDE_NGHTTP2)

EXPANDED_MAKEFILE_LIST := $(realpath $(MAKEFILE_LIST))
NGHTTP2_MAKEFILE :=$(filter %nghttp2_git/Makefile.uc.mk, $(EXPANDED_MAKEFILE_LIST))
CURR_NGHTTP2_COMPONENT_DIR := $(patsubst %/Makefile.uc.mk,%,$(NGHTTP2_MAKEFILE))

ifdef CONFIG_INCLUDE_NGHTTP2

    #test if current commit and branch of nghttp2 git is the same as required by application
    CURR_GIT_REPO_DIR :=$(CURR_NGHTTP2_COMPONENT_DIR)
    CURR_GIT_COMMIT_HASH_VARIABLE :=CONFIG_NGHTTP2_GIT_MANAGER_COMMIT_HASH
    include $(MAKEFILES_ROOT_DIR)/_include_functions/git_prebuild_repo_check.mk

    NGHTTP2_GIT_COMMIT_HASH :="e6381b2b65dd0bcea558e6f41958850c0acaa30a"

    NGHTTP2_PATH :=$(EXTERNAL_SOURCE_ROOT_DIR)/nghttp2
    ifeq ("$(wildcard $(NGHTTP2_PATH))","")
        $(info   )
        $(info --- NGHTTP2 path $(NGHTTP2_PATH) dont exists )
        $(info --- get repo from andew zamansky or from https://github.com/nghttp2/nghttp2.git  )
        $(info --- make sure that .git directory is located in $(NGHTTP2_PATH)/  after unpacking   )
        $(error )
    endif

    #test if current commit and branch of nghttp2 git is the same as required by application
    CURR_GIT_REPO_DIR :=$(NGHTTP2_PATH)
    CURR_GIT_COMMIT_HASH_VARIABLE :=NGHTTP2_GIT_COMMIT_HASH
    include $(MAKEFILES_ROOT_DIR)/_include_functions/git_prebuild_repo_check.mk

endif


INCLUDE_DIR += $(CURR_NGHTTP2_COMPONENT_DIR)/includes
INCLUDE_DIR += $(CURR_NGHTTP2_COMPONENT_DIR)/includes/nghttp2
INCLUDE_DIR += $(NGHTTP2_PATH)/lib/includes
INCLUDE_DIR += $(AUTO_GENERATED_FILES_DIR)


#ASMFLAGS +=


ifeq ($(CONFIG_HOST),y)
    ifeq ($(findstring WINDOWS,$(COMPILER_HOST_OS)),WINDOWS)
        ifdef CONFIG_MICROSOFT_COMPILER
            #disable warning C4127: conditional expression is constant
            CFLAGS += /wd4127

            #disable warning C4204: nonstandard
            #  extension used : non-constant aggregate initializer
            CFLAGS += /wd4204

            #disable warning C4214: nonstandard
            #  extension used : bit field types other than int
            CFLAGS += /wd4214

            DEFINES += _CRT_SECURE_NO_WARNINGS
        endif
    endif
endif


DEFINES += HAVE_CONFIG_H

ifeq ($(strip $(CONFIG_NGHTTP2_ENABLE_DEBUG)),y)
    DEFINES += DEBUGBUILD
    SRC += lib/nghttp2_debug.c
endif

SRC += lib/nghttp2_session.c
SRC += lib/nghttp2_callbacks.c
SRC += lib/nghttp2_submit.c
SRC += lib/nghttp2_hd.c
SRC += lib/nghttp2_helper.c
SRC += lib/nghttp2_priority_spec.c
SRC += lib/nghttp2_version.c
SRC += lib/nghttp2_mem.c
SRC += lib/nghttp2_map.c
SRC += lib/nghttp2_buf.c
SRC += lib/nghttp2_frame.c
SRC += lib/nghttp2_outbound_item.c
SRC += lib/nghttp2_pq.c
SRC += lib/nghttp2_stream.c
SRC += lib/nghttp2_http.c
SRC += lib/nghttp2_rcbuf.c
SRC += lib/nghttp2_hd_huffman.c
SRC += lib/nghttp2_hd_huffman_data.c

VPATH += | $(NGHTTP2_PATH)

DISABLE_GLOBAL_INCLUDES_PATH := y

include $(COMMON_CC)
