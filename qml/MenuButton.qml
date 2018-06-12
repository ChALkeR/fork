import QtQuick 2.0
import QtQuick.Controls 2.0

Button {
  height: 50
  width: height - 10
  text: ""
  flat: true
  Rectangle {
    id: dot
    width: 3
    height: width
    radius: width
    color: '#000'
    anchors.centerIn: parent
  }
  Rectangle {
    width: dot.width
    height: width
    radius: width
    color: dot.color
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: parent.height * 16/50
  }
  Rectangle {
    width: dot.width
    height: width
    radius: width
    color: dot.color
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: parent.height * 16/50
  }
}
