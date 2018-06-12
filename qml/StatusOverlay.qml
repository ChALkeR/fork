import QtQuick 2.7
import QtQuick.Controls 2.0

Item {
  id: overlay
  anchors.fill: parent
  visible: opacity > 0
  property bool show: !api.enabled || api.haveApi && api.nearbyStatus < 2
  opacity: show ? 1 : 0
  Behavior on opacity {
    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
  }
  onShowChanged: {
    if (!show) {
      opacity = 0
    } else if (api.enabled && api.nearbyStatus >= 0) {
      showTimer.restart();
    } else {
      opacity = 1
    }
  }
  Timer {
    id: showTimer
    interval: 2000
    onTriggered: if (show) opacity = 1
  }

  Rectangle {
    anchors.fill: parent
    color: palette.alternateBase
  }

  Column {
    anchors.centerIn: parent
    width: parent.width * 0.8
    spacing: 20
    Text {
      width: parent.width
      wrapMode: Text.Wrap
      horizontalAlignment: Text.AlignHCenter
      text:
        !api.enabled
          ? qsTr("Enable TOSC to see statuses nearby.")
        : api.nearbyStatus >= 0
          ? qsTr("Initializing Nearby Messages...")
          : qsTr("Enable Nearby Messages permission for this app to work.\n\nIt is required to synchronize statuses with nearby devices.")
      font.pixelSize: 18
    }
    Button {
      visible: !api.enabled || api.nearbyStatus === -2
      text: qsTr("Enable")
      highlighted: true
      anchors.horizontalCenter: parent.horizontalCenter
      onClicked: {
        if (!api.enabled) {
          api.enabled = true
        } else if (api.nearbyStatus === -2) {
          Native.apiConnect()
        }
      }
    }
  }
}
