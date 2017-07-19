
cmake_minimum_required(VERSION 3.1.3 FATAL_ERROR)
project(intrin C CXX)

set(CMAKE_USER_MAKE_RULES_OVERRIDE_CXX
  ${CMAKE_SOURCE_DIR}/cmake/MakeRules_cxx.cmake)
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})
if("${CMAKE_BUILD_TYPE}" STREQUAL "")
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

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
add_library(intrinsic ${headers} ${sources})

add_executable(intrin intrin.cc)
target_link_libraries(intrin intrinsic)
if(PRINT_VECTOR_INFO_MISSED)
    set_target_properties(intrin PROPERTIES COMPILE_FLAGS "-fopt-info-vec-missed")
endif()

print_features()
