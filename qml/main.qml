import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.2;

ApplicationWindow {
  id: window
  visible: true
  width: 320
  height: 568 - 20
  visibility: api.isTv && api.haveApi
                ? ApplicationWindow.FullScreen
                : ApplicationWindow.AutomaticVisibility
  title: qsTr("TOSC")

  Api {
    id: api
  }

  MainView {
    visible: !api.isTv
  }

  TvView {
    visible: api.isTv
  }
}
