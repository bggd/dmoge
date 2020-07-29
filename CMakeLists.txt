cmake_minimum_required(VERSION 2.8)

set(CMAKE_INSTALL_PREFIX ${CMAKE_SOURCE_DIR}/external CACHE PATH "" FORCE)

project(prebuild CXX)

add_subdirectory(external/moge)

install(TARGETS moge-gl)
