
if (NOT FIELDML-API_WITH_HDF5)
    list(REMOVE_ITEM DEPENDENCY_PROJECTS SZIP HDF5)
    list(REMOVE_ITEM ALL_PROJECTS SZIP HDF5)
endif()

set(DEPENDENCY_SYSTEM_LIST)
foreach (_SYSTEM_PACKAGE ${DEPENDENCY_PROJECTS})
    if (_SYSTEM_PACKAGE IN_LIST USE_SYSTEM_BY_DEFAULT)
        set(_SYSTEM_PACKAGE_CMAKE ${_SYSTEM_PACKAGE})
        set_override_value("${DEPENDENCIES_WITH_DIFFERENT_MODULE_NAME}" "${DEPENDENCIES_WITH_DIFFERENT_MODULE_NAME_VALUE}" ${_SYSTEM_PACKAGE} _SYSTEM_PACKAGE_CMAKE)
        set(${_SYSTEM_PACKAGE}_FIND_SYSTEM ON)
        find_package(${_SYSTEM_PACKAGE_CMAKE})
        if (${${_SYSTEM_PACKAGE_CMAKE}_FOUND})
            list(REMOVE_ITEM ALL_PROJECTS ${_SYSTEM_PACKAGE})
        endif()
    else()
        set(${_SYSTEM_PACKAGE}_FIND_SYSTEM OFF)
    endif()
    list(APPEND DEPENDENCY_SYSTEM_LIST "    set(${_SYSTEM_PACKAGE}_FIND_SYSTEM ${${_SYSTEM_PACKAGE}_FIND_SYSTEM})\n")
endforeach()
string(REPLACE ";" "" DEPENDENCY_SYSTEM_LIST "${DEPENDENCY_SYSTEM_LIST}")

if (CMLIBS_SETUP_TYPE STREQUAL "dependencies")
    list(REMOVE_ITEM ALL_PROJECTS ${CMLIBS_PROJECTS})
endif()

foreach (_PROJECT ${ALL_PROJECTS})
    set(_GITHUB_BRANCH ${DEFAULT_GITHUB_BRANCH})
    set_override_value("${OVERRIDE_PROJECT_GITHUB_BRANCH}" "${OVERRIDE_PROJECT_GITHUB_BRANCH_VALUE}" ${_PROJECT} _GITHUB_BRANCH)
    if (_PROJECT IN_LIST CMLIBS_PROJECTS)
        set(_GITHUB_ORG ${DEFAULT_CMLIBS_GITHUB_ORG})
    elseif(_PROJECT IN_LIST UTILITIES_PROJECTS)
        set(_GITHUB_ORG ${DEFAULT_UTILITIES_GITHUB_ORG})
    else()
        set(_GITHUB_ORG ${DEFAULT_DEPENDENCY_GITHUB_ORG})
    endif()
    set_override_value("${OVERRIDE_PROJECT_GITHUB_ORG}" "${OVERRIDE_PROJECT_GITHUB_ORG_VALUE}" ${_PROJECT} _GITHUB_ORG)
    set(GITHUB_REPO_URL ${GITHUB_PROTOCOL}${_GITHUB_ORG}${_PROJECT}${GITHUB_EXT})
    if (GIT_FOUND)
        set(DOWNLOAD_${_PROJECT}_CMD
            GIT_REPOSITORY ${GITHUB_REPO_URL}
            GIT_TAG ${_GITHUB_BRANCH}
        )
    else ()
        set(DOWNLOAD_${_PROJECT}_CMD
            URL ${GITHUB_REPO_URL}/archive/${_GITHUB_BRANCH}.zip
        )
    endif ()
endforeach ()
