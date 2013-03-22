# Project Needs a name ofcourse
project(kwin_script_workflow)

#set(NAME workflow)
#set(VERSION 0.4.0)
#set(AUTHOR "Michail Vourlakos")
#set(EMAIL "psifidotos@users.sf.net")
#set(WEBSITE "http://workflow.opentoolsandspace.org/")
#set(ICON "preferences-activities")


# Find the required Libaries
find_package(KDE4 REQUIRED)

set(workflow_winscript_dir ${DATA_INSTALL_DIR}/kwin/scripts/workflow)
set(metadata_dot_desktop package/metadata.desktop)

install(DIRECTORY package/contents
    DESTINATION ${workflow_winscript_dir}
    PATTERN ".*" EXCLUDE
    PATTERN "*~" EXCLUDE)

install(FILES ${metadata_dot_desktop}
    DESTINATION ${workflow_winscript_dir})

install(FILES ${metadata_dot_desktop}
    DESTINATION ${SERVICES_INSTALL_DIR} RENAME kwin-script-workflow.desktop)
    
# add_subdirectory(package)
# add_subdirectory(po)


