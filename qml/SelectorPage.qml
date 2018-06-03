import QtQuick 2.7
import QtQuick.Controls 2.0

Page {
  property var descr: ({
    t: [['Не трогай меня',
         'Руки прочь! Я не хочу, чтобы меня трогали, и это правда очень важно.'],
        ['Спроси, хочу ли я контакта',
         'Я очень хочу обниматься, но не со всеми. Не стесняйтесь спросить!'],
        ['Готов(а) тебя обнимать!',
         'Обнимите меня кто-нибудь!']
    ],
    o: [['Не спрашивай меня о личном',
         'Не лезь в мою жизнь! Личные вопросы мне очень неприятны.'],
        ['Спроси, готов(а) ли я к личным вопросам.',
         'Я очень хочу поговорить о личном, но не со всеми — сперва уточни.'],
        ['Готов(а) к личным вопросам',
         'Задай мне личный вопрос!']
    ],
    s: [['Не разговаривай со мной ни о чём',
         'Не открывай рот смотря на меня. Я не буду ни с кем разговаривать, и это важно для меня.'],
        ['Спроси о готовности разговаривать',
         'Я очень хочу поговорить, но не со всеми — сперва уточни.'],
        ['Всегда не прочь поболтать',
         'Поговори со мной о чём-нибудь!']
    ],
    c: [['Не критикуй меня, я сам(а) запрошу обратную связь, когда мне это будет нужно.',
         'Держи своё мнение при себе! Мне неприятна оценка моих действий, и это правда важно.'],
        ['Узнай, готов(а) ли я выслушать критику',
         'Я хочу обратной связи, но не от всех — сперва уточни.'],
        ['Всегда готов(а) выслушать критику или другое мнение.',
         'Следую правилу Крокера']
    ]
  })

  header: Item {
    height: 50
    Rectangle {
      anchors.fill: parent
      color: palette.alternateBase
    }
    TextField {
      text: api.name
      width: parent.width - 20
      font.pixelSize: 18
      anchors.centerIn: parent
      placeholderText: "Имя"
      inputMethodHints: Qt.ImhNoPredictiveText
      onTextChanged: api.name = text
      onEditingFinished: row.forceActiveFocus()
    }
  }
  MouseArea {
    anchors.fill: parent
    onClicked: parent.forceActiveFocus()
  }
  Text {
    id: description
    x: 10
    y: 20
    width: parent.width - 20
    height: 60
    font.pixelSize: 18
    fontSizeMode: Text.Fit
    wrapMode: Text.Wrap
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    opacity: 0
    visible: opacity > 0
    function show(type, value, flag) {
      text = descr[type][value][flag ? 1 : 0]
      opacity = 1
      descriptionTimer.restart()
    }
    Timer {
      id: descriptionTimer
      running: false
      interval: 5000
      onTriggered: description.opacity = 0
    }
    Behavior on opacity {
      NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }
  }
  Row {
    id: row
    anchors.centerIn: parent
    Repeater {
      id: letters
      model: api.values
      delegate: Column {
        spacing: 50
        id: column
        property string key: model.key
        property string letter: model.letter
        property int value: model.value
        property int circled: model.circled
        property int number: index
        Item {
          height: tumbler.height
          width: parent.width
          Rectangle {
            anchors.left: tumbler.left
            anchors.right: tumbler.right
            anchors.verticalCenter: tumbler.verticalCenter
            color: palette.alternateBase
            height: 40
          }
          Tumbler {
            id: tumbler
            model: 3
            delegate: Item {
              height: 40
              width: parent.width
              Letter {
                size: 24
                letter: column.letter
                anchors.centerIn: parent
                circled: column.circled
                value: index
              }
              opacity: index === tumbler.currentIndex ? 1 : 0.25
            }
            property bool active: false
            onCurrentIndexChanged: {
              if (!active) return
              api.values.setProperty(column.number, "value", currentIndex)
              description.show(column.key, column.value, column.circled)
              forceActiveFocus()
            }
            Component.onCompleted: { currentIndex = column.value; active = true }
          }
        }
        Switch {
          id: circledSwitch
          checked: model.circled
          property bool active: false
          onCheckedChanged: {
            if (!active) return
            api.values.setProperty(index, "circled", checked)
            description.show(model.key, model.value, model.circled)
            forceActiveFocus()
          }
          Component.onCompleted: { active = true }
        }
      }
    }
  }
  footer: Item {
    height: 60
    Rectangle {
      anchors.fill: parent
      color: palette.alternateBase
    }
    Button {
      height: 50
      anchors.centerIn: parent
      text: "Вернуться"
      onClicked: swipeView.currentIndex = 1
    }
  }
}
