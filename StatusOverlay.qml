import QtQuick 2.0

Item {
  id: overlay
  anchors.fill: parent
  visible: api.apiStatus < 1 && typeof Native !== 'undefined'
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
