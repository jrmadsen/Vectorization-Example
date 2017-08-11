
cmake_minimum_required(VERSION 3.1.3 FATAL_ERROR)
project(Intrin C CXX)

set(CMAKE_USER_MAKE_RULES_OVERRIDE_CXX
  ${CMAKE_SOURCE_DIR}/cmake/MakeRules_cxx.cmake)
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})
set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type")

if(NOT CMAKE_COMPILER_IS_GNUCXX)
    message(FATAL_ERROR "Use the GNU compiler")
endif()

include(MakeRules_cxx)
include(ConfigureCXXSTD)
include(Packages)

option(PRINT_VECTOR_INFO_MISSED "Print the reason vectorization was not done" OFF)
add_feature(PRINT_VECTOR_INFO_MISSED "Print the reason vectorization was not done")
add_feature(CMAKE_BUILD_TYPE "Build type")

include_directories(${PROJECT_SOURCE_DIR}/source)

file(GLOB headers ${PROJECT_SOURCE_DIR}/source/*.hh)
file(GLOB sources ${PROJECT_SOURCE_DIR}/source/*.cc)

add_executable(intrin-autovec intrin.cc ${headers} ${sources})
if(PRINT_VECTOR_INFO_MISSED)
    set_target_properties(intrin-autovec PROPERTIES
        COMPILE_FLAGS "-fopt-info-vec-missed -Wno-unknown-pragmas")
else()
    set_target_properties(intrin-autovec PROPERTIES
        COMPILE_FLAGS "-Wno-unknown-pragmas")
endif()

if(USE_OPENMP)
    add_executable(intrin-ompsimd intrin.cc ${headers} ${sources})
    if(PRINT_VECTOR_INFO_MISSED)
        set_target_properties(intrin-ompsimd PROPERTIES
            COMPILE_FLAGS "${OpenMP_CXX_FLAGS} -fopt-info-vec-missed"
            COMPILE_DEFINITIONS "USE_OPENMP"
            LINKER_FLAGS "${OpenMP_EXE_LINKER_FLAGS}")
    else()
        set_target_properties(intrin-ompsimd PROPERTIES
            COMPILE_FLAGS "${OpenMP_CXX_FLAGS}"
            COMPILE_DEFINITIONS "USE_OPENMP"
            LINKER_FLAGS "${OpenMP_EXE_LINKER_FLAGS}")
    endif()

endif()

print_features()
