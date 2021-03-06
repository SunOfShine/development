# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

# directories
CGI_DIR=@srcdir@/cgi
ETC_DIR=@srcdir@/etc
LIB_DIR=@srcdir@/lib
LOG_DIR=@srcdir@/log
SHARE_DIR=@srcdir@/share
UI_PLUGINS_DIR=@srcdir@/ui-plugins
SELINUX_DIR=@srcdir@/selinux
DOCDIR=@docdir@
WEBCONF=@web_conf@
CONF=httpd
CGIDIR=@sbindir@
DATAROOTDIR=@datarootdir@

PACKAGE=@PACKAGE@
VERSION=@VERSION@

distdir=$(PACKAGE)-$(VERSION)
DIST_COMMON=config.sub configure.ac configure NEWS INSTALL missing aclocal.m4 install-sh Makefile.am ChangeLog COPYING README AUTHORS Makefile.in config.guess autogen.sh monitoring-ui-plugin.spec
DISTFILES=$(DIST_COMMON) $(CGI_DIR) $(ETC_DIR) $(LIB_DIR) $(LOG_DIR) $(SHARE_DIR) $(UI_PLUGINS_DIR) $(SELINUX_DIR) sample-config docs tools

# compiler settings
prefix=@prefix@
INSTALL=@INSTALL@
INSTALL_OPTS=@INSTALL_OPTS@

# Compile
all:
	cd $(CGI_DIR) && $(MAKE) $@
	cd $(ETC_DIR) && $(MAKE) $@
	cd $(LIB_DIR) && $(MAKE) $@
	cd $(LOG_DIR) && $(MAKE) $@
	cd $(SHARE_DIR) && $(MAKE) $@
	cd $(UI_PLUGINS_DIR) && $(MAKE) $@
	
	cp sample-config/$(CONF).conf.in sample-config/$(CONF).tmp
	sed -i 's!/data/www/monitoring-ui/cgi!$(CGIDIR)!' sample-config/$(CONF).tmp
	sed -i 's!/data/www/monitoring-ui/share!$(DATAROOTDIR)!' sample-config/$(CONF).tmp
	cp sample-config/$(CONF).tmp sample-config/$(CONF).conf
	rm -f sample-config/$(CONF).tmp

# Install
install:
	cd $(CGI_DIR) && $(MAKE) $@
	cd $(ETC_DIR) && $(MAKE) $@
	cd $(LIB_DIR) && $(MAKE) $@
	cd $(LOG_DIR) && $(MAKE) $@
	cd $(SHARE_DIR) && $(MAKE) $@
	cd $(UI_PLUGINS_DIR) && $(MAKE) $@
	
	for file in AUTHORS ChangeLog COPYING NEWS README; do \
	  $(INSTALL) -D -m 644 $(INSTALL_OPTS) $$file $(DESTDIR)$(DOCDIR)/$$file; \
	done
	
	$(INSTALL) -D -m 644 $(INSTALL_OPTS) sample-config/httpd.conf $(DESTDIR)$(WEBCONF)

# Cleanup
clean:
	cd $(CGI_DIR) && $(MAKE) $@
	cd $(ETC_DIR) && $(MAKE) $@
	cd $(LIB_DIR) && $(MAKE) $@
	cd $(LOG_DIR) && $(MAKE) $@
	cd $(SHARE_DIR) && $(MAKE) $@
	cd $(UI_PLUGINS_DIR) && $(MAKE) $@
	
	rm -f sample-config/*.conf
