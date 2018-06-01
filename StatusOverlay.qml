import QtQuick 2.7

Item {
  id: overlay
  anchors.fill: parent
  visible: opacity > 0
  property bool show: api.apiStatus < 1 && typeof Native !== 'undefined'
  opacity: show ? 1 : 0
  Behavior on opacity {
    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
  }
  onShowChanged: {
    if (!show) {
      opacity = 0
    } else {
      showTimer.restart();
    }
  }
  Timer {
    id: showTimer
    interval: 2000
    onTriggered: if (show) opacity = 1
  }

  Rectangle {
    anchors.fill: parent
    color: palette.alternateBase
  }
  Text {
    anchors.centerIn: parent
    width: parent.width * 0.8
    wrapMode: Text.Wrap
    horizontalAlignment: Text.AlignHCenter
    text: api.apiStatus < 0
          ? "Включите разрешение Nearby Messages для работы приложения.\n\nОно необходимо для синхронизации статуса с устройствами поблизости."
          : "Инициализация Nearby Messages..."
    font.pixelSize: 18
  }
}
