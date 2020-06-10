import subprocess
import re

#get last line of log which corresponds to 'Systray selection already managed'
with open('/tmp/i3plasma.log','r') as log:
    lines = log.readlines()
    for line in reversed(lines):
        if(re.search('Systray selection already managed',line)!=None):
            break
        
winpointer = line.split('=')[1].split(')')[0]
#print(winpointer)

winpid = subprocess.run(['xdotool','getwindowpid',winpointer], stderr=subprocess.PIPE)
winpid = winpid.stderr.decode('utf-8').split()[1]
#print(winpid)

subprocess.run(['xkill', '-id', winpid])
