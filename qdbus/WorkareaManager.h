#ifndef WORKAREAMANAGER_H
#define WORKAREAMANAGER_H

#include <QObject>
#include <QHash>
#include <QDBusContext>

#include <KDEDModule>
#include <KActivities/Controller>

class UpdateWorkareasName;
class SyncActivitiesWorkareas;
class FindWallpaper;

class KActionCollection;

class WorkareaInfo;

class WorkareaManager : public QObject
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "org.opentoolsandspace.WorkareaManager")

public:
    explicit WorkareaManager(QObject* parent = 0);
    ~WorkareaManager();

    void initBackgrounds();

public Q_SLOTS:
    Q_SCRIPTABLE void SetCurrentNextActivity();
    Q_SCRIPTABLE void SetCurrentPreviousActivity();

    Q_SCRIPTABLE void AddWorkarea(QString id, QString name);
    Q_SCRIPTABLE void RemoveWorkarea(QString id, int desktop);
    Q_SCRIPTABLE void RenameWorkarea(QString id, int desktop, QString name);
    //Only for the values contained in the workareas models
    Q_SCRIPTABLE void CloneActivity(QString, QString);
    Q_SCRIPTABLE void MoveActivity(QString, int);

    Q_SCRIPTABLE int MaxWorkareas() const;
    Q_SCRIPTABLE QStringList Activities() const;
    Q_SCRIPTABLE QString ActivityBackground(QString actId);
    Q_SCRIPTABLE QStringList Workareas(QString actId);
    Q_SCRIPTABLE bool ServiceStatus();

Q_SIGNALS:
    void ActivityAdded(QString id);
    void ActivityRemoved(QString id);

    void WorkareaAdded(QString id, QStringList workareas);
    void WorkareaRemoved(QString id, QStringList workareas);
    void ActivityInfoUpdated(QString id, QString background, QStringList workareas);

    void ActivityOrdersChanged(QStringList activities);

    void MaxWorkareasChanged(int);
    void ServiceStatusChanged(bool);

private slots:
    void setBackground(QString, QString);
    void activityAddedSlot(QString);
    void activityRemovedSlot(QString);

    void workareaAddedSlot(QString id, QString name);
    void workareaRemovedSlot(QString id, int position);
    void workareaInfoUpdatedSlot(QString id);

    void updateWorkareasNameSlot(int);

    //init thread
    void handleActivityReply();

protected:
    void initSignals();
    void initSession();

private:
    QList <WorkareaInfo *> m_workareasList;

    KActivities::Controller *m_activitiesController;
    KActionCollection *actionCollection;

    bool m_loading;
    int m_maxWorkareas;
    int m_nextDefaultWallpaper;
    QString m_service;
    bool m_isRunning;

    /*Mechanisms from the relevant classes*/
    UpdateWorkareasName *m_mcmUpdateWorkareasName;
    SyncActivitiesWorkareas *m_mcmSyncActivitiesWorkareas;
    FindWallpaper *m_mcmFindWallpaper;

    ///Workareas Storing/Accessing
    void loadWorkareas();
    void saveWorkareas();
    void setMaxWorkareas();

    QString getNextDefWallpaper();
    QString nextRunningActivity();
    QString previousRunningActivity();

    int findActivity(QString activityId);
    WorkareaInfo *get(QString);
    void createActivityChangedSignal(QString actId);
    //init thread
    void updateActivityList();
};

#endif // WORKAREAMANAGER_H
