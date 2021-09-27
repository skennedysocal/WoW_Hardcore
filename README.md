# WoW_Hardcore
World of Warcraft addon for the Hardcore community

## Fix for FPS Lagging problem

Its September 2021 and there has been a surge in popularity for Hardcore mode WoW.

Players on EU Alliance (Hydraxian) who have the Add-On installed are finding the game is becoming very jerky after 10 minutes play.

Doing a `/reload` temporarily fixes the problem, but a lot of players are now disabling the add-on completely due to the performance problems.

I have identified that it is the code that synchronizes the history of deaths between guild members that is causing the performance problems.

Disabling this functionality results in normal performance. 

Note, all the core functionality of the add-on remains (Death notifications, Level timings/screenshots, blocking trades/mailbox).

The only thing you will miss out on, is deaths that happened while you were not logged in.

## TL;DR

If you just want a fixed version of the add-on, you can download it from https://github.com/spenceclark/WoW_Hardcore/archive/refs/tags/0.3.0-fix.zip 

Extract the files and copy them into your `<wherever wow is installed>\_classic_era_\Interface\AddOns\Hardcore\` folder, overwriting the existing files.

## Explanation

Whenever a guild member logs into the game, their Add-On sends a message to every online guild member, asking them to send their "Deaths" data. This is the data file containing the history of every single Hardcore death on the server. (This is the table of data shown on the first page of the add-on)

Each guild member responds by sending their data.

Currently on Alliance EU - the Deaths data is over 12,000 rows (this does seem very high, its likely there is a bug causing duplication here), and we often have over 90 guild members online, and people constantly logging in and out.

This results in a huge amount of data being passed around. And the problem will keep getting worse the more deaths and the more guild members are online. 

As passing all this data at once would cause you to get disconnected, the add-on buffers it up and sends it slowly so as not to cause disconnects.

The problem is that, with the amount of data, and the frequency of logins, this data keeps buffering before its fully sent, and memory usage starts to creep up. This causes the performance problems people are experiencing.
