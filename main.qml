import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12

Window {
    id: w

    visible: true

    width: 1600
    minimumWidth: width
    maximumWidth: width

    height: 900
    minimumHeight: height
    maximumHeight: height

    title: qsTr("Mario!")

    Rectangle {
        width: parent.width
        height: parent.height

        // Главное меню
        Menu {
            id: menu

            x: 0
            y: 0
            width: parent.width
            height: parent.height
            onGameStarted: {
                gameplay.restart()
                parent.state = "gameplay"
            }
        }

        // Сам геймлей
        Gameplay {
            id: gameplay

            width: parent.width
            height: parent.height

            // Когда нажат Escape
            onGameStopped: parent.state = "menu"
            // Когда Марио движется
            onMarioMoved: {
                // Если не начало и конец карты
                if (w.width / 2 - marioWidth / 2 - marioX <= 0 && marioX <= 7000
                 || w.width / 2 - marioWidth / 2 + marioX <= 8606 && marioX >= 7000) {
                    // Сдвигаем систему координат относительно Марио
                    parent.x = w.width / 2 - marioWidth / 2 - marioX
                    // Сдвигаем интерфейс за Марио
                    intefaceX = marioX - parent.width / 2 + marioWidth / 2
                }
            }
            // Когда сбрасываются параметры
            onGameReset: {
                parent.x = 0
            }
        }

        // Состояния игры
        states: [
            // Главное меню
            State {
                name: "menu"
                PropertyChanges {
                    target: menu
                    visible: true
                    focus: true
                }
                PropertyChanges {
                    target: gameplay
                    visible: false
                    marioFocus: false
                }
            },
            // Сам геймплей
            State {
                name: "gameplay"
                PropertyChanges {
                    target: menu
                    visible: false
                }
                PropertyChanges {
                    target: gameplay
                    visible: true
                    marioFocus: true
                }
            }
        ]

        // Начальное состояние
        state: "menu"
    }

}
