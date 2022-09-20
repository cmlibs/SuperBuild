# DO NOT EDIT. This is a generated file.

cmake_minimum_required(VERSION 3.10.0 FATAL_ERROR)

if (NOT TARGET opencmissdependencies)

    get_filename_component(_CMLIBS_DEPENDENCIES_IMPORT_PREFIX "${CMAKE_CURRENT_LIST_FILE}" DIRECTORY)

@DEPENDENCY_SYSTEM_LIST@

    set(CMLIBS_MODULE_PATH @CONTEXT_CMLIBS_MODULE_PATH@)
    list(APPEND CMAKE_MODULE_PATH ${CMLIBS_MODULE_PATH})

    include(OCMiscFunctions)

    set(_REQUIRED_COMPONENTS @DEPENDENCY_PROJECTS@)
    set(_found_targets)
    foreach(_component ${_REQUIRED_COMPONENTS})
        message(STATUS "Looking for ${_component} ...")
        get_module_case_sensitive_name(${_component} _case_name)
        find_package(${_case_name} QUIET)
        if (${_component}_FOUND)
            get_module_targets(${_component} _targets)
            list(APPEND _found_targets ${_targets})
            message(STATUS "Looking for ${_component} ... Success")
        else ()
            message(STATUS "Looking for ${_component} ... Not found")
        endif ()
    endforeach()

    add_library(opencmissdependencies INTERFACE)
    target_link_libraries(opencmissdependencies INTERFACE ${_found_targets})
endif()
