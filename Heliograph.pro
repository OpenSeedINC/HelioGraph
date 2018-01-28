TEMPLATE = app

QT += qml quick widgets svg sql

SOURCES += main.cpp \
    myio.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    myio.h

DISTFILES += \
    comments.qml \
    eula.html \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS = \
        $$PWD/../CafeSync/openssl/libcrypto.so \
        $$PWD/../CafeSync/openssl/libssl.so
}

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

