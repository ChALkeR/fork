#include "native.h"
#include <QDebug>

#ifdef Q_OS_ANDROID
#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#include <QtAndroid>
JNIEXPORT void JNICALL Java_org_oserv_qtandroid_MainActivity_nativePing(JNIEnv *env, jobject obj, jint value)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)
    Native::instance()->ping(value);
}

JNIEXPORT void JNICALL Java_org_oserv_qtandroid_MainActivity_nativeApiStatus(JNIEnv *env, jobject obj, jint status)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)
    if (Native::instance() == NULL) {
        Native::s_apiStatus = status;
        return;
    }
    Native::instance()->setApiStatus(status);
}

JNIEXPORT void JNICALL Java_org_oserv_qtandroid_MainActivity_nativeNearbySubscription(JNIEnv *env, jobject obj, jint status, jint mode)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)
    if (Native::instance() == NULL) {
        Native::s_nearbySubscriptionStatus = status;
        Native::s_nearbySubscriptionMode = mode;
        return;
    }
    Native::instance()->setNearbySubscriptionStatusMode(status, mode);
}

JNIEXPORT void JNICALL Java_org_oserv_qtandroid_MainActivity_nativeNearbyMessage(JNIEnv *env, jobject obj, jint status, jstring j_message, jstring j_type) {
    Q_UNUSED(obj)
    QString message(env->GetStringUTFChars(j_message, 0));
    QString type(env->GetStringUTFChars(j_type, 0));
    Native::instance()->nearbyMessage(status, message, type);
}

JNIEXPORT void JNICALL Java_org_oserv_qtandroid_MainActivity_nativeNearbyOwnMessage(JNIEnv *env, jobject obj, jint status, jint id, jstring j_message, jstring j_type) {
    Q_UNUSED(obj)
    QString message(env->GetStringUTFChars(j_message, 0));
    QString type(env->GetStringUTFChars(j_type, 0));
    Native::instance()->nearbyOwnMessage(status, id, message, type);
}

#endif

Native* Native::m_instance = NULL;
int Native::s_apiStatus = 0;
int Native::s_nearbySubscriptionStatus = 0;
int Native::s_nearbySubscriptionMode = 0;

Native::Native(QObject *parent) : QObject(parent) {
    m_instance = this;
}
Native::~Native() {
    m_instance = NULL;
}
Native* Native::instance() {
    return m_instance;
}

void Native::setApiStatus(int apiStatus) {
    if (s_apiStatus == apiStatus) return;
    s_apiStatus = apiStatus;
    emit apiStatusChanged();
}
void Native::setNearbySubscriptionStatusMode(int status, int mode) {
    if (s_nearbySubscriptionStatus == status && s_nearbySubscriptionMode == mode) return;
    s_nearbySubscriptionStatus = status;
    if (s_nearbySubscriptionMode != mode) {
        s_nearbySubscriptionMode = mode;
        emit nearbySubscriptionModeChanged();
    }
    emit nearbySubscriptionStatusChanged();
}

int Native::apiStatus() const {
    return s_apiStatus;
}
int Native::nearbySubscriptionStatus() const {
    return s_nearbySubscriptionStatus;
}
int Native::nearbySubscriptionMode() const {
    return s_nearbySubscriptionMode;
}

void Native::notify(QString title, QString text) {
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>(
        "org/oserv/qtandroid/MainActivity", "notify", "(Ljava/lang/String;Ljava/lang/String;)V",
        QAndroidJniObject::fromString(title).object<jstring>(),
        QAndroidJniObject::fromString(text).object<jstring>()
    );
#endif
}

void Native::apiConnect() {
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>(
        "org/oserv/qtandroid/MainActivity", "connect", "()V"
    );
#endif
}

void Native::nearbySubscribe() {
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>(
        "org/oserv/qtandroid/MainActivity", "subscribe", "()V"
    );
#endif
}

int Native::publishMessage(const QString &message, const QString &type) {
#ifdef Q_OS_ANDROID
    jint result = QAndroidJniObject::callStaticMethod<jint>(
        "org/oserv/qtandroid/MainActivity", "publishMessage", "(Ljava/lang/String;Ljava/lang/String;)I",
        QAndroidJniObject::fromString(message).object<jstring>(),
        QAndroidJniObject::fromString(type).object<jstring>()
    );
    return result;
#else
    return -1;
#endif
}

void Native::unpublishMessage(int id) {
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>(
        "org/oserv/qtandroid/MainActivity", "unpublishMessage", "(I)V",
        id
    );
#endif
}
