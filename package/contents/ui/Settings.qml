import QtQuick 1.1
import "../code/settings.js" as Settings

QtObject {
    property bool lockActivities: readConfig("LockActivities", true)
    property bool showWindows: readConfig("ShowWindows", true)
    property int scale: readConfig("Scale", 50)
    property int animations: readConfig("Animations", 2);
    property int animationSpeed: readConfig("AnimationSpeed", 200)
    property int animationStep: animations >= 1 ? animationSpeed:0
    property int animationStep2: animations >= 2 ? animationSpeed:0
    property bool windowPreviews: readConfig("WindowPreviews", true)
    property int windowPreviewsOffsetX: readConfig("WindowPreviewsOffsetX", 0)
    property int windowPreviewsOffsetY: readConfig("WindowPreviewsOffsetY", 0)
    property int fontRelevance: readConfig("FontRelevance", 0)
    property bool showStoppedPanel: readConfig("ShowStoppedPanel", true)
    property bool firstRunTour: readConfig("FirstRunTour", false)
    property bool firstRunCalibration: readConfig("FirstRunCalibration", false)
    property bool hideOnClick: readConfig("HideOnClick", false)
    property bool useCurrentActivityIcon: readConfig("UseCurrentActivityIcon", false)
    property bool disableEverywherePanel: readConfig("DisableEverywherePanel", false)
    property bool disableBackground: readConfig("DisableBackground", true)


    // Small hack to make sure the global settings object is set
    property bool setAsGlobal: false
    onSetAsGlobalChanged: {
        if (setAsGlobal) 
            Settings.global = settings
    }
    
 /*   onLockActivitiesChanged: { writeConfig("LockActivities", lockActivities); }
    onShowWindowsChanged: { writeConfig("ShowWindows", showWindows) ; }
    onScaleChanged: { writeConfig("Scale", scale) ; }
    onAnimationsChanged: { writeConfig("Animations", animations) ; }
    onAnimationSpeedChanged: { writeConfig("AnimationSpeed", animationSpeed) ; }
    onWindowPreviewsChanged: { writeConfig("WindowPreviews", windowPreviews) ; }
    onWindowPreviewsOffsetXChanged: { writeConfig("WindowPreviewsOffsetX", windowPreviewsOffsetX) ; }
    onWindowPreviewsOffsetYChanged: { writeConfig("WindowPreviewsOffsetY", windowPreviewsOffsetY) ; }
    onFontRelevanceChanged: { writeConfig("FontRelevance", fontRelevance) ; }
    onShowStoppedPanelChanged: { writeConfig("ShowStoppedPanel", showStoppedPanel) ; }
    onFirstRunTourChanged: { writeConfig("FirstRunTour", firstRunTour) ; }
    onFirstRunCalibrationChanged: { writeConfig("FirstRunCalibration", firstRunCalibration) ; }
    onHideOnClickChanged: { writeConfig("HideOnClick", hideOnClick) ; }
    onUseCurrentActivityIconChanged: { writeConfig("UseCurrentActivityIcon", useCurrentActivityIcon) ; }
    onDisableEverywherePanelChanged: { writeConfig("DisableEverywherePanel", disableEverywherePanel) ; }
    onDisableBackgroundChanged: { writeConfig("DisableBackground", disableBackground) ; }
   */

    function configChanged() {
        hideOnClick = readConfig("HideOnClick", false);
        animations = readConfig("Animations", 1);
        useCurrentActivityIcon = readConfig("UseCurrentActivityIcon", false);
        disableEverywherePanel = readConfig("DisableEverywherePanel", false);
        disableBackground = readConfig("DisableBackground", false);
    }

    Component.onCompleted: {
/*        console.log("lockActivities: " + lockActivities)
        console.log("showWindows: " + showWindows)
        console.log("scale: " + scale)
        console.log("animations: " + animations)
        console.log("animationSpeed: " + animationSpeed)
        console.log("windowPreviews: " + windowPreviews)
        console.log("windowPreviewsOffsetX: " + windowPreviewsOffsetX)
        console.log("windowPreviewsOffsetY: " + windowPreviewsOffsetY)
        console.log("fontRelevance: " + fontRelevance)
        console.log("showStoppedPanel: " + showStoppedPanel)
        console.log("firstRunTour: " + firstRunTour)
        console.log("firstRunCalibration: " + firstRunCalibration)
        console.log("hideOnClick: " + hideOnClick)
        console.log("currentTheme: " + currentTheme)
        console.log("toolTipsDelay: " + toolTipsDelay)
      //  console.log("Theme size: " + theme.iconSizes.dialog)
        console.log("useCurrentActivityIcon: " + useCurrentActivityIcon)
        console.log("disableEverywherePanel: " + disableEverywherePanel)*/
    }
}
