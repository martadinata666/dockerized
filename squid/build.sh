./configure --prefix=/squid
            --libexec=/squid/lib \
            --datadir=/squid/share \
            --sysconfdir=/squid \
            --with-default-user=docker \
            --without-ldap --without-systemd --disable-auto-locale --disable-auth
make -j6
sudo make install
