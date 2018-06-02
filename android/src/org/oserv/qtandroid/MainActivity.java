package org.oserv.qtandroid;

import org.qtproject.qt5.android.bindings.QtActivity;

import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.content.IntentSender;
import android.content.res.Resources;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.Log;
import android.util.SparseArray;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.nearby.Nearby;
import com.google.android.gms.nearby.messages.Message;
import com.google.android.gms.nearby.messages.MessageListener;
import com.google.android.gms.nearby.messages.PublishCallback;
import com.google.android.gms.nearby.messages.PublishOptions;
import com.google.android.gms.nearby.messages.Strategy;
import com.google.android.gms.nearby.messages.SubscribeCallback;
import com.google.android.gms.nearby.messages.SubscribeOptions;

import java.nio.charset.Charset;

public class MainActivity extends QtActivity
    implements GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener
{
    private static final int REQUEST_RESOLVE_ERROR = 1001;
    private static final String TAG = MainActivity.class.getSimpleName();

    private static MainActivity mActivity;
    private static NotificationManager mNotificationManager;
    private static Notification.Builder mBuilder;
    private static GoogleApiClient mGoogleApiClient;
    private static MessageListener mMessageListener;

    private static boolean connectCalled = false;
    private static final SparseArray<Message> messages = new SparseArray<Message>();

    public MainActivity() {
        mActivity = this;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d(TAG, "onCreate");
        buildGoogleApiClient();
        buildMessageListener();
    }

    @Override
    protected void onStart() {
        super.onStart();
        Log.d(TAG, "onStart");
        if (connectCalled) connect();
    }

    @Override
    public void onStop() {
        Log.d(TAG, "onStop");
        if (mGoogleApiClient.isConnected()) {
            // Unpublish everything
            for (int i = 0; i < messages.size(); i++) {
               unpublishMessage(messages.keyAt(i));
            }
            unsubscribe();
            mGoogleApiClient.disconnect();
            nativeApiStatus(0);
        }
        super.onStop();
    }

    public static Message newNearbyMessage(String string, String type) {
        return new Message(string.getBytes(Charset.forName("UTF-8")), type);
    }
    public static String fromNearbyMessage(Message message) {
        return new String(message.getContent()).trim();
    }

    private void buildGoogleApiClient() {
        if (mGoogleApiClient != null) return;
        Log.d(TAG, "buildGoogleApiClient");
        mGoogleApiClient = new GoogleApiClient.Builder(this)
            .addApi(Nearby.MESSAGES_API)
            .addConnectionCallbacks(this)
            .addOnConnectionFailedListener(this)
            .build();
    }
    private void buildMessageListener() {
        Log.d(TAG, "buildMessageListener");
        mMessageListener = new MessageListener() {
            @Override
            public void onFound(Message message) {
                Log.d(TAG, "message found");
                nativeNearbyMessage(1, fromNearbyMessage(message), message.getType());
            }
            @Override
            public void onLost(Message message) {
                Log.d(TAG, "message lost");
                nativeNearbyMessage(-1, fromNearbyMessage(message), message.getType());
            }
        };
    }

    // Modes: 1 - Nearby BLE, 3 - Nearby full
    private static void subscribe() {
        // TODO: BLE_ONLY?
        // TODO: Specify timeout?
        Strategy strategy = new Strategy.Builder()
            .setTtlSeconds(Strategy.TTL_SECONDS_INFINITE)
            .build();
        SubscribeOptions options = new SubscribeOptions.Builder()
            .setStrategy(strategy)
            .setCallback(new SubscribeCallback() {
                @Override
                public void onExpired() {
                    super.onExpired();
                    Log.i(TAG, "subscription expired");
                    mActivity.nativeNearbySubscription(-1, 3);
                }
            })
            .build();
        Log.d(TAG, "subscribe()");
        Nearby.Messages.subscribe(mGoogleApiClient, mMessageListener, options)
            .setResultCallback(new ResultCallback<Status>() {
                @Override
                public void onResult(@NonNull Status status) {
                    if (status.isSuccess()) {
                        Log.d(TAG, "subscribe success");
                        mActivity.nativeNearbySubscription(1, 3);
                    } else {
                        Log.w(TAG, "subscribe failed");
                        mActivity.nativeNearbySubscription(-1, 3);
                    }
                }
            });
    }
    private static void unsubscribe() {
        Log.d(TAG, "unsubscribe()");
        Nearby.Messages.unsubscribe(mGoogleApiClient, mMessageListener);
        mActivity.nativeNearbySubscription(-1, 3);
    }

    private static int messagesCount = 0;
    public static int publishMessage(String messageString, String messageType) {
        final int id = messagesCount++;
        final Message message = newNearbyMessage(messageString, messageType);
        messages.put(id, message);
        // TODO: BLE_ONLY?
        // TODO: set timeout?
        Strategy strategy = new Strategy.Builder()
            .setTtlSeconds(Strategy.TTL_SECONDS_MAX)
            .build();
        PublishOptions options = new PublishOptions.Builder()
            .setStrategy(strategy)
            .setCallback(new PublishCallback() {
                @Override
                public void onExpired() {
                    super.onExpired();
                    Log.i(TAG, "publish expired");
                    mActivity.nativeNearbyOwnMessage(-1, id, fromNearbyMessage(message), message.getType());
                    messages.remove(id);
                }
            })
            .build();
        Nearby.Messages.publish(mGoogleApiClient, message)
            .setResultCallback(new ResultCallback<Status>() {
                @Override
                public void onResult(@NonNull Status status) {
                    if (status.isSuccess()) {
                        Log.d(TAG, "publish success");
                        mActivity.nativeNearbyOwnMessage(1, id, fromNearbyMessage(message), message.getType());
                    } else {
                        Log.w(TAG, "publish failed");
                        mActivity.nativeNearbyOwnMessage(0, id, fromNearbyMessage(message), message.getType());
                        messages.remove(id);
                    }
                }
            });
        return id;
    }
    private static void unpublishMessage(final int id) {
        if (messages.indexOfKey(id) < 0) return;
        Log.d(TAG, "unpublishMessage()");
        final Message message = messages.get(id);
        Nearby.Messages.unpublish(mGoogleApiClient, message)
          .setResultCallback(new ResultCallback<Status>() {
              @Override
              public void onResult(@NonNull Status status) {
                  if (status.isSuccess()) {
                      messages.remove(id);
                      Log.d(TAG, "unpublish success");
                      mActivity.nativeNearbyOwnMessage(-1, id, fromNearbyMessage(message), message.getType());
                  } else {
                      Log.w(TAG, "unpublish failed");
                      mActivity.nativeNearbyOwnMessage(0, id, fromNearbyMessage(message), message.getType());
                  }
              }
          });
    }

    private static boolean NearbyPermissionDialogOpen = false;
    public static void connect() {
        if (mActivity.mGoogleApiClient.isConnected()) return;
        connectCalled = true;
        Log.d(TAG, ".connect()");
        mActivity.mGoogleApiClient.connect();
    }
    @Override
    public void onConnected(@Nullable Bundle bundle) {
        Log.d(TAG, "GoogleApiClient connection connected");
        nativeApiStatus(1);
    }
    @Override
    public void onConnectionSuspended(int i) {
        Log.d(TAG, "GoogleApiClient connection supended");
        nativeApiStatus(0);
    }
    @Override
    public void onConnectionFailed(@NonNull ConnectionResult connectionResult) {
        Log.d(TAG, "GoogleApiClient onConnectionFailed");
        if (NearbyPermissionDialogOpen) return;
        if (!connectionResult.hasResolution()) {
            Log.w(TAG, "GoogleApiClient connection failed");
            nativeApiStatus(-2);
            return;
        }
        Log.d(TAG, "GoogleApiClient connection has resolution");
        nativeApiStatus(-1);
        try {
            // Permission dialog
            NearbyPermissionDialogOpen = true;
            connectionResult.startResolutionForResult(this, REQUEST_RESOLVE_ERROR);
        } catch (IntentSender.SendIntentException e) {
            Log.w(TAG, "GoogleApiClient connection failed resolution");
            NearbyPermissionDialogOpen = false;
            nativeApiStatus(-2);
            mGoogleApiClient.connect();
        }
    }
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_RESOLVE_ERROR) {
            NearbyPermissionDialogOpen = false;
            Log.d(TAG, "Got result from resolution request for GoogleApiClient");
            if (resultCode == RESULT_OK) {
              mGoogleApiClient.connect();
            } else {
              nativeApiStatus(-2);
            }
        }
    }

    private static int notificationsCount = 0;
    public static void notify(String title, String text) {
        notify(notificationsCount++, text, title);
    }
    public static void notify(int id, String title, String text) {
        if (mNotificationManager == null) {
            mNotificationManager = (NotificationManager) mActivity.getSystemService(Context.NOTIFICATION_SERVICE);
            mBuilder = new Notification.Builder(mActivity);
            Resources resources = mActivity.getResources();
            final int resourceId = resources.getIdentifier("icon", "drawable", mActivity.getPackageName());
            mBuilder.setSmallIcon(resourceId);
        }
        mBuilder.setContentTitle(title);
        mBuilder.setContentText(text);
        mNotificationManager.notify(id, mBuilder.build());
    }

    private native void nativePing(int type);
    private native void nativeApiStatus(int status);
    private native void nativeNearbySubscription(int status, int mode);
    private native void nativeNearbyOwnMessage(int status, int id, String message, String type);
    private native void nativeNearbyMessage(int status, String message, String type);
}
