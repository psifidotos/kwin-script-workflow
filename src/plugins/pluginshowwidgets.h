#ifndef PLUGINSHOWWIDGETS_H
#define PLUGINSHOWWIDGETS_H

#include <KActivities/Controller>

#include <taskmanager/taskmanager.h>

namespace KActivities
{
    class Controller;
}

namespace Plasma {
    class Containment;
    class Corona;
    class PopupApplet;
}

class PluginShowWidgets : public QObject
{
    Q_OBJECT
public:
    explicit PluginShowWidgets(QObject *, Plasma::Containment *, KActivities::Controller *);
    ~PluginShowWidgets();

    void execute(QString);

signals:
    void showWidgetsEnded();
    void hidePopup();

public slots:
    void showWidgetsExplorerFromDelay();
    void currentActivityChanged(QString id);

protected:
    void init();

private:    
    KActivities::Controller *m_activitiesCtrl;
    Plasma::Containment *m_mainContainment;
    Plasma::Corona *m_corona;
    TaskManager::TaskManager *m_taskMainM;


    QString m_toShowActivityId;

    bool m_isOnDashboard;
    bool m_widgetsExplorerAwaitingActivity;

    //This is an indicator for the corona() actions in order to check
    //if widgets are already unlocked.
    QString m_unlockWidgetsText;

    void hideDashboard();
    void showDashboard();
    void unlockWidgets();
    Plasma::Containment *getContainment(QString);
    void showWidgetsExplorer(QString);
    bool isOnDashboard();
    void minimizeWindowsIn(QString,int);
};

#endif
