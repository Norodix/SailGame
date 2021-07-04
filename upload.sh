#zip exe
zip -r WinExport.zip WinExport
zip -r LinuxExport.zip LinuxExport

#Upload webgl version and exe
rsync -aP -e 'ssh -p 5566' ./Export ./WinExport.zip ./LinuxExport.zip ./androidExport/SailGame.apk norodix@norodixserver.duckdns.org:/home/norodix/SailGame

