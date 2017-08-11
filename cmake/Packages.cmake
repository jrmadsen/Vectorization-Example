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

    find_package(OpenMP REQUIRED)
ENDIF(USE_OPENMP)

################################################################################
#
#        SSE
#
################################################################################
option(USE_SSE "Enable SSE/AVX support" ON)
add_feature(USE_SSE "Enable SSE/AVX Support")

if(USE_SSE)
    include(FindSSE)
    foreach(type ${INTRIN_TYPES})
        add_subfeature(USE_SSE ${type}_FOUND "Hardware support for ${type}")
    endforeach()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${INTRIN_CXX_FLAGS}")
    foreach(def ${INTRIN_DEFINITIONS})
        add_definitions(-D${def})
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

