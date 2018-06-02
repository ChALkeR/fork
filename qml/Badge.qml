import QtQuick 2.7

Item {
  id: badge
  width: 16 * 20
  height: 9 * 20

  property string token
  property string name
  property var letters

  Rectangle {
    anchors.fill: parent
    color: palette.alternateBase
  }
  Text {
    anchors.fill: parent
    anchors.topMargin: 20
    anchors.leftMargin: 10
    anchors.rightMargin: 10
    horizontalAlignment: Text.AlignHCenter
    text: badge.name || ("Гость " + badge.token.slice(0, 12))
    font.pixelSize: 28
    elide: Text.ElideRight
  }
  Row {
    spacing: 10
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 25
    Repeater {
      model: badge.letters
      delegate: Letter {
        size: 60
        letter: model.letter
        value: model.value
        circled: model.circled
      }
    }
  }
}
