#ifndef ACTIVITYMANAGER_H
#define ACTIVITYMANAGER_H

#include <QObject>

#include <KStandardDirs>
#include <KActivities/Controller>
#include <KConfigGroup>

#include <QTimer>

class WorkFlow;

class PluginShowWidgets;
class PluginCloneActivity;
class PluginRemoveActivity;
class PluginChangeWorkarea;

namespace KActivities
{
class Controller;
class Info;
}

namespace Plasma {
class Containment;
class Corona;
}

class ActivityManager : public QObject
{
    Q_OBJECT
public:
    explicit ActivityManager(QObject *parent = 0);
    ~ActivityManager();

    //  Q_INVOKABLE void createActivityFromScript(const QString &script, const QString &name, const QString &icon, const QStringList &startupApps);
    //  Q_INVOKABLE void downloadActivityScripts();

    Q_INVOKABLE QString getWallpaper(QString source);
    Q_INVOKABLE QPixmap disabledPixmapForIcon(const QString &ic);
    Q_INVOKABLE QString add(QString name);

    Q_INVOKABLE void setCurrent(QString id);
    Q_INVOKABLE void stop(QString id);
    Q_INVOKABLE void start(QString id);
    Q_INVOKABLE void setName(QString id, QString name);
    Q_INVOKABLE void remove(QString id);
    Q_INVOKABLE QString chooseIcon(QString);
    Q_INVOKABLE void setIcon(QString id, QString name);

    //    Q_INVOKABLE int askForDelete(QString activityName);

    Q_INVOKABLE void showWidgetsExplorer(QString);
    Q_INVOKABLE void cloneActivity(QString);



    void setQMlObject(QObject *,Plasma::Corona *, WorkFlow *);
    void setCurrentNextActivity();
    void setCurrentPreviousActivity();

signals:
    void activityAddedIn(QVariant id, QVariant title, QVariant icon, QVariant stat, QVariant cur);
    void activityUpdatedIn(QVariant id, QVariant title, QVariant icon, QVariant stat, QVariant cur);
    void showedIconDialog();
    void answeredIconDialog();
    void hidePopup();
    void currentActivityInformationChanged(QString name, QString icon);

public slots:
    void activityAdded(QString id);
    void activityRemoved(QString id);
    void activityDataChanged();
    void activityStateChanged();
    void currentActivityChanged(const QString &);

    void updateWallpaper(QString);

    void showWidgetsEndedSlot();

    void cloningStartedSlot();
    void cloningEndedSlot();
    void copyWorkareasSlot(QString,QString);

    void activityRemovedEnded(QString);

    void changeWorkareaEnded(QString, int);

    Q_INVOKABLE void setCurrentActivityAndDesktop(QString, int);

private:

    WorkFlow *m_plasmoid;
    Plasma::Corona *m_corona;
    KActivities::Controller *m_activitiesCtrl;
    QObject *qmlActEngine;

    QString activityForDelete;

    PluginShowWidgets *m_plShowWidgets;
    PluginCloneActivity *m_plCloneActivity;
    PluginRemoveActivity *m_plRemoveActivity;
    PluginChangeWorkarea *m_plChangeWorkarea;

    Plasma::Containment *getContainment(QString actId);

    bool m_firstTime;

};

#endif // ACTIVITYMANAGER_H
