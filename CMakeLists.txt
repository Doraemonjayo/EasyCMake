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

# 各実行可能ファイルと関連のソースファイル及びインクルードパスを設定
set(APPS_DIRECTORIES "${CMAKE_SOURCE_DIR}/apps")
find_apps(${PROJECT_NAME}_APPS ${APPS_DIRECTORIES})

# 実行可能ファイルの生成
foreach(app ${${PROJECT_NAME}_APPS})
    is_empty(src_empty ${${app}_SOURCE_FILES} ${MODULES_SOURCE_FILES})
    if(NOT src_empty)
        add_executable(${app} ${${app}_SOURCE_FILES} ${MODULES_SOURCE_FILES})
        is_empty(inc_empty {${app}_DIRECTORIES} ${MODULES_DIRECTORIES})
        if(NOT inc_empty)
            target_include_directories(${app} PRIVATE ${${app}_DIRECTORIES} ${MODULES_DIRECTORIES})
        endif()
    else()
        message(WARNING "Skipping app: ${app} because no source files were found.")
    endif()
endforeach()
