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
    if (message) {
      var letters = ["Ф", "О", "Р", "К"];
      var parsed = JSON.parse(message);
      for (var i = 0; i < letters.length; i++) {
        var l = letters[i];
        values.append({
          letter: l,
          value: parsed.values[l].value || 0,
          circled: parsed.values[l].circled || false
        });
      }
    } else {
      values.append({ letter: "Ф", value: 1, circled: false });
      values.append({ letter: "О", value: 1, circled: false });
      values.append({ letter: "Р", value: 1, circled: false });
      values.append({ letter: "К", value: 1, circled: false });
      build();
    }
    for (var i = 0; i < 10; i++) {
      people.append({
        name: "",
        token: Math.random().toString(36).slice(2),
        letters: ([
          { letter: "Ф", value: Math.random() * 3, circled: Math.random() > 0.5 },
          { letter: "О", value: Math.random() * 3, circled: Math.random() > 0.5 },
          { letter: "Р", value: Math.random() * 3, circled: Math.random() > 0.5 },
          { letter: "К", value: Math.random() * 3, circled: Math.random() > 0.5 }
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
      name: name,
      values: {}
    };
    for (var i = 0; i < values.count; i++) {
      msg.values[values.get(i).letter] = {
        value: values.get(i).value,
        circled: values.get(i).circled
      };
    }
    message = JSON.stringify(msg);
  }
}
