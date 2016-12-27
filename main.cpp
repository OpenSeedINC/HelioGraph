#include <QApplication>
#include <QQmlApplicationEngine>

#include <QtQuick/QQuickView>
#include <QGuiApplication>

#include "myio.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qmlRegisterType<MyIOout>("IO", 1, 0, "MyIOout");


    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));


    return app.exec();
}


