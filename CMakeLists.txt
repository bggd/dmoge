cmake_minimum_required(VERSION 2.8)

set(CMAKE_INSTALL_PREFIX ${CMAKE_SOURCE_DIR}/external CACHE PATH "" FORCE)

project(prebuild CXX)

if(MSVC)
  set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT")
  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /MT")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MT")
endif()

add_subdirectory(external/moge)

install(TARGETS moge-gl)
