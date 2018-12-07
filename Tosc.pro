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

system(lrelease Tosc.pro)

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
android {
    QT += androidextras
    OTHER_FILES += \
        android/src/org/oserv/qtandroid/MainActivity.java \
        android/build.gradle \
        android/AndroidManifest.xml
}

ios {
    QMAKE_INFO_PLIST = ios/Info.plist
    QMAKE_ASSET_CATALOGS = ios/Images.xcassets
    QMAKE_ASSET_CATALOGS_APP_ICON = AppIcon
    QMAKE_ASSET_CATALOGS_LAUNCH_IMAGE = LaunchImage
    QMAKE_IOS_DEPLOYMENT_TARGET = 10.0
    QMAKE_APPLE_TARGETED_DEVICE_FAMILY = 1,2
    ios_launch.files = $$PWD/ios/Launch.xib
    QMAKE_BUNDLE_DATA += ios_launch
    HEADERS += ios/iosnative.h
    OBJECTIVE_SOURCES += ios/iosnative.mm
    OTHER_FILES += ios/iosnative.mm
    QMAKE_LFLAGS += -F$$PWD/ios/cocoapods/Frameworks
    LIBS += \
      -framework GoogleInterchangeUtilities \
      -framework GoogleNetworkingUtilities \
      -framework GoogleSymbolUtilities \
      -framework GoogleUtilities \
      -framework CoreBluetooth \
      -framework CoreLocation \
      -framework Accelerate \
      -framework MediaPlayer \
      -framework AVFoundation \
      -framework CFNetwork \
      -framework AddressBook \
      -lm -lz -ObjC
    INCLUDEPATH += ios/cocoapods/NearbyMessages-1.1.0/Sources
    LIBS += ios/cocoapods/NearbyMessages-1.1.0/Libraries/libGNSMessages.a
}
