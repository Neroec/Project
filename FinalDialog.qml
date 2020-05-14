import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.2

Dialog {
    id: dialogField

    width: 800
    height: 400


    title: "Final"
    visible: false

    property alias text: txt.text

    signal newGame()
    signal quitGame()

    function gameWin(seconds) {
        open()
     }

    contentItem: Rectangle {
        color: "lightgrey"
        implicitWidth: dialogField.width
        implicitHeight: dialogField.height

        Rectangle {
            color: "lightgrey"
            implicitWidth: parent.width
            implicitHeight: parent.height / 4 * 3

            Text {
                id: txt

                text: ""
                color: "black"
                font.family: "Helvetica"
                font.pointSize: 25
                anchors.centerIn: parent
            }
        }

        // Кнопка начала новой игры
        Button {
            id: dialogNewGameButton

            width: parent.width / 2 / 10 * 8
            height: parent.height / 4 / 6 * 4
            y: parent.height - parent.height / 4 + parent.height / 24
            x: parent.width / 2 / 10

            text: "Начать заново"
            onClicked: {
                close()
                newGame()
            }
        }

        // Кнопка выхода в меню
        Button {
            id: dialogQuitGameButton

            width: parent.width / 2 / 10 * 8
            height: parent.height / 4 / 6 * 4
            y: parent.height - parent.height / 4 + parent.height / 24
            x: parent.width / 2 + parent.width / 2 / 10


            text: "Выход в меню"
            onClicked: {
                quitGame()
                close()
            }
        }
    }
}
