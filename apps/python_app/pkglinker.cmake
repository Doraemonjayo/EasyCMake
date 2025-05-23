target_link_package(${target} PACKAGE_LIST
    Python3
    COMPONENTS Interpreter Development
    DIRECTORIES "\${Python3_INCLUDE_DIRS}"
    LIBRARIES "\${Python3_LIBRARIES}"
)