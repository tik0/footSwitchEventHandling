cmake_minimum_required (VERSION 2.6)

# Set the project name to the name of the folder
string (REGEX MATCH "[^/]+$" PROJECT_NAME "${CMAKE_CURRENT_BINARY_DIR}")
message (STATUS "Set PROJECT_NAME to ${PROJECT_NAME}")

project ("${PROJECT_NAME}")

find_package(Boost REQUIRED COMPONENTS regex date_time program_options system)

# Set the include pathe
include_directories(
    ${Boost_INCLUDE_DIRS}
)

# add the executable
add_executable (
    "${PROJECT_NAME}"
    main.cxx
)

target_link_libraries (
    "${PROJECT_NAME}"
    ${Boost_LIBRARIES}
    pthread
)

SET ( CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wall -O0 -g -std=c++11" )
SET ( CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -Wall -O2 -std=c++11" )