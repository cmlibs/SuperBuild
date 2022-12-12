# DO NOT EDIT. This is a generated file.
include(CMakeFindDependencyMacro)

cmake_minimum_required(VERSION 3.10.0 FATAL_ERROR)

if (NOT TARGET cmlibsdependencies)

    get_filename_component(_CMLIBS_DEPENDENCIES_IMPORT_PREFIX "${CMAKE_CURRENT_LIST_FILE}" DIRECTORY)

@DEPENDENCY_SYSTEM_LIST@

    set(CMLIBS_MODULE_PATH @CONTEXT_CMLIBS_MODULE_PATH@)
    list(APPEND CMAKE_MODULE_PATH ${CMLIBS_MODULE_PATH})

    include(CMLMiscFunctions)

    set(CMAKE_PREFIX_PATH "${_CMLIBS_DEPENDENCIES_IMPORT_PREFIX}")

    set(_REQUIRED_COMPONENTS @DEPENDENCY_PROJECTS@)
    set(_found_targets)
    foreach(_component ${_REQUIRED_COMPONENTS})
        message(STATUS "Looking for ${_component} ...")
        get_module_case_sensitive_name(${_component} _case_name)
        find_dependency(${_case_name} QUIET)
        if (${_component}_FOUND)
            get_module_targets(${_component} _targets)
            list(APPEND _found_targets ${_targets})
            message(STATUS "Looking for ${_component} ... Success")
        else ()
            message(STATUS "Looking for ${_component} ... Not found")
        endif ()
    endforeach()

    add_library(cmlibsdependencies INTERFACE)
    set_target_properties(cmlibsdependencies PROPERTIES
        INTERFACE_LINK_LIBRARIES "${_found_targets}")
endif()
