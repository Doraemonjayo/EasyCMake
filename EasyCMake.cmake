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

function(find_pkglinkers result)
    set(cmake_files "")
    foreach(directory IN LISTS ARGN)
        file(GLOB_RECURSE found_files
            "${directory}/pkglinker.cmake"
        )
        list(APPEND cmake_files ${found_files})
    endforeach()
    set(${result} ${cmake_files} PARENT_SCOPE)
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
            find_pkglinkers(app_pkglinkers ${app_directory})
            set(${app_name}_PKGLINKERS ${app_pkglinkers} PARENT_SCOPE)
        endforeach()
    endforeach()
    set(${result} ${apps} PARENT_SCOPE)
endfunction()

function(target_link_package target package_list package)
    set(pkgs ${${package_list}})
    set(pkg_comps ${${package}_COMPONENTS})
    set(tgt_dirs ${${target}_DIRECTORIES})
    set(tgt_libs ${${target}_LIBRARIES})

    cmake_parse_arguments(
        ARG
        ""
        ""
        "COMPONENTS;DIRECTORIES;LIBRARIES"
        ${ARGN}
    )
    list(APPEND pkgs ${package})
    list(REMOVE_DUPLICATES pkgs)
    set(${package_list} ${pkgs} PARENT_SCOPE)

    list(APPEND pkg_comps ${ARG_COMPONENTS})
    list(REMOVE_DUPLICATES pkg_comps)
    set(${package}_COMPONENTS ${pkg_comps} PARENT_SCOPE)

    list(APPEND tgt_dirs ${ARG_DIRECTORIES})
    list(REMOVE_DUPLICATES tgt_dirs)
    set(${target}_DIRECTORIES ${tgt_dirs} PARENT_SCOPE)

    list(APPEND tgt_libs ${ARG_LIBRARIES})
    list(REMOVE_DUPLICATES tgt_libs)
    set(${target}_LIBRARIES ${tgt_libs} PARENT_SCOPE)
endfunction()

macro(find_packages)
    set(find_packages_ARG ${ARGN})
    string(CONFIGURE "${find_packages_ARG}" find_packages_ARG)
    list(REMOVE_DUPLICATES find_packages_ARG)
    foreach(package ${find_packages_ARG})
        string(CONFIGURE "${${package}_COMPONENTS}" ${package}_COMPONENTS)
        list(REMOVE_DUPLICATES ${package}_COMPONENTS)
        is_empty(comps_empty ${${package}_COMPONENTS})
        if(comps_empty)
            find_package(${package} REQUIRED)
        else()
            find_package(${package} REQUIRED COMPONENTS ${${package}_COMPONENTS})
        endif()
    endforeach()
endmacro()
