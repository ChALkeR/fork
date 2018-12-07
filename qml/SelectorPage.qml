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

  Item {
    id: pronounBlock
    width: parent.width
    visible: api.pronoun || api.pronouns.length > 0
    height: 30
    Rectangle {
      anchors.fill: parent
      color: Qt.lighter(palette.alternateBase, 1.01)
    }
    Text {
      anchors.centerIn: parent
      width: parent.width - 20
      text: api.pronoun || '???'
      font.pixelSize: 14
      visible: !pronounInput.visible
    }
    MouseArea {
      anchors.fill: parent
      onClicked: {
        pronounInput.visible = true
        pronounInput.forceActiveFocus()
      }
    }
    TextField {
      id: pronounInput
      visible: false
      anchors.centerIn: parent
      width: parent.width - 20
      text: api.pronoun
      placeholderText: qsTr('Pronoun')
      inputMethodHints: Qt.ImhNoPredictiveText
      font.pixelSize: 14
      onEditingFinished: {
        api.pronoun = text
        description.forceActiveFocus()
        visible = false
      }
    }
  }

  Text {
    id: description
    x: 10
    y: 35
    width: parent.width - 20
    height: 50
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
    visible: !pronounSelector.visible
    Repeater {
      id: letters
      model: api.values
      delegate: Column {
        spacing: 30
        id: block
        property string key: model.key
        property string letter: model.letter
        property int value: model.value
        property bool circled: model.circled
        property int number: index
        Item {
          height: 20
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
                letter: block.letter
                anchors.centerIn: parent
                circled: block.circled
                value: index
              }
              opacity: index === tumbler.currentIndex ? 1 : 0.25
            }
            property bool active: false
            onCurrentIndexChanged: {
              if (!active) return
              api.values.setProperty(block.number, "value", currentIndex)
              description.show(block.key, block.value, block.circled)
              forceActiveFocus()
            }
            Component.onCompleted: { currentIndex = block.value; active = true }
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

  Item {
    id: pronounSelector
    anchors.top: pronounBlock.bottom
    width: parent.width
    height: pronounFlow.height + 20
    visible: pronounInput.visible && api.pronouns.length > 0
    Rectangle {
      anchors.fill: parent
      color: palette.base
    }
    Flow {
      id: pronounFlow
      width: parent.width - 10
      x: 5
      y: 10
      spacing: 10
      Repeater {
        model: api.pronouns
        delegate: Item {
          height: 25
          width: pronounSelectorText.width + 10
          Rectangle {
            anchors.fill: parent
            radius: 3
            color: palette.alternateBase
          }
          Text {
            font.pixelSize: 15
            id: pronounSelectorText
            text: modelData
            anchors.centerIn: parent
          }
          MouseArea {
            anchors.fill: parent
            onClicked: {
              api.pronoun = modelData
              pronounInput.visible = false
              description.forceActiveFocus()
            }
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
      text: qsTr("Go back")
      onClicked: swipeView.currentIndex = 1
    }
  }
}
