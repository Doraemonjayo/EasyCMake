cmake_minimum_required(VERSION 3.10)

# プロジェクト名をカレントディレクトリ名に設定
get_filename_component(CURRENT_FOLDER_NAME ${CMAKE_SOURCE_DIR} NAME)
project(${CURRENT_FOLDER_NAME} LANGUAGES C CXX)

# C/C++のバージョンを指定
set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# EasyCMake.cmakeをインクルード
include(EasyCMake.cmake)

# 全実行可能ファイルで共有するソースファイル及びインクルードパスを設定
set(MODULES_DIRECTORIES "${CMAKE_SOURCE_DIR}/modules")
find_source_files(MODULES_SOURCE_FILES ${MODULES_DIRECTORIES})
find_pkglinkers(MODULES_PKGLINKERS ${MODULES_DIRECTORIES})

set(target MODULES)
foreach(pkglinker ${MODULES_PKGLINKERS})
    include(${pkglinker})
endforeach()

# 各実行可能ファイルと関連のソースファイル及びインクルードパスを設定
set(APPS_DIRECTORIES "${CMAKE_SOURCE_DIR}/apps")
find_apps(${PROJECT_NAME}_APPS ${APPS_DIRECTORIES})

foreach(app ${${PROJECT_NAME}_APPS})
    set(target ${app})
    foreach(pkglinker ${${app}_PKGLINKERS})
        include(${pkglinker})
    endforeach()
endforeach()

find_packages(${PACKAGE_LIST})

string(CONFIGURE "${MODULES_SOURCE_FILES}" MODULES_SOURCE_FILES)
string(CONFIGURE "${MODULES_DIRECTORIES}" MODULES_DIRECTORIES)
string(CONFIGURE "${MODULES_LIBRARIES}" MODULES_LIBRARIES)
list(REMOVE_DUPLICATES MODULES_SOURCE_FILES)
list(REMOVE_DUPLICATES MODULES_DIRECTORIES)
list(REMOVE_DUPLICATES MODULES_LIBRARIES)

# 実行可能ファイルの生成
foreach(app ${${PROJECT_NAME}_APPS})
    string(CONFIGURE "${${app}_SOURCE_FILES}" ${app}_SOURCE_FILES)
    string(CONFIGURE "${${app}_DIRECTORIES}" ${app}_DIRECTORIES)
    string(CONFIGURE "${${app}_LIBRARIES}" ${app}_LIBRARIES)
    list(REMOVE_DUPLICATES ${app}_SOURCE_FILES)
    list(REMOVE_DUPLICATES ${app}_DIRECTORIES)
    list(REMOVE_DUPLICATES ${app}_LIBRARIES)

    is_empty(src_empty ${${app}_SOURCE_FILES} ${MODULES_SOURCE_FILES})
    if(NOT src_empty)
        add_executable(${app} ${${app}_SOURCE_FILES} ${MODULES_SOURCE_FILES})
        is_empty(lib_empty ${${app}_LIBRARIES} ${MODULES_LIBRARIES})
        if(NOT lib_empty)
            target_link_libraries(${app} PRIVATE ${${app}_LIBRARIES} ${MODULES_LIBRARIES})
        endif()
        is_empty(inc_empty {${app}_DIRECTORIES} ${MODULES_DIRECTORIES})
        if(NOT inc_empty)
            target_include_directories(${app} PRIVATE ${${app}_DIRECTORIES} ${MODULES_DIRECTORIES})
        endif()
    else()
        message(WARNING "Skipping app: ${app} because no source files were found.")
    endif()
endforeach()
