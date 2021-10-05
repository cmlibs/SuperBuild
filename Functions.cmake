
# This is a slow function don't call it if you don't have to.
function(check_ssh_github_access VAR_NAME)
    find_program(SSH_EXE ssh)
    mark_as_advanced(SSH_EXE)
    if (SSH_EXE)
        # This command always fail as github doesn't allow ssh access
        execute_process(
            COMMAND ${SSH_EXE} git@github.com
            RESULT_VARIABLE _RESULT
            ERROR_VARIABLE _ERR
            TIMEOUT 5
            )
        # So check the contents of the error message for a success message
        if ("${_ERR}" MATCHES "successfully authenticated")
            set(HAVE_SSH_ACCESS TRUE)
        else ()
            set(HAVE_SSH_ACCESS FALSE)
        endif ()
    else ()
        set(HAVE_SSH_ACCESS FALSE)
    endif ()
    set(${VAR_NAME} ${HAVE_SSH_ACCESS} PARENT_SCOPE)
endfunction()

function(get_github_protocol VAR_NAME)
    if (GIT_FOUND)
        check_ssh_github_access(_HAVE_SSH_GITHUB_ACCESS)
        if (_HAVE_SSH_GITHUB_ACCESS)
            set(GITHUB_PROTOCOL "git@github.com:")
        else ()
            set(GITHUB_PROTOCOL "https://github.com/")
        endif ()
        set(GITHUB_EXT ".git")
    else ()
        set(GITHUB_PROTOCOL "https://github.com/")
    endif ()
    message(STATUS "Using GitHub protocol: ${GITHUB_PROTOCOL}")
    set(${VAR_NAME} ${GITHUB_PROTOCOL} PARENT_SCOPE)
endfunction()

function(set_override_value _TEST_LIST _VALUE_LIST _TEST_VALUE _VAR_NAME)
    list(FIND _TEST_LIST ${_TEST_VALUE} _INDEX)
    if (${_INDEX} GREATER -1)
        list(GET _VALUE_LIST ${_INDEX} _OVERRIDE)
        set(_OVERRIDE_VALUE ${_OVERRIDE})
    else()
        set(_OVERRIDE_VALUE ${${_VAR_NAME}})
    endif()

    set(${_VAR_NAME} ${_OVERRIDE_VALUE} PARENT_SCOPE)
endfunction()
