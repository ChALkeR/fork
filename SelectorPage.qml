import QtQuick 2.7
import QtQuick.Controls 2.0

Page {
  header: Item {
    height: 50
    Rectangle {
      anchors.fill: parent
      color: palette.alternateBase
    }
    TextField {
      text: api.name
      width: parent.width - 20
      font.pixelSize: 18
      anchors.centerIn: parent
      placeholderText: "Имя"
      inputMethodHints: Qt.ImhNoPredictiveText
      onTextChanged: api.name = text
    }
  }
  Row {
    anchors.centerIn: parent
    Repeater {
      id: letters
      model: api.values
      delegate: Column {
        spacing: 50
        id: column
        property string letter: model.letter
        property int value: model.value
        property int number: index
        Item {
          height: tumbler.height
          width: parent.width
          Rectangle {
            anchors.left: tumbler.left
            anchors.right: tumbler.right
            anchors.verticalCenter: tumbler.verticalCenter
            color: palette.alternateBase
            height: 40
          }
          Tumbler {
            id: tumbler
            model: 3
            delegate: Item {
              height: 40
              width: parent.width
              Letter {
                size: 24
                letter: column.letter
                anchors.centerIn: parent
                circled: circledSwitch.checked
                value: index
              }
              opacity: index === tumbler.currentIndex ? 1 : 0.25
            }
            property bool active: false
            onCurrentIndexChanged: if (active) api.values.setProperty(column.number, "value", currentIndex)
            Component.onCompleted: { currentIndex = column.value; active = true }
          }
        }
        Switch {
          id: circledSwitch
          checked: model.circled
          onCheckedChanged: api.values.setProperty(index, "circled", checked)
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
      text: "Вернуться"
      onClicked: swipeView.currentIndex = 1
    }
  }
}
