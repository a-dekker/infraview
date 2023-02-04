TEMPLATE = app

TARGET = harbour-infraview
CONFIG += sailfishapp

#QT += declarative

SOURCES += infraview.cpp \
    osread.cpp

HEADERS += \
    osread.h

CONFIG(release, debug|release) {
    DEFINES += QT_NO_DEBUG_OUTPUT
}

OTHER_FILES +=

isEmpty(VERSION) {
    VERSION = $$system( egrep "^Version:\|^Release:" ../rpm/infraview.spec |tr -d "[A-Z][a-z]: " | tr "\\\n" "-" | sed "s/\.$//g"| tr -d "[:space:]")
    message("VERSION is unset, assuming $$VERSION")
}
DEFINES += APP_VERSION=\\\"$$VERSION\\\"
DEFINES += BUILD_YEAR=$$system(date '+%Y')
