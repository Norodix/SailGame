#remove old export archives
rm SailGame_*.zip

#zip exe
zip -r SailGame_win.zip SailGame_win/* 
zip -r SailGame_linux.zip SailGame_linux/* 
zip -r SailGame_android.zip SailGame_android/*

#create secondary index.html for itch
cp SailGame_html/Sail.html SailGame_html/index.html
zip -r SailGame_html.zip SailGame_html/*

#Upload webgl version and exe
rsync -aP -e 'ssh -p 5566' ./SailGame_html ./SailGame_win.zip ./SailGame_linux.zip ./SailGame_android/SailGame.apk norodix@norodixserver.duckdns.org:/home/norodix/SailGame

