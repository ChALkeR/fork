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

JNIEXPORT void JNICALL Java_org_oserv_qtandroid_MainActivity_nativeApplicationStatus(JNIEnv *env, jobject obj, jint status)
{

    Q_UNUSED(env)
    Q_UNUSED(obj)
    if (Native::instance() == NULL) {
        Native::s_applicationStatus = status;
        return;
    }
    Native::instance()->setApplicationStatus(status);
}

JNIEXPORT void JNICALL Java_org_oserv_qtandroid_MainActivity_nativeNearbyStatus(JNIEnv *env, jobject obj, jint status, jint mode)
{
    Q_UNUSED(env)
    Q_UNUSED(obj)
    if (Native::instance() == NULL) {
        Native::s_nearbyStatus = status;
        if (mode != -1) {
            Native::s_nearbyMode = mode;
        }
        return;
    }
    Native::instance()->setNearbyStatusMode(status, mode);
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
int Native::s_applicationStatus = 1;
int Native::s_nearbyStatus = 0;
int Native::s_nearbyMode = 0;
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

int Native::applicationStatus() const {
    return s_applicationStatus;
}

void Native::setApplicationStatus(int applicationStatus) {
    if (s_applicationStatus == applicationStatus) return;
    s_applicationStatus = applicationStatus;
    emit applicationStatusChanged();
    if (s_applicationStatus == 0 && s_nearbyStatus > 0 && s_nearbyMode == 3) {
        // Suspend Nearby activity when app is stopped in full Nearby mode
        nearbyDisconnect();
    }
}

void Native::setNearbyStatusMode(int status, int mode) {
    if (mode == -1) mode = s_nearbyMode;
    if (s_nearbyStatus == status) return;
    s_nearbyStatus = status;
    if (s_nearbyMode != mode) {
        s_nearbyMode = mode;
        emit nearbyModeChanged();
    }
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
int Native::nearbyMode() const {
    return s_nearbyMode;
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

// `mode` is the current mode, `bleOnly` is the requested permissions
void Native::nearbyConnect(int mode, bool bleOnly) {
    if (mode == 3) bleOnly = false;
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>(
        "org/oserv/qtandroid/MainActivity", "nearbyConnect", "(II)V",
        mode,
        bleOnly ? 1 : 0
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
    if (mode <= 0) mode = s_nearbySubscriptionMode;
    if (mode <= 0) mode = s_nearbyMode;
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
        "org/oserv/qtandroid/MainActivity", "publishMessage", "(Ljava/lang/String;Ljava/lang/String;I)I",
        QAndroidJniObject::fromString(message).object<jstring>(),
        QAndroidJniObject::fromString(type).object<jstring>(),
        s_nearbyMode
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
