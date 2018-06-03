import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

SwipeView {
  id: swipeView
  anchors.fill: parent
  currentIndex: 1

  SelectorPage {}
  Page {
    id: page
    header: Item {
      height: 50
      Rectangle {
        anchors.fill: parent
        color: palette.alternateBase
      }
      Row {
        width: parent.width - 10
        anchors.centerIn: parent
        spacing: 3
        Text {
          text: api.name || api.altName
          font.pixelSize: 18
          anchors.verticalCenter: parent.verticalCenter
          verticalAlignment: Text.AlignVCenter
          width: parent.width - (24 + 3) * 4
          fontSizeMode: Text.Fit
          elide: Text.ElideRight
        }
        Repeater {
          model: api.values
          delegate: Item {
            width: 24
            height: 50
            Letter {
              anchors.centerIn: parent
              size: 24
              letter: model.letter
              value: model.value
              circled: model.circled
            }
          }
        }
      }
      MouseArea {
        anchors.fill: parent
        onClicked: swipeView.currentIndex = 0
      }
    }
    ListView {
      model: api.people
      anchors.fill: parent
      spacing: 5
      header: Item {
        height: 10
      }
      footer: Item {
        height: 10
      }
      delegate: Item {
        width: parent.width
        height: 28
        RowLayout {
          height: parent.height
          width: parent.width - 10
          anchors.centerIn: parent
          spacing: 3
          Text {
            text: model.name || model.altName
            font.pixelSize: 18
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
            fontSizeMode: Text.Fit
            elide: Text.ElideRight
          }
          Repeater {
            model: letters
            delegate: Letter {
              size: 24
              letter: model.letter
              value: model.value
              circled: model.circled
            }
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
        text: "Редактировать"
        onClicked: swipeView.currentIndex = 0
      }
    }
  }
}
