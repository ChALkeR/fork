#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTranslator>
#include "native.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("ChALkeR");
    QCoreApplication::setOrganizationDomain("oserv.org");
    QCoreApplication::setApplicationName("TOSC");

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QTranslator translator;
    translator.load(QLocale::system().name(), ":/languages/");
    app.installTranslator(&translator);

    QQmlApplicationEngine engine;

    Native native;
    engine.rootContext()->setContextProperty(QLatin1String("Native"), &native);

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
