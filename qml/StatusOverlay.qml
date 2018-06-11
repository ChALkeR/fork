import QtQuick 2.7
import QtQuick.Controls 2.0

Item {
  id: overlay
  anchors.fill: parent
  visible: opacity > 0
  property bool show: api.haveApi && api.enabled && api.apiStatus < 2
  opacity: show ? 1 : 0
  Behavior on opacity {
    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
  }
  onShowChanged: {
    if (!show) {
      opacity = 0
    } else {
      showTimer.restart();
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
      text: api.apiStatus < 0
            ? qsTr("Enable Nearby Messages permission for this app to work.\n\nIt is required to synchronize statuses with nearby devices.")
            : qsTr("Initializing Nearby Messages...")
      font.pixelSize: 18
    }
    Button {
      visible: api.apiStatus === -2
      text: qsTr("Enable")
      anchors.horizontalCenter: parent.horizontalCenter
      onClicked: Native.apiConnect()
    }
  }
}
