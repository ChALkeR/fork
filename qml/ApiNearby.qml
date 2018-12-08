import QtQuick 2.0

Item {
  id: nearby
  property bool haveApi: typeof Native !== 'undefined'
  property bool enabled: false
  property int status: Native.nearbyStatus
  property int subscriptionStatus: Native.nearbySubscriptionStatus

  signal emit(var people)
  signal request()

  property int messageId: -1
  function publish(message) {
    if (Native.nearbyStatus !== 2) return;
    if (messageId >= 0) Native.unpublishMessage(messageId);
    console.log("Publishing:", message, "fork.self");
    var id = Native.publishMessage(message, "fork.self");
    console.log("Publish id:", id);
    messageId = id;
  }

  property int messagePeopleId: -1
  function publishPeople(messagePeople) {
    if (Native.nearbyStatus !== 2) return;
    if (messagePeopleId >= 0) Native.unpublishMessage(messagePeopleId);
    console.log("Publishing:", messagePeople, "fork.others");
    var id = Native.publishMessage(messagePeople, "fork.others");
    console.log("Publish id:", id);
    messagePeopleId = id;
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
      var people = [];
      switch (type) {
      case "fork.self":
        msg.hops = api.addHop;
        people.push(msg);
        break;
      case "fork.others":
        msg.forEach(function(entry) {
          entry.hops += api.addHop;
          people.push(entry);
        });
        break;
      default:
        return;
      }
      if (people.length > 0) {
        nearby.emit(people);
      }
    }
    onNearbyOwnMessage: console.log("NearbyOwnMessage:", status, id, message, type)
  }
}
