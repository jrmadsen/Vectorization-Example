# - Setup core required and optional components of ${CMAKE_PROJECT_NAME}
#
# Here we provide options to enable and configure required and optional
# components, which may require third party libraries.
#
# We don't configure User Interface options here because these require
# a higher degree of configuration so to keep things neat these have their
# own Module.
#
# Options configured here:
#
#
#
################################################################################


include(MacroUtilities)

################################################################################
#
#       OpenMP
#
################################################################################
option(USE_OPENMP "Enable OpenMP for SIMD" ON)
add_feature(USE_OPENMP "Use OpenMP for SIMD")

IF(USE_OPENMP)
    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang" AND ${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
        message(WARNING
            "\n\tClang on Darwin (as of Mavericks) does not have OpenMP Support\n")
    endif()

    find_package(OpenMP)

    if(OpenMP_FOUND)
        # Add the OpenMP-specific compiler and linker flags
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
        set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}")
        add_definitions(-DUSE_OPENMP)
    endif()
ENDIF(USE_OPENMP)

################################################################################
#
#        SSE
#
################################################################################
include(FindSSE)
set(SSE OFF CACHE BOOL "SSE support")
add_feature(SSE "SSE Support")
foreach(type SSE2 SSE3 SSSE3 SSE4_1 AVX AVX2)
    if(${type}_FOUND)
        set(SSE ON CACHE BOOL "SSE support" FORCE)
    endif()
    add_subfeature(SSE ${type}_FOUND "Hardware support for ${type}")
endforeach()

if(CMAKE_CXX_COMPILER MATCHES "icc.*")
    set(CMAKE_COMPILER_IS_INTEL_ICC ON)
endif()
if(CMAKE_CXX_COMPILER MATCHES "icpc.*")
    set(CMAKE_COMPILER_IS_INTEL_ICPC ON)
endif()

if(CMAKE_COMPILER_IS_INTEL_ICC OR CMAKE_COMPILER_IS_INTEL_ICPC)
    set(_FLAGS )
    foreach(type SSE2 SSE3 SSSE3 SSE4_1 AVX)
        string(TOLOWER "${type}" _flag)
        string(REPLACE "_" "." _flag "${_flag}")
        set(${type}_FLAGS "-m${_flag}")
        if(${type}_FOUND)
            set(_FLAGS "${${type}_FLAGS}")
            add_definitions(-DHAS_${type})
        endif()
    endforeach()

    if(AVX2_FOUND)
        set(_FLAGS "-march=core-avx2")
        add_definitions(-DHAS_AVX2)
    endif()

    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${_FLAGS}")
endif()

if(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
    foreach(type SSE2 SSE3 SSSE3 SSE4_1 AVX AVX2)
        string(TOLOWER "${type}" _flag)
        string(REPLACE "_" "." _flag "${_flag}")
        set(${type}_FLAGS "-m${_flag}")
        if(${type}_FOUND)
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${${type}_FLAGS}")
            add_definitions(-DHAS_${type})
        endif()
    endforeach()
endif()



################################################################################
#
#        clean up...
#
################################################################################
set(_types LIBRARIES INCLUDE_DIRS)
foreach(_type ${_types})
    if(NOT "${EXTERNAL_${_type}}" STREQUAL "")
        list(REMOVE_DUPLICATES EXTERNAL_${_type})
    endif()
endforeach()
unset(_types)

