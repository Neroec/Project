import QtQuick 2.0
import QtQuick.Layouts 1.0

Rectangle {
    id: menu

    // Делители размера кнопок
    property int buttonsWidthSize: 7
    property int buttonsHeightSize: 12

    signal gameStarted()

    // Фон меню
    Image {
        id: background

        source: "Images/MenuBackground.jpg"
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
    }

    // Список кнопок
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 5

        // Кнопка начала новой игры
        Button {
            Layout.preferredWidth: menu.width / menu.buttonsWidthSize
            Layout.preferredHeight: menu.height / menu.buttonsHeightSize
            text: "Начать игру"
            onClicked: menu.gameStarted()
        }

        // Кнопка выхода игры
        Button {
            Layout.preferredWidth: menu.width / menu.buttonsWidthSize
            Layout.preferredHeight: menu.height / menu.buttonsHeightSize
            text: "Выход"
            onClicked: {
                Qt.quit()
            }
        }
    }
}
