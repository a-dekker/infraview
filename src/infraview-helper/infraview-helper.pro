PROJECT = harbour-infraview
TARGET = infraview-helper
QT -= gui
#CONFIG += sailfishapp

target.path = /usr/share/$$PROJECT/helper

SOURCES += \
    infraview-helper.c

INSTALLS += target
