#ifndef SESSIONPARAMETERS_H
#define SESSIONPARAMETERS_H

#include <QObject>

#include <KActivities/Controller>


class KWindowSystem;

/* A simple wrapper around Environment's parameters */
class SessionParameters : public QObject
{
    Q_OBJECT
public:

    Q_PROPERTY(QString currentActivity READ currentActivity NOTIFY currentActivityChanged)
    Q_PROPERTY(int currentDesktop READ currentDesktop NOTIFY currentDesktopChanged)
    Q_PROPERTY(int numberOfDesktops READ numberOfDesktops NOTIFY numberOfDesktopsChanged)
    Q_PROPERTY(bool effectsSystemEnabled READ effectsSystemEnabled NOTIFY effectsSystemChanged)

    explicit SessionParameters(QObject *parent = 0);
    ~SessionParameters();

    QString currentActivity();
    int currentDesktop();
    int numberOfDesktops();
    bool effectsSystemEnabled();

signals:
    void currentActivityChanged(QString);
    void currentDesktopChanged(int);
    void numberOfDesktopsChanged(int);
    void effectsSystemChanged(int);

public slots:
    void setCurrentActivitySlot(QString);
    void setCurrentDesktopSlot(int);
    void setNumberOfDesktopsSlot(int);
    void setEffectsSystemEnabledSlot(bool);

private:
    KActivities::Controller *m_controller;
    KWindowSystem *m_kwindowSystem;

    QString m_currentActivity;
    int m_currentDesktop;
    int m_numberOfDesktops;
    bool m_effectsSystemEnabled;

    void initConnections();
};

#endif /* SESSIONPARAMETERS_H */