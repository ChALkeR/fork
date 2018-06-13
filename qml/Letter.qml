import QtQuick 2.0

Item {
  property real size: 20
  property bool circled: false
  property var colors: ["red", "blue", "green"]
  property int value: 1
  property color color: api.monochrome ? "#000" : colors[value]
  property string letter: "?"
  Rectangle {
    anchors.fill: parent
    color: 'transparent'
    visible: circled
    radius: size
    border.width: Math.max(1, Math.round(size / 30))
    border.color: parent.color
  }

  width: size
  height: size

  Text {
    anchors.centerIn: parent
    text: letter
    opacity: api.monochrome ? 0.3 : 1
    font.pixelSize: size * 0.8
    color: parent.color
  }
  Text {
    visible: api.monochrome
    anchors.centerIn: parent
    text: "X?_"[value]
    font.pixelSize: size * 1.25
    color: "#000"
  }
}
