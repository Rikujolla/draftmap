# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-kuvakartta

CONFIG += sailfishapp

SOURCES += src/harbour-kuvakartta.cpp

OTHER_FILES += qml/harbour-kuvakartta.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-kuvakartta.spec \
    rpm/harbour-kuvakartta.yaml \
    translations/*.ts \
    harbour-kuvakartta.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-kuvakartta-de.ts

DISTFILES += \
    qml/pages/MapPage.qml \
    qml/pages/AddImage.qml \
    qml/pages/components/tables.js \
    qml/pages/components/setting.js \
    qml/pages/Settings.qml \
    qml/pages/Help.qml \
    qml/pages/About.qml \
    rpm/harbour-kuvakartta.changes \
    translations/harbour-kuvakartta-sv.ts
