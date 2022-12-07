function(add_project _PROJECT_NAME)
    # Get lowercase folder name from project name
    string(TOLOWER ${_PROJECT_NAME} FOLDER_NAME)

    # Compute directories
    if (CMLIBS_SETUP_TYPE STREQUAL "dependencies")
        set(_PROJECT_SOURCE_DIR "${CMLIBS_ROOT}/src/${FOLDER_NAME}")
        set(_PROJECT_BINARY_DIR "${CMLIBS_ROOT}/build${SINGLECONFIG_BUILD_DIR_LABEL}/${FOLDER_NAME}")
    else()
        if (_PROJECT_NAME IN_LIST DEPENDENCY_PROJECTS)
            set(_PROJECT_SOURCE_DIR "${CMLIBS_ROOT}/src/dependencies/${FOLDER_NAME}")
            set(_PROJECT_BINARY_DIR "${CMLIBS_ROOT}/build${SINGLECONFIG_BUILD_DIR_LABEL}/dependencies/${FOLDER_NAME}")
        else()
            set(_PROJECT_SOURCE_DIR "${CMLIBS_ROOT}/src/${FOLDER_NAME}")
            set(_PROJECT_BINARY_DIR "${CMLIBS_ROOT}/build${SINGLECONFIG_BUILD_DIR_LABEL}/${FOLDER_NAME}")
        endif()
    endif()

    # Collect component definitions
    set(_PROJECT_DEFS
        -DPACKAGE_CONFIG_DIR=share/cmake/${_PROJECT_NAME}
        -DCMAKE_INSTALL_PREFIX:PATH=${_INSTALL_PREFIX}
        -DCMAKE_PREFIX_PATH:PATH=${_INSTALL_PREFIX}
        -DCMAKE_MODULE_PATH=${PROJECT_CMAKE_MODULE_PATH}
    )

    if (NOT IS_MULTI_CONFIG)
        list(APPEND _PROJECT_DEFS -DCMAKE_BUILD_TYPE=${CMLIBS_BUILD_TYPE})
    endif()

    # Shared or static?
    if (_PROJECT_NAME IN_LIST DEPENDENCY_PROJECTS)
      list(APPEND _PROJECT_DEFS -DBUILD_SHARED_LIBS=OFF)
      list(APPEND _PROJECT_DEFS -DENABLE_PIC=ON)
    endif()

    # Forward any other variables
    foreach(extra_def ${ARGN})
        list(APPEND _PROJECT_DEFS -D${extra_def})
    endforeach()

    # Create the external projects
    add_external_project(${_PROJECT_NAME} "${_PROJECT_SOURCE_DIR}" "${_PROJECT_BINARY_DIR}" "${_PROJECT_DEFS}")

    # Add the dependency information for other downstream packages that might use this one
    add_downstream_dependencies(${_PROJECT_NAME})

endfunction()

function(add_external_project _PROJECT_NAME SOURCE_DIR BINARY_DIR DEFS)

    #set(BUILD_COMMAND ${CMAKE_COMMAND} --build "${BINARY_DIR}")
    #set(INSTALL_COMMAND ${CMAKE_COMMAND} --build "${BINARY_DIR}" --target install)

    if(PARALLEL_BUILDS)
        include(ProcessorCount)
        ProcessorCount(NUM_PROCESSORS)
        if (NUM_PROCESSORS EQUAL 0)
            set(NUM_PROCESSORS 1)
        #else()
        #    MATH(EXPR NUM_PROCESSORS ${NUM_PROCESSORS}+4)
        endif()

        if(CMAKE_GENERATOR MATCHES "^Unix Makefiles$"
            OR CMAKE_GENERATOR MATCHES "^MinGW Makefiles$"
            OR CMAKE_GENERATOR MATCHES "^NMake Makefiles$"
            OR CMAKE_GENERATOR MATCHES "^MSYS Makefiles$")
            set(GENERATOR_MATCH_MAKE TRUE)
        endif()

        #if(GENERATOR_MATCH_MAKE OR GENERATOR_MATCH_NMAKE)
        #    list(APPEND BUILD_COMMAND -- "-j${NUM_PROCESSORS}")
        #endif()
    endif()

    set(_LOGFLAG ON)

    if (EXISTS ${SOURCE_DIR}/CMakeLists.txt)
        message(STATUS "CMake ${_PROJECT_NAME} files are already present, skipping downloading them.")
        set(DOWNLOAD_${_PROJECT_NAME}_CMD "DOWNLOAD_COMMAND;;")
    endif()

    if (_PROJECT_NAME STREQUAL "ZINC")
        set(CRAZY_PATCH_FILE ${CMAKE_CURRENT_BINARY_DIR}/newer-zlib.cmake)
        configure_file(newer-zlib.in.cmake ${CRAZY_PATCH_FILE})
        set(ZINC_ZLIB_PATCH_CMD "PATCH_COMMAND;${CMAKE_COMMAND};-P;${CRAZY_PATCH_FILE}")
    endif()

    ExternalProject_Add(${_PROJECT_NAME}
        DEPENDS ${${_PROJECT_NAME}_DEPENDS}
        PREFIX ${BINARY_DIR}
        LIST_SEPARATOR ${LIST_SEPARATOR}
        TMP_DIR ${BINARY_DIR}/${EXTPROJ_TMP_DIR}
        STAMP_DIR ${BINARY_DIR}/${EXTPROJ_STAMP_DIR}

        #--Download step--------------
        ${DOWNLOAD_${_PROJECT_NAME}_CMD}
        #--Zinc only patch------------
        ${ZINC_ZLIB_PATCH_CMD}

        #--Configure step-------------
        #CMAKE_COMMAND ${CMAKE_COMMAND} --no-warn-unused-cli # disables warnings for unused cmdline options
        SOURCE_DIR ${SOURCE_DIR}
        BINARY_DIR ${BINARY_DIR}
        CMAKE_ARGS ${DEFS}

        #--Build step-----------------
		# Inherit build command?
        #BUILD_COMMAND ${BUILD_COMMAND}
        #--Install step---------------
        # currently set as extra arg (above), somehow does not work
        #INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
		# Use the default install command???
        #INSTALL_COMMAND ${INSTALL_COMMAND}
        # Logging
        LOG_CONFIGURE ${_LOGFLAG}
        LOG_BUILD ${_LOGFLAG}
        LOG_INSTALL ${_LOGFLAG}
        LOG_PATCH ${_LOGFLAG}
    )
    set_target_properties(${COMPONENT_NAME} PROPERTIES FOLDER "ExternalProjects")

endfunction()
