cmake_minimum_required(VERSION 3.10.2)
project(Pedidos_en_archivo_org)

# para debuguear
set(CMAKE_BUILD_TYPE Debug)

# para compilar con warnings full
SET(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -Wall -Wextra")

# -------------ini-Agregando GLib------------
# use pkg-config tool to detect gtk headers and link libs
find_package (PkgConfig REQUIRED)
pkg_check_modules (GLIB glib-2.0)
pkg_check_modules (GMODULE gmodule-2.0)

#include GLib headers
include_directories(${GLIB_INCLUDE_DIRS})
link_directories(${GLIB_LIBRARY_DIRS})
# add other flags from GLib
add_definitions(${GLIB_CFLAGS_OTHER})
# -------------fin-Agregando GLib------------

###############################################################################
## file globbing ##############################################################
###############################################################################

# These instructions search the directory tree when cmake is
# invoked and put all files that match the pattern in the variables
file(GLOB_RECURSE sources src/*.c src/*.h)

add_executable(pedidos ${sources})

target_link_libraries(pedidos ${GLIB_LIBRARIES})

# This allows to include files relative to the root of the src
# directory with a <> pair
target_include_directories(pedidos PUBLIC src)

# agregando un comando para compilar con flex y bison
ADD_CUSTOM_TARGET(analizadores
  COMMAND make -C ../src/analizador
  )
