QT += quick
CONFIG += c++11

VERSION = 0.1.0

DEFINES += QT_DEPRECATED_WARNINGS

SOURCES += \
    main.cpp \
    native.cpp

HEADERS += \
    native.h

RESOURCES += \
    qml/qml.qrc \
    languages/languages.qrc

TRANSLATIONS += \
    languages/ru_RU.ts

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
android {
    QT += androidextras
    OTHER_FILES += \
        android/src/org/oserv/qtandroid/MainActivity.java \
        android/build.gradle \
        android/AndroidManifest.xml
}
