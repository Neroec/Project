#ifndef GAMEMANAGER_H
#define GAMEMANAGER_H

#include <QObject>

class GameManager : public QObject
{
Q_OBJECT

public:
    explicit GameManager(QObject *parent = nullptr);

signals:
    void marioGeometry();

public slots:
    QString marioStatus(int xVelocity, int yVelocity, QString oldStatus);
    QVector<int> objectsCollision(int marioWidth, int marioHeight, int marioX, int marioY, int marioXVelocity, int marioYVelocity, QVector<int> objects);
    QVector<int> coinsCollision(int marioWidth, int marioHeight, int marioX, int marioY, QVector<int> objects);
    QVector<int> objectsStorage(int stage);

private slots:
    bool yCollision(int marioHeight, int marioY, int objectHeight, int objectY);
    bool xCollision(int marioWidth, int marioX, int objectWidth, int objectX);
};

#endif // GAMEMANAGER_H
