About
=====
This is the kwin script version derived from the WorkFlow project. The project is
trying to enhance every user's unique workflow by combining existing technologies
from Plasma. 

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


The script uses the global shortcut Meta+Ctrl+Z(which you can change if you want)
or you can use the plasmoid WorklFlow KWin Script Launcher to trigger the
kwin script
    
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
plasmoid-workflow >= 0.4.0
KDE >= 4.9
