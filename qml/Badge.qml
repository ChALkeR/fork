import QtQuick 2.7

Item {
  id: badge
  width: 16 * 20
  height: 9 * 20
  clip: true

  property string token
  property string name
  property var letters

  Rectangle {
    anchors.fill: parent
    color: palette.alternateBase
  }
  Text {
    x: 10
    y: 10
    width: parent.width - 20
    height: 60
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    text: badge.name || ("Гость " + badge.token.slice(0, 12))
    font.pixelSize: 60
    fontSizeMode: Text.Fit
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
