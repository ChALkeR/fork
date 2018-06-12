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

JNIEXPORT void JNICALL Java_org_oserv_qtandroid_MainActivity_nativeNearbyStatus(JNIEnv *env, jobject obj, jint status)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)
    if (Native::instance() == NULL) {
        Native::s_nearbyStatus = status;
        return;
    }
    Native::instance()->setNearbyStatus(status);
}

JNIEXPORT void JNICALL Java_org_oserv_qtandroid_MainActivity_nativeNearbySubscription(JNIEnv *env, jobject obj, jint status, jint mode)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)
    if (Native::instance() == NULL) {
        Native::s_nearbySubscriptionStatus = status;
        if (mode != -1) {
            Native::s_nearbySubscriptionMode = mode;
        }
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
int Native::s_nearbyStatus = 0;
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

void Native::setNearbyStatus(int nearbyStatus) {
    if (s_nearbyStatus == nearbyStatus) return;
    s_nearbyStatus = nearbyStatus;
    emit nearbyStatusChanged();
}
void Native::setNearbySubscriptionStatusMode(int status, int mode) {
    if (mode == -1) mode = s_nearbySubscriptionMode;
    if (s_nearbySubscriptionStatus == status && s_nearbySubscriptionMode == mode) return;
    s_nearbySubscriptionStatus = status;
    if (s_nearbySubscriptionMode != mode) {
        s_nearbySubscriptionMode = mode;
        emit nearbySubscriptionModeChanged();
    }
    emit nearbySubscriptionStatusChanged();
}

int Native::nearbyStatus() const {
    return s_nearbyStatus;
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

void Native::nearbyConnect() {
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>(
        "org/oserv/qtandroid/MainActivity", "nearbyConnect", "()V"
    );
#endif
}

void Native::nearbyDisconnect() {
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>(
        "org/oserv/qtandroid/MainActivity", "nearbyDisconnect", "()V"
    );
#endif
}

void Native::nearbySubscribe(int mode) {
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>(
        "org/oserv/qtandroid/MainActivity", "subscribe", "(I)V",
        mode
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
