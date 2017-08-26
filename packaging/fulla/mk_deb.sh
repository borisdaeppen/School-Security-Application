#!/bin/sh

# needs package dpkg-dev

echo 'START PACKAGE BUILDING'

# remove old packages
rm fulla*.deb 2> /dev/null

# remove old code
if [ -e debian/usr ]; then
    rm -rf debian/usr
fi

# copy program files from devel-source
if [ ! -e debian/usr/bin ]; then
    mkdir -p debian/usr/bin
fi
cp ../../code/server/bin/fulla debian/usr/bin/fulla

if [ ! -e debian/usr/share/perl5 ]; then
    mkdir -p debian/usr/share/perl5
fi
cp -r ../../code/server/lib/* debian/usr/share/perl5/

#if [ ! -e debian/etc ]; then
#    mkdir -p debian/etc
#fi
#cp ../../code/webseite/hallo.txt debian/etc/loroweb.conf
#
#if [ ! -e debian/usr/share/loroweb ]; then
#    mkdir -p debian/usr/share/loroweb
#fi
## /usr/lib seems to be only for code, not images...
#cp ../../code/webseite/public/logo.jpg debian/usr/share/loroweb/logo.jpg

# put SQL-code to system for later use in POSTINST script
if [ ! -e debian/usr/share/fulla ]; then
    mkdir -p debian/usr/share/fulla
fi
cp ../../code/server/sql/db.sql debian/usr/share/fulla

# pack manpage
if [ ! -e debian/usr/share/man/man1 ]; then
    mkdir -p debian/usr/share/man/man1
fi
cp fulla.1 debian/usr/share/man/man1/
gzip -n --best debian/usr/share/man/man1/*.1

# pack changelog and copyright
if [ ! -e debian/usr/share/doc/fulla ]; then
    mkdir -p debian/usr/share/doc/fulla
fi
cp changelog        debian/usr/share/doc/fulla/
cp changelog.Debian debian/usr/share/doc/fulla/
gzip -n --best debian/usr/share/doc/fulla/changelog
gzip -n --best debian/usr/share/doc/fulla/changelog.Debian
cp copyright debian/usr/share/doc/fulla/

# update md5sums file of dep-tree
echo -e "\tupdate md5sums file"
if [ ! -e debian/DEBIAN ]; then
    mkdir debian/DEBIAN
fi
if [ -e debian/DEBIAN/md5sums ]; then
    rm debian/DEBIAN/md5sums
fi
for i in $( find ./debian -path ./debian/DEBIAN -prune -o -type f -print)
do
    md5sum $i | sed -e "s/\.\/debian\///g" >> debian/DEBIAN/md5sums
done

# renew the size information
sed -i '/Installed-Size/ d' debian/DEBIAN/control # delete
echo "Installed-Size: $(du -s --exclude DEBIAN debian/ | cut -f1)" >> debian/DEBIAN/control

# set file and folder permissions
chmod -R 755 debian/*
chmod 644 debian/DEBIAN/control
chmod 644 debian/DEBIAN/md5sums
chmod 644 debian/usr/share/fulla/db.sql
chmod 644 debian/usr/share/doc/fulla/changelog*
chmod 644 debian/usr/share/doc/fulla/copyright
chmod 644 debian/usr/share/man/man1/fulla.1.gz
chmod 644 debian/usr/share/perl5/Fulla/Commands/Artikel.pm
chmod 644 debian/usr/share/perl5/Fulla/Commands/ArtikelNeu.pm
chmod 644 debian/usr/share/perl5/Fulla/Commands/ArtikelLoeschen.pm
chmod 644 debian/usr/share/perl5/Fulla/Commands/List.pm
chmod 644 debian/usr/share/perl5/Fulla/Commands/Ping.pm
chmod 644 debian/usr/share/perl5/Fulla/Commands/Login.pm
chmod 644 debian/usr/share/perl5/Fulla/Commands/Logout.pm
chmod 644 debian/usr/share/perl5/Fulla/Commands/Register.pm
chmod 644 debian/usr/share/perl5/Fulla/CommandDispatcher.pm
chmod 644 debian/usr/share/perl5/Fulla/Commands/HTTP/Artikel.pm
chmod 644 debian/usr/share/perl5/Fulla/Werchzueg.pm
chmod 644 debian/usr/share/perl5/Fulla/Auth.pm
chmod 644 debian/usr/share/perl5/HTML/Table/FromDatabase.pm

# create deb package
echo -e "\tbuild package"
fakeroot dpkg-deb --build debian \
$( grep Package debian/DEBIAN/control | cut -d" " -f2 )_\
$( grep Version debian/DEBIAN/control | cut -d" " -f2 )_\
$( grep Architecture debian/DEBIAN/control | cut -d" " -f2 )\
.deb

# remove packed things,
# I don't need it in src
rm debian/usr/share/man/man1/fulla.1.gz
rm debian/usr/share/doc/fulla/changelog.gz
rm debian/usr/share/doc/fulla/changelog.Debian.gz
rm debian/usr/share/doc/fulla/copyright
