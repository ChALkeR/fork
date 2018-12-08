import QtQuick 2.0

Item {
  id: nearby
  property bool haveApi: typeof Native !== 'undefined'
  property bool enabled: false
  property int status: Native.nearbyStatus
  property int subscriptionStatus: Native.nearbySubscriptionStatus

  signal emit(var people)
  signal request()

  property var messageId: ({self: -1, others: -1})
  function publish(message, type) {
    if (Native.nearbyStatus !== 2) return;
    if (type !== 'self' && type !== 'others') return;
    if (messageId[type] >= 0) Native.unpublishMessage(messageId[type]);
    console.log("Publishing:", type, message);
    var id = Native.publishMessage(message, 'tosc.' + type);
    console.log("Publish id:", type, id);
    messageId[type] = id;
  }

  function connect() {
    Native.nearbyConnect(1)
  }
  function disconnect() {
    Native.nearbyDisconnect();
  }

  onEnabledChanged: nearby.disconnect()
  Timer {
    interval: 100
    running: haveApi && nearby.enabled && nearby.status === 0
    onTriggered: nearby.connect()
  }
  Timer {
    interval: 100
    running: haveApi && nearby.enabled && nearby.status == 2 && nearby.subscriptionStatus <= 0
    onTriggered: Native.nearbySubscribe()
  }

  onStatusChanged: request()

  Connections {
    target: Native
    onPing: console.log("Ping:", value)
    onNearbyMessage: {
      console.log("NearbyMessage:", status, message, type)
      var msg = JSON.parse(message);
      switch (type.replace(/^(fork|tosc)\./)) {
      case 'self':
        nearby.emit([msg]);
        break;
      case 'others':
        nearby.emit(msg);
        break;
      default:
        return;
      }
    }
    onNearbyOwnMessage: console.log("NearbyOwnMessage:", status, id, message, type)
  }
}
