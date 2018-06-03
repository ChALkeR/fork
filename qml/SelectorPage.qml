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
      placeholderText: qsTr("Name")
      inputMethodHints: Qt.ImhNoPredictiveText
      onTextChanged: api.name = text
      onEditingFinished: row.forceActiveFocus()
    }
  }
  MouseArea {
    anchors.fill: parent
    onClicked: parent.forceActiveFocus()
  }
  Text {
    id: description
    x: 10
    y: 20
    width: parent.width - 20
    height: 60
    font.pixelSize: 18
    fontSizeMode: Text.Fit
    wrapMode: Text.Wrap
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    opacity: 0
    visible: opacity > 0
    function show(type, value, flag) {
      text = api.descriptions[type][value][flag ? 1 : 0]
      opacity = 1
      descriptionTimer.restart()
    }
    Timer {
      id: descriptionTimer
      running: false
      interval: 5000
      onTriggered: description.opacity = 0
    }
    Behavior on opacity {
      NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }
  }
  Row {
    id: row
    anchors.centerIn: parent
    Repeater {
      id: letters
      model: api.values
      delegate: Column {
        spacing: 50
        id: column
        property string key: model.key
        property string letter: model.letter
        property int value: model.value
        property int circled: model.circled
        property int number: index
        Item {
          height: 30
          width: parent.width
        }
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
                circled: column.circled
                value: index
              }
              opacity: index === tumbler.currentIndex ? 1 : 0.25
            }
            property bool active: false
            onCurrentIndexChanged: {
              if (!active) return
              api.values.setProperty(column.number, "value", currentIndex)
              description.show(column.key, column.value, column.circled)
              forceActiveFocus()
            }
            Component.onCompleted: { currentIndex = column.value; active = true }
          }
        }
        Switch {
          checked: model.circled
          property bool active: false
          onCheckedChanged: {
            if (!active) return
            api.values.setProperty(index, "circled", checked)
            description.show(model.key, model.value, model.circled)
            forceActiveFocus()
          }
          Component.onCompleted: active = true
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
