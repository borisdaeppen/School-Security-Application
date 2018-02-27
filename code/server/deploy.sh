# connection parameters
server='192.168.220.12'
user='root'

# deploy updated files
rsync -tv  bin/fulla $user@$server:/usr/bin
rsync -tvr lib/*     $user@$server:/usr/share/perl5

# ensure correct permissions
ssh $user@$server 'chmod    755 /usr/bin/fulla;\
                   chmod -R 644 /usr/share/perl5/Fulla;\
                   chmod -R 644 /usr/share/perl5/HTML;\
                   chmod -R u=rwX,go=rX /usr/share/perl5/Fulla;\
                   chmod -R u=rwX,go=rX /usr/share/perl5/HTML'

# restart application
ssh $user@$server 'pkill -F /tmp/fulla.pid; /usr/bin/fulla'
