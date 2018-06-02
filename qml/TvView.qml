import QtQuick 2.7
import QtQuick.Controls 2.0

Page {
  id: page
  scale: parent.width / 1920
  width: parent.width / scale
  height: parent.height / scale
  transformOrigin: Item.TopLeft

  property int cols: api.people.count <= 2*3 ? 3 :
                     api.people.count <= 3*4 ? 4 :
                     api.people.count <= 4*5 ? 5 :
                     api.people.count <= 5*6 ? 6 :
                     api.people.count <= 6*7 ? 7 :
                     api.people.count <= 7*8 ? 8 :
                     api.people.count <= 8*9 ? 9 :
                                               10

  header: Item {
    id: header
    height: page.height - (page.cols - 1) * (flow.spacing + flow.base * 9) + flow.spacing - flow.padding * 2
    Rectangle {
      anchors.fill: parent
      color: palette.alternateBase
    }
    Text {
      font.pixelSize: Math.min(parent.height * 0.7, parent.width * 0.05)
      text: "Сегодня в Кочерге"
      anchors.centerIn: parent
    }
  }

  Flow {
    id: flow
    anchors.fill: parent
    property int base: [32, 25, 20, 17, 15, 14, 12, 11][page.cols - 3]
    property int baseWidth: 16 * base
    spacing: Math.floor((width - page.cols * baseWidth) / (page.cols + 1))
    padding: Math.floor((width - page.cols * baseWidth - (page.cols - 1) * spacing) / 2)

    Repeater {
      model: api.people
      delegate: Item {
        width: flow.base * 16
        height: flow.base * 9
        Item {
          width: 16 * 20
          height: 9 * 20
          scale: parent.width / width
          transformOrigin: Item.TopLeft

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
            text: model.name || ("Гость " + api.token.slice(0, 12))
            font.pixelSize: 28
            elide: Text.ElideRight
          }
          Row {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 25
            Repeater {
              model: letters
              delegate: Letter {
                size: 60
                letter: model.letter
                value: model.value
                circled: model.circled
              }
            }
          }
        }
      }
    }
  }
}
