import QtQuick 2.7
import QtQuick.Controls 2.0

ApplicationWindow {
  visible: true
  width: 320
  height: 640
  title: qsTr("Кочерга.ФОРК")

  Api {
    id: api
  }

  MainView { }
  StatusOverlay { }
}
