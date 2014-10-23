# This convenience script uploads the build Salt Windows Installers and then
# clears out the minion's upload directory.

# Be sure to change 'Win64Builder' and 'Win32Builder' to your actual minion
# names and change 'xxx.xxx.xxx.xxx' and the rest of the path to reflect where
# the final exe should be.

scp /var/cache/salt/master/minions/Win64Builder/files/c:/repos/salt/pkg/windows/installer/* root@xxx.xxx.xxx.xxx:/srv/salt/saltstack.com/downloads/

scp /var/cache/salt/master/minions/Win32Builder/files/c:/repos/salt/pkg/windows/installer/* root@xxx.xxx.xxx.xxx:/srv/salt/saltstack.com/downloads/

rm -fr /var/cache/salt/master/minions/Win64Builder/files/*
rm -fr /var/cache/salt/master/minions/Win32Builder/files/*
