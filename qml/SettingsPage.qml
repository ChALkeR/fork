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

  Flickable {
    anchors.fill: parent
    contentHeight: column.height + 20
    flickableDirection: Flickable.VerticalFlick

    Column {
      id: column
      x: 10
      y: 10
      width: parent.width - 20
      spacing: 10
      RowLayout {
        width: parent.width
        Text {
          font.pixelSize: 16
          text: qsTr("Enable")
        }
        Switch {
          checked: api.enabled
          onCheckedChanged: api.enabled = checked
          Layout.alignment: Qt.AlignRight
        }
      }
      RowLayout {
        width: parent.width
        Text {
          font.pixelSize: 16
          text: qsTr("Monochrome mode")
        }
        Switch {
          checked: api.monochrome
          onCheckedChanged: api.monochrome = checked
          Layout.alignment: Qt.AlignRight
        }
      }
      Item {
        height: 40
        width: parent.width
      }
      Item {
        height: 40
        width: parent.width
        Text {
          font.pixelSize: 16
          text: qsTr("Not yet implemented:")
          anchors.verticalCenter: parent.verticalCenter
          color: palette.mid
        }
      }
      RowLayout {
        width: parent.width
        Text {
          font.pixelSize: 16
          text: qsTr("Auto-disable outside")
          color: palette.mid
        }
        ComboBox {
          Layout.preferredWidth: 135
          currentIndex: 0
          model: [ qsTr("50 meters"), qsTr("100 meters"), qsTr("200 meters"), qsTr("Never") ]
          Layout.alignment: Qt.AlignRight
          enabled: false
        }
      }
      RowLayout {
        width: parent.width
        Text {
          font.pixelSize: 16
          text: qsTr("Notify on auto-disabling")
          color: palette.mid
        }
        Switch {
          checked: api.autoDisableNotify
          onCheckedChanged: api.autoDisableNotify = checked
          Layout.alignment: Qt.AlignRight
          enabled: false
        }
      }
      RowLayout {
        width: parent.width
        Text {
          font.pixelSize: 16
          text: qsTr("Notify of new people")
          color: palette.mid
        }
        Switch {
          checked: api.newPeopleNotify
          onCheckedChanged: api.newPeopleNotify = checked
          Layout.alignment: Qt.AlignRight
          enabled: false
        }
      }
      RowLayout {
        width: parent.width
        Text {
          font.pixelSize: 16
          text: qsTr("Notify of status changes")
          color: palette.mid
        }
        Switch {
          checked: api.statusChangesNotify
          onCheckedChanged: api.statusChangesNotify = checked
          Layout.alignment: Qt.AlignRight
          enabled: false
        }
      }
      RowLayout {
        width: parent.width
        Text {
          font.pixelSize: 16
          text: qsTr("Background mode")
          color: palette.mid
        }
        Switch {
          checked: api.backgroundMode
          onCheckedChanged: api.backgroundMode = checked
          Layout.alignment: Qt.AlignRight
          enabled: false
        }
      }
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
