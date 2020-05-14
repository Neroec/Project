import QtQuick 2.0
import QtQuick.Layouts 1.12

Rectangle {
    id: gameplay

    // Параметры Марио
    property alias marioFocus: mario.focus
    property alias marioX: mario.x
    property alias marioWidth: mario.width
    property int marioJumpPower: 30

    // X интерфейса
    property alias intefaceX: inteface.x

    // Прошедшее время
    property var time: 0

    // Количество всех и оставшихся монеток
    property var coinsMax: 1
    property var coinsCount: 1

    // Массивы координат и размеров игровых объектов
    property var objects: []
    property var coins: []

    signal gameStopped()
    signal gameReset()
    signal marioMoved()

    // Сбрасывает всё до исходного состояния
    function restart() {
        mario.yVelocity = 0
        mario.x = parent.width / 2 - mario.width / 2
        mario.y = parent.height - mario.height - 64
        inteface.x = 0
        pauseMenu.visible = false
        time = 0
        timer.running = true
        mario.timerRunning = true
        background1.x = 0
        background2.x = background1.width

        gameplay.coins = gameManager.objectsStorage(2);
        gameplay.coinsCount = gameplay.coinsMax = coins.model = gameplay.coins[0]
        for (var i = 0, j = 3; i < gameplay.coinsMax; i++) {
            coins.itemAt(i).x = gameplay.coins[j]
            coins.itemAt(i).y = gameplay.coins[j+1];
            j += 2;
        }

        gameReset()
    }

    // Обеспечивает движение фона
    function checkBack() {
        if (inteface.x - background1.x >= inteface.width)
            background1.x = background2.x + background2.width
        else if (background1.x - inteface.x >= inteface.width)
            background1.x = background2.x - background2.width
        else if (inteface.x - background2.x >= inteface.width)
            background2.x = background1.x + background1.width
        else if (background2.x - inteface.x >= inteface.width)
            background2.x = background1.x - background1.width
    }

    // Интерфейс для привязки объектов
    Rectangle {
        id: inteface

        x: 0
        y: 0
        z: 2
        color: "black"
        opacity: 0.77

        width: parent.width
        height: parent.height

        visible: false
    }

    // Первый фон
    Image {
        id: background1

        x: 0
        width: parent.width
        height: parent.height

        source: "Images/GameBackground1.png"
    }

    // Второй фон
    Image {
        id: background2

        x: background1.width
        width: parent.width
        height: parent.height

        source: "Images/GameBackground2.png"
    }

    // Труба
    Image {
        id: pipe

        x: 20
        y: inteface.height - height - 64

        source: "Images/Pipe.png"
    }

    // Замок в конце
    Image {
        id: castle

        width: 600
        height: 600
        x: 8600 - width
        y: parent.height - height - 64

        source: "Images/Castle.png"
    }

    // Знак
    Image {
        id: sign

        width: 120
        height: 150
        x: 4420
        y: 708 - height

        source: "Images/Sign.png"
    }

    // Стрелка вверх
    Image {
        id: upArrow

        width: 80
        height: 80
        x: castle.x + castle.width / 2 - width / 2 - 12
        y: castle.y  + castle.height - mario.height - height - 20
        visible: false

        source: "Images/UpArrow.png"
    }

    // Марио
    Mario {
        id: mario
        x: parent.width / 2 - width / 2
        y: parent.height - height - 64
        gravitation: 1
        tick: 5

        // Когда нажали space
        onJump: {
            if (yVelocity == 0 || yVelocity == gravitation) {
                yVelocity = -parent.marioJumpPower
            }
        }
        // Когда пытаемся что-то использовать (только финал)
        onUsing: {
            if (mario.x < castle.x + castle.width / 2
             && mario.x + mario.width > castle.x + castle.width / 2) {
                timer.running = false
                mario.xVelocity = 0
                finalBoard.text = "Поздравляем!!!\n" +
                "Игра пройдена на " + (Math.floor((gameplay.coinsMax - gameplay.coinsCount) / gameplay.coinsMax * 100)) + "%\n" +
                "Это заняло секунд: " + gameplay.time + "\n" +
                "Монеток собрано: " + (gameplay.coinsMax - gameplay.coinsCount) + " из " + gameplay.coinsMax
                finalBoard.gameWin(gameplay.time)
            }
        }
        // Когда нажали Escape
        onPause: {
            timer.running = timer.running ? false : true
            pauseMenu.visible = pauseMenu.visible ? false : true
        }
        // Когда Марио двинулся
        onMoved: {
            var newX = x + xVelocity
            var newY = y + yVelocity
            var collis
            // Проверяем коллизию с объектами
            collis = gameManager.objectsCollision(width, height, newX, newY, xVelocity, yVelocity, gameplay.objects)

            // Изменяем координаты и скорость
            x = collis[0]
            y = collis[1]
            yVelocity = collis[2];

            // Поворачиваем монетки
            for (var i = 0, j = 3; i < gameplay.coinsCount; i++) {
                coins.itemAt(i).angle += 5
                j += 2;
            }
            coinsBoardImageRotation.angle += 5

            // Проверяем коллизию с монетками
            if (coinsCount) {
                var countOld = gameplay.coins[0]
                gameplay.coins = gameManager.coinsCollision(width, height, x, y, gameplay.coins)
                var countNew = gameplay.coins[0]

                // Если коллизия произошла
                if (countOld !== countNew) {
                    gameplay.coinsCount -= (countOld - countNew)
                    coins.model = gameplay.coinsCount
                    // Задаём координаты монеток
                    for (i = 0, j = 3; i < gameplay.coinsCount; i++) {
                        coins.itemAt(i).x = gameplay.coins[j]
                        coins.itemAt(i).y = gameplay.coins[j+1];
                        j += 2;
                    }
                }
            }

            // Проверяем положение для финала
            if (mario.x < castle.x + castle.width / 2
             && mario.x + mario.width > castle.x + castle.width / 2) upArrow.visible = true
            else upArrow.visible = false

            // Изменяем спрайт(статус) Марио
            status = gameManager.marioStatus(xVelocity, yVelocity, status)
            changeStatus()

            // Проверяем положение фона
            checkBack()


            // Увеличиваем скорость падения, если нет коллизии снизу
            if (collis[3] !== 1) {
                yVelocity += gravitation
            }

            // Если упали в яму
            if (y > gameplay.height * 2) gameplay.restart()

            // Марио двинулся
            marioMoved()
        }
    }

    // Меню паузы
    PauseMenu {
        id: pauseMenu

        x: inteface.x
        y: inteface.y
        width: inteface.width
        height: inteface.height

        // Перезапуск игры
        onGameRestart: {
            gameplay.restart()
        }
        // Выход в меню
        onReturnMenu: {
            gameplay.restart()
            mario.timerRunning = false
            timer.running = false
            gameplay.gameStopped()
        }


        visible: false
    }

    // Игровые объекты
    Repeater {
        id: stages

        model: 0

        GroundBrick {

        }
    }

    // Монетки
    Repeater {
        id: coins

        model: 1

        Rectangle {
            id: coin

            property alias angle: rotation.angle

            Image {
                width: 80
                height: 80

                anchors.centerIn: parent
                source: "Images/Coin.png";
            }

            // Поворот монетки
            transform: Rotation {
                id: rotation

                origin.x: 0
                origin.y: 0
                axis.x: 0; axis.y: 1; axis.z: 0
                angle: 0
            }
        }
    }

    // Окно собранных монеток
    Rectangle {
        id: coinsBoard

        width: parent.width / 8
        height: parent.height / 10
        z: 1
        radius: 10
        gradient: Gradient {
            GradientStop { position: 0; color: "lightyellow" }
            GradientStop { position: 0.33; color: "lightgoldenrodyellow" }
            GradientStop { position: 0.66; color: "lemonchiffon" }
        }

        border.color: "black"
        border.width: 5

        anchors.top: inteface.top
        anchors.topMargin: 7
        anchors.right: inteface.right
        anchors.rightMargin: 7

        Text {
            color: "black"

            text: "Coins: " + (gameplay.coinsMax - gameplay.coinsCount) + " / " + gameplay.coinsMax
            font.pointSize: 18
            font.bold: true
            font.family: "Times New Roman"
            z: 1
            anchors.centerIn: parent
        }

        // Изображение монетки
        Image {
            id: coinsBoardImage

            height: parent.height - 10
            width: height
            source: "Images/Coin.png"

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.left
            anchors.rightMargin: 7

            // Поворот монетки
            transform: Rotation {
                id: coinsBoardImageRotation

                origin.x: coinsBoardImage.width / 2
                origin.y: coinsBoardImage.height / 2
                axis.x: 0; axis.y: 1; axis.z: 0
                angle: 0
            }
        }
    }

   // Таймер
    Rectangle {
        id: timerBoard

        width: parent.width / 8
        height: parent.height / 10
        z: 1
        radius: 10
        gradient: Gradient {
            GradientStop { position: 0; color: "lightyellow" }
            GradientStop { position: 0.33; color: "lightgoldenrodyellow" }
            GradientStop { position: 0.66; color: "lemonchiffon" }
        }

        border.color: "black"
        border.width: 5

        anchors.top: inteface.top
        anchors.topMargin: 7
        anchors.left: inteface.left
        anchors.leftMargin: 7

        Text {
            color: "black"

            text: "Times: " + gameplay.time
            font.pointSize: 18
            font.bold: true
            font.family: "Times New Roman"
            z: 1
            anchors.centerIn: parent
        }

        Timer {
            id: timer

            interval: 1000
            triggeredOnStart: true
            running: true
            repeat: true
            onTriggered: gameplay.time++
        }
    }

   // Финальное окно
    FinalDialog {
        id: finalBoard

        // Перезапуск игры
        onNewGame: gameplay.restart()
        // Выход в меню
        onQuitGame: {
            gameplay.restart()
            mario.timerRunning = false
            timer.running = false
            gameplay.gameStopped()
        }
        // Когда закрыто
        /*???: {
            gameplay.restart()
            mario.timerRunning = false
            timer.running = false
            gameplay.gameStopped()
        }*/
    }

    // Начальные настройки
    Component.onCompleted: {
        // Получаем масссив объектов
        gameplay.objects = gameManager.objectsStorage(1);
        // Устанавливаем количество объектов
        stages.model = gameplay.objects[0];

        // Задаём координаты объектов
        for (var i = 0, j = 3; i < stages.model; i++) {
            stages.itemAt(i).x = gameplay.objects[j];
            stages.itemAt(i).y = gameplay.objects[j+1];
            j += 2;
        }

        // Получаем масссив монеток
        gameplay.coins = gameManager.objectsStorage(2);
        // Устанавливаем количество монеток
        gameplay.coinsCount = gameplay.coinsMax = coins.model = gameplay.coins[0]

        // Задаём координаты монеток
        for (i = 0, j = 3; i < gameplay.coinsMax; i++) {
            coins.itemAt(i).x = gameplay.coins[j]
            coins.itemAt(i).y = gameplay.coins[j+1];
            j += 2;
        }

        // Проверяем положение фона
        checkBack()
    }
}
