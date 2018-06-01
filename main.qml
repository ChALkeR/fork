import QtQuick 2.7
import QtQuick.Controls 2.0

ApplicationWindow {
  id: window
  visible: true
  width: 320
  height: 640
  visibility: api.isTv ? ApplicationWindow.FullScreen : ApplicationWindow.AutomaticVisibility
  title: qsTr("Кочерга.ФОРК")

  Api {
    id: api
  }

  MainView {
    visible: !api.isTv
  }

  TvView {
    visible: api.isTv
  }

  StatusOverlay { }
}
