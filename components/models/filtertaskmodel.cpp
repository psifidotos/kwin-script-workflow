#include "filtertaskmodel.h"

#include <QDebug>
#include <QSortFilterProxyModel>

#include "listmodel.h"
#include "taskitem.h"

FilterTaskModel::FilterTaskModel(QObject *parent):
    QSortFilterProxyModel(parent),
    m_activity(""),
    m_desktop(0),
    m_everywhereState(false)
{
}

bool FilterTaskModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);

    QStringList activities = sourceModel()->data(index, TaskItem::ActivitiesRole).toStringList();
    int desktop = sourceModel()->data(index, TaskItem::DesktopRole).toInt();
    bool onAllActivities = sourceModel()->data(index, TaskItem::OnAllActivitiesRole).toBool();
    bool onAllDesktops = sourceModel()->data(index, TaskItem::OnAllDesktopsRole).toBool();

    bool result = ( ((activities.size() != 0) && (activities[0] == m_activity)&&
                     ((desktop == m_desktop) || onAllDesktops) ) ||
                   ((desktop == m_desktop) && onAllActivities) ||
                   ((m_everywhereState) && onAllActivities && onAllDesktops)
                   );

    return result;
}

void FilterTaskModel::setSourceTaskModel(QObject *model)
{
    ListModel *listModel = static_cast<ListModel *>(model);
    if(listModel != sourceModel()){
        setSourceModel(listModel);

        emit sourceTaskModelChanged(listModel);
    }

}

void FilterTaskModel::setActivity(QString activity)
{
    if(m_activity != activity){
        m_activity = activity;
        emit activityChanged(activity);
        invalidate();
    }
}


void FilterTaskModel::setDesktop(int desktop)
{
    if(m_desktop != desktop){
        m_desktop = desktop;
        emit desktopChanged(m_desktop);
        invalidate();
    }

}


void FilterTaskModel::setEverywhereState(bool state)
{
    if(m_everywhereState != state){
        m_everywhereState = state;
        emit everywhereStateChanged(state);
        invalidate();
    }
}

int FilterTaskModel::getCount()
{
    return rowCount();
}

#include "filtertaskmodel.moc"