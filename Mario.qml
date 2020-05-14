import QtQuick 2.0

Item {
    id: mario

    width: 98
    height: 118

    x: 0
    y: 0
    z: 1
    focus: true

    // Скорость Марио
    property int xVelocity: 0
    property int yVelocity: 0

    // Спрайт Марио
    property var status: "StopRight"

    // Величина изменения скорости горизонтального движения
    property int speed: 5

    // Величина изменения скорости падения
    property int gravitation: 1

    // Состояние и частота движения Марио
    property alias timerRunning: timer.running
    property int tick: 5

    signal jump()
    signal moved()
    signal using()
    signal pause()

    // Меняет спрайт Марио
    function changeStatus() {
        r.jumpTo(status)
    }

    // Отслеживаем нажатие клавиш
    Keys.onPressed: {
        if (event.isAutoRepeat) {
            return;
        }

        switch (event.key) {
        case Qt.Key_Left:
            xVelocity -= speed
            break;
        case Qt.Key_Right:
            xVelocity += speed
            break;
        case Qt.Key_Up:
            using()
            break;
        case Qt.Key_Escape:
            pause()
            if (timer.running) timer.stop()
            else timer.start()
            break;
        case Qt.Key_Space:
            jump()
        }
    }

    // Отслеживаем отпускание клавиш
    Keys.onReleased: {
        if (event.isAutoRepeat) {
            return;
        }
        switch (event.key) {
        case Qt.Key_Left:
            xVelocity += speed
            break;
        case Qt.Key_Right:
            xVelocity -= speed
            break;
        }
    }

    // Движение Марио
    Timer {
        id: timer

        interval: tick
        triggeredOnStart: true
        running: true
        repeat: true
        onTriggered: moved()
    }

    // Спрайты Марио
    SpriteSequence {
        id: r
        width: parent.width
        height: parent.height
        interpolate: true

        Sprite {
            name: "StopRight"; source: "Images/Mario.png"; frameCount: 1
            frameWidth: 36; frameHeight: 60; frameX: 1; frameY: 1
        }
        Sprite {
            name: "MoveRight"; source: "Images/Mario.png"; frameCount: 1
            frameWidth: 43; frameHeight: 56; frameX: 1; frameY: 62
        }
        Sprite {
            name: "StopLeft"; source: "Images/Mario.png"; frameCount: 1
            frameWidth: 36; frameHeight: 60; frameX: 38; frameY: 1
        }
        Sprite {
            name: "MoveLeft"; source: "Images/Mario.png"; frameCount: 1
            frameWidth: 43; frameHeight: 56; frameX: 45; frameY: 62
        }
    }
}
