About
=====
This is the kwin script version derived from the WorkFlow project. The project is
trying to enhance every user's unique workflow by combining existing technologies
from Plasma. 


Differences To Default KDE workflow
===================================
-  Workareas use Virtual Desktops, in order to be consistent between them,
   Virtual Desktops are always that big as the maximum Workareas present from
   Activities.
   NOTICE: You can not add a Virtual Desktop when Workareas are running. You
   can add the Workarea needed and Virtual Desktops will be updated.

Installation
============
    cd package
    plasmapkg --type kwinscript -i .

Important Notice - How to enable the script
---------
You should make a relogin in order for the script to appear
in System Settings -> Window Behavior -> KWin Scripts
then you check it and apply the changes.
You should make a relogin one more time in order for the script
to be activated in plasma.

Script uses TopLeft Corner to be activated or
global shortcut Meta+Ctrl+Z(which you can change if you want)
    
Update
=========
    cd package
    plasmapkg --type kwinscript -u .    
    
Uninstall
=========
    cd package
    plasmapkg --type kwinscript -r .
    
Requirements  
------------
plasmoid-workflow >= 0.3.0
KDE >= 4.9
