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
      visible: !rename.visible
      font.pixelSize: Math.min(parent.height * 0.7, parent.width * 0.05)
      text: api.tvHeader
      anchors.centerIn: parent
    }
    MouseArea {
      anchors.fill: parent
      onClicked: {
        rename.visible = true
        rename.forceActiveFocus()
      }
    }
    TextField {
      id: rename
      visible: false
      font.pixelSize: Math.min(parent.height * 0.7, parent.width * 0.05)
      width: parent.width - 20
      anchors.centerIn: parent
      text: api.tvHeader
      inputMethodHints: Qt.ImhNoPredictiveText
      horizontalAlignment: Text.AlignHCenter
      onEditingFinished: {
        api.tvHeader = text
        header.forceActiveFocus()
        visible = false
      }
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
        Badge {
          token: model.token
          name: model.name
          letters: model.letters

          scale: parent.width / width
          transformOrigin: Item.TopLeft
        }
      }
    }
  }
}
