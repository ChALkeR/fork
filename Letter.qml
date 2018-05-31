import QtQuick 2.0

Item {
  property real size: 20
  property bool circled: false
  property var colors: ["red", "blue", "green"]
  property int value: 1
  property color color: colors[value]
  property string letter: "?"
  Rectangle {
    anchors.fill: parent
    color: 'transparent'
    visible: circled
    radius: size
    border.width: 1
    border.color: parent.color
  }

  width: size
  height: size

  Text {
    anchors.centerIn: parent
    text: letter
    font.pixelSize: size * 0.8
    color: parent.color
  }
}
