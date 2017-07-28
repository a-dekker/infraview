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
