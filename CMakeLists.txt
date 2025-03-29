cmake_minimum_required(VERSION 3.10)

get_filename_component(CURRENT_FOLDER_NAME ${CMAKE_SOURCE_DIR} NAME)
project(${CURRENT_FOLDER_NAME} LANGUAGES C CXX)

set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 17)

set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(EasyCMake.cmake)

set(MODULES_DIRECTORIES "${CMAKE_SOURCE_DIR}/modules")
find_source_files(MODULES_SOURCE_FILES ${MODULES_DIRECTORIES})

set(APPS_DIRECTORIES "${CMAKE_SOURCE_DIR}/apps")
find_apps(${PROJECT_NAME}_APPS ${APPS_DIRECTORIES})

foreach(app ${${PROJECT_NAME}_APPS})
    add_executable(${app} ${${app}_SOURCE_FILES} ${MODULES_SOURCE_FILES})
    message(STATUS ${app} ${${app}_DIRECTORIES} ${MODULES_DIRECTORIES})
    target_include_directories(${app} PRIVATE ${${app}_DIRECTORIES} ${MODULES_DIRECTORIES})
endforeach()
