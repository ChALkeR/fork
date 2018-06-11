import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Page {
  header: Item {
    height: 50
    Rectangle {
      anchors.fill: parent
      color: palette.alternateBase
    }
    Text {
      text: qsTr("Settings")
      font.pixelSize: 18
      height: parent.height
      x: 10
      verticalAlignment: Text.AlignVCenter
    }
  }

  GridLayout {
    columns: 2
    x: 10
    y: 10
    width: parent.width - 20
    Text {
      font.pixelSize: 20
      text: qsTr("Enable")
      Layout.fillWidth: true
    }
    Switch {
      height: 50
      checked: api.enabled
      onCheckedChanged: api.enabled = checked
    }
  }

  footer: Item {
    height: 60
    Rectangle {
      anchors.fill: parent
      color: palette.alternateBase
    }
    Button {
      height: 50
      anchors.centerIn: parent
      text: qsTr("Go back")
      onClicked: swipeView.currentIndex = 1
    }
  }
}
