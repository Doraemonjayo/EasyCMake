function(is_empty result)
    list(LENGTH ARGN len)
    if(len EQUAL 0)
        set(${result} TRUE PARENT_SCOPE)
    else()
        set(${result} FALSE PARENT_SCOPE)
    endif()
endfunction()

function(find_source_files result)
    set(src_files "")
    foreach(directory IN LISTS ARGN)
        file(GLOB_RECURSE found_files
            "${directory}/*.c"
            "${directory}/*.cpp"
            "${directory}/*.c++"
            "${directory}/*.cc"
            "${directory}/*.cxx"
            "${directory}/*.C"
            "${directory}/*.cp"
        )
        list(APPEND src_files ${found_files})
    endforeach()
    set(${result} ${src_files} PARENT_SCOPE)
endfunction()

function(find_apps result)
    set(apps "")
    foreach(directory IN LISTS ARGN)
        file(GLOB found_directories LIST_DIRECTORIES true ${directory}/*)
        foreach(app_directory ${found_directories})
            get_filename_component(app_name ${app_directory} NAME)
            list(APPEND apps ${app_name})
            set(${app_name}_DIRECTORIES ${app_directory} PARENT_SCOPE)
            find_source_files(app_source_files ${app_directory})
            set(${app_name}_SOURCE_FILES ${app_source_files} PARENT_SCOPE)
        endforeach()
    endforeach()
    set(${result} ${apps} PARENT_SCOPE)
endfunction()