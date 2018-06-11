import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

SwipeView {
  id: swipeView
  anchors.fill: parent
  currentIndex: 1

  SelectorPage {}
  PeoplePage {}
}
