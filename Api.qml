import QtQuick 2.0
import Qt.labs.settings 1.0

Item {
  id: api
  property ListModel people: ListModel { }
  property ListModel values: ListModel {
    onDataChanged: api.build()
  }
  property string name
  property string token
  property string message
  onNameChanged: build()
  onMessageChanged: console.log(message)

  Component.onCompleted: {
    if (!token) {
      token = Math.random().toString(36).slice(2);
    }

    var keys = "potc";
    var letters = "ФОРК";
    var parsed = message ? JSON.parse(message) : {};
    if (!parsed.values) parsed.values = {};
    for (var i = 0; i < keys.length; i++) {
      var key = keys[i];
      var entry = parsed.values[key] || { value: 1, circled: false };
      values.append({
        key: key,
        letter: letters[i],
        value: entry.value || 0,
        circled: entry.circled || false
      });
    }
    build();

    for (var j = 0; j < 10; j++) {
      people.append({
        name: "",
        token: Math.random().toString(36).slice(2),
        letters: ([
          { key: "p", letter: "Ф", value: Math.random() * 3, circled: Math.random() > 0.5 },
          { key: "o", letter: "О", value: Math.random() * 3, circled: Math.random() > 0.5 },
          { key: "t", letter: "Р", value: Math.random() * 3, circled: Math.random() > 0.5 },
          { key: "c", letter: "К", value: Math.random() * 3, circled: Math.random() > 0.5 }
        ])
      });
    }
  }
  Settings {
    property alias name: api.name
    property alias token: api.token
    property alias message: api.message
  }

  function build() {
    var msg = {
      token: token,
      name: name,
      values: {}
    };
    for (var i = 0; i < values.count; i++) {
      msg.values[values.get(i).key] = {
        value: values.get(i).value,
        circled: values.get(i).circled
      };
    }
    message = JSON.stringify(msg);
  }
}
