import QtQuick 2.0
import QtQuick.Layouts 1.0

Rectangle {
    id: pauseMenu

    z: 2
    color: "black"
    opacity: 0.77

    // Делители размера кнопок
    property int buttonsWidthSize: 5
    property int buttonsHeightSize: 12

    signal gameRestart()
    signal returnMenu()

    // Список кнопок
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 5

        // Кнопка начала новой игры
        Button {
            Layout.preferredWidth: pauseMenu.width / pauseMenu.buttonsWidthSize
            Layout.preferredHeight: pauseMenu.height / pauseMenu.buttonsHeightSize
            text: "Начать заново"
            onClicked: pauseMenu.gameRestart()
        }

        // Кнопка выхода в главное меню
        Button {
            Layout.preferredWidth: pauseMenu.width / pauseMenu.buttonsWidthSize
            Layout.preferredHeight: pauseMenu.height / pauseMenu.buttonsHeightSize
            text: "Выход в меню"
            onClicked: pauseMenu.returnMenu()
        }

        // Кнопка выхода из игры
        Button {
            Layout.preferredWidth: pauseMenu.width / pauseMenu.buttonsWidthSize
            Layout.preferredHeight: pauseMenu.height / pauseMenu.buttonsHeightSize
            text: "Выход из игры"
            onClicked: Qt.quit()
        }
    }
}
