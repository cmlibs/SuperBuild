execute_process(
    COMMAND ${GIT_EXECUTABLE} apply ${CMAKE_CURRENT_SOURCE_DIR}/newer-zlib.patch
    WORKING_DIRECTORY ${SOURCE_DIR}
)
