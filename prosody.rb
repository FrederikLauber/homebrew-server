class Prosody < Formula
  homepage "http://prosody.im"
  url "https://prosody.im/downloads/source/prosody-0.9.10.tar.gz"
  sha256 "4836eefed4d9bbb632cba24ac5bd8e9bc7c029a79d06084b00ffc70858d1662f"
  
  def self.modules
    {
      "addressing" => "Add XEP-0033: Extended Stanza Addressing to Prosody",
      "adhoc-account-management" => "Add XEP-0077: In-Band Registration to Prosody",
      "adhoc-blacklist" => "Add the edit blacklist command in XEP-0133: Service Administration to Prosody",
      "admin-blocklist" => "",
      "admin-message" => "",
      "admin-probe" => "",
      "admin-web" => "",
      "alias" => "",
      "auth-any" => "",
      "auth-ccert" => "",
      "auth-custom-http" => "",
      "auth-dovecot" => "",
      "auth-external" => "",
      "auth-ha1" => "",
      "auth-http-async" => "",
      "auth-imap" => "",
      "auth-internal-yubikey" => "",
      "auth-joomla" => "",
      "auth-ldap" => "",
      "auth-ldap2" => "",
      "auth-pam" => "",
      "auth-phpbb3" => "",
      "auth-sql" => "",
      "auth-wordpress" => "",
      "auto-accept-subscriptions" => "",
      "auto-activate-hosts" => "",
      "benchmark-storage" => "",
      "bidi" => "",
      "block-outgoing" => "",
      "block-registrations" => "",
      "block-s2s-subscriptions" => "",
      "block-strangers" => "",
      "block-subscribes" => "",
      "block-subscriptions" => "",
      "blocking" => "",
      "broadcast" => "",
      "c2s-conn-throttle" => "",
      "c2s-limit-sessions" => "",
      "candy" => "",
      "captcha-registration" => "",
      "carbons" => "",
      "carbons-adhoc" => "",
      "carbons-copies" => "",
      "checkcerts" => "",
      "client-certs" => "",
      "cloud-notify" => "",
      "compact-resource" => "",
      "compat-bind" => "",
      "compat-dialback" => "",
      "compat-muc-admin" => "",
      "compat-vcard" => "",
      "component-client" => "",
      "component-roundrobin" => "",
      "conformance-restricted" => "",
      "couchdb" => "",
      "csi" => "",
      "csi-compat" => "",
      "data-access" => "",
      "default-bookmarks" => "",
      "default-vcard" => "",
      "delegation" => "",
      "disable-tls" => "",
      "discoitems" => "",
      "dwd" => "",
      "email-pass" => "",
      "extdisco" => "",
      "fallback-vcard" => "",
      "filter-chatstates" => "",
      "firewall" => "",
      "flash-policy" => "",
      "graceful-shutdown" => "",
      "group-bookmarks" => "",
      "host-blacklist" => "",
      "host-guard" => "",
      "http-altconnect" => "",
      "http-dir-listing" => "",
      "http-favicon" => "",
      "http-index" => "",
      "http-logging" => "",
      "http-muc-log" => "",
      "http-roster-admin" => "",
      "http-upload" => "",
      "http-user-count" => "",
      "idlecompat" => "",
      "incidents-handling" => "",
      "inotify-reload" => "",
      "invite" => "",
      "ipcheck" => "",
      "isolate-host" => "",
      "jid-prep" => "",
      "json-streams" => "",
      "lastlog" => "",
      "latex" => "",
      "lib-ldap" => "",
      "limit-auth" => "",
      "limits" => "",
      "list-inactive" => "",
      "listusers" => "",
      "log-auth" => "",
      "log-events" => "",
      "log-mark" => "",
      "log-messages-sql" => "",
      "log-rate" => "",
      "log-sasl-mech" => "",
      "log-slow-events" => "",
      "mam" => "",
      "mam-adhoc" => "",
      "mam-archive" => "",
      "mam-muc" => "",
      "mamsub" => "",
      "manifesto" => "",
      "measure-cpu" => "",
      "measure-memory" => "",
      "message-logging" => "",
      "migrate" => "",
      "motd-sequential" => "",
      "muc-access-control" => "",
      "muc-ban-ip" => "",
      "muc-config-restrict" => "",
      "muc-intercom" => "",
      "muc-limits" => "",
      "muc-log" => "",
      "muc-log-http" => "",
      "muc-restrict-rooms" => "",
      "munin" => "",
      "net-dovecotauth" => "",
      "offline-email" => "",
      "onhold" => "",
      "onions" => "",
      "openid" => "",
      "password-policy" => "",
      "pastebin" => "",
      "pep-vcard-avatar" => "",
      "pinger" => "",
      "poke-strangers" => "",
      "post-msg" => "",
      "presence-cache" => "",
      "presence-dedup" => "",
      "privacy-lists" => "",
      "private-adhoc" => "",
      "privilege" => "",
      "proctitle" => "",
      "profile" => "",
      "proxy65-whitelist" => "",
      "pubsub-eventsource" => "",
      "pubsub-feeds" => "",
      "pubsub-github" => "",
      "pubsub-hub" => "",
      "pubsub-mqtt" => "",
      "pubsub-pivotaltracker" => "",
      "pubsub-post" => "",
      "pubsub-twitter" => "",
      "query-client-ver" => "",
      "rawdebug" => "",
      "readonly" => "",
      "register-dnsbl" => "",
      "register-json" => "",
      "register-redirect" => "",
      "register-web" => "",
      "reload-modules" => "",
      "remote-roster" => "",
      "require-otr" => "",
      "roster-allinall" => "",
      "roster-command" => "",
      "s2s-auth-compat" => "",
      "s2s-auth-dane" => "",
      "s2s-auth-fingerprint" => "",
      "s2s-auth-monkeysphere" => "",
      "s2s-blacklist" => "",
      "s2s-idle-timeout" => "",
      "s2s-keepalive" => "",
      "s2s-keysize-policy" => "",
      "s2s-log-certs" => "",
      "s2s-never-encrypt-blacklist" => "",
      "s2s-reload-newcomponent" => "",
      "s2s-whitelist" => "",
      "s2soutinjection" => "",
      "saslauth-muc" => "",
      "saslname" => "",
      "seclabels" => "",
      "secure-interfaces" => "",
      "server-contact-info" => "",
      "server-status" => "",
      "service-directories" => "",
      "sift" => "",
      "smacks" => "",
      "smacks-offline" => "",
      "sms-clickatell" => "",
      "srvinjection" => "",
      "sslv3-warn" => "",
      "stanza-counter" => "",
      "statistics" => "",
      "statistics-auth" => "",
      "statistics-cputotal" => "",
      "statistics-mem" => "",
      "statistics-statsd" => "",
      "statsd" => "",
      "storage-appendmap" => "",
      "storage-gdbm" => "",
      "storage-ldap" => "",
      "storage-lmdb" => "",
      "storage-memory" => "",
      "storage-mongodb" => "",
      "storage-muc-log" => "",
      "storage-multi" => "",
      "storage-xmlarchive" => "",
      "streamstats" => "",
      "strict-https" => "",
      "support-contact" => "",
      "swedishchef" => "",
      "tcpproxy" => "",
      "telnet-tlsinfo" => "",
      "throttle-presence" => "",
      "throttle-unsolicited" => "",
      "tls-policy" => "",
      "track-muc-joins" => "",
      "turncredentials" => "",
      "twitter" => "",
      "uptime-presence" => "",
      "vjud" => "",
      "watchuntrusted" => "",
      "webpresence" => ""
    }
  end
  
  #option "with-sqlite", "Build with SQLite support"
  
  modules.each do |name, desc|
    option "with-#{name}-module", desc
  end

  depends_on "lua51"
  depends_on "expat"
  depends_on "libidn"
  depends_on "openssl"
  #depends_on "sqlite" if build.with? "sqlite"

  fails_with :llvm do
    cause "Lua itself compiles with llvm, but may fail when other software tries to link."
  end

  resource "luarocks" do
    url "http://luarocks.org/releases/luarocks-2.2.0.tar.gz"
    sha1 "e2de00f070d66880f3766173019c53a23229193d"
  end
  
  resource "modules" do
    url "http://hg.prosody.im/prosody-modules/", :using => :hg
  end

  def install
    # Install to the Cellar, but direct modules to prefix
    # Specify where the Lua is to avoid accidental conflict.
    lua_prefix = Formula["lua51"].opt_prefix
    openssl = Formula["openssl"]

    args = ["--prefix=#{prefix}",
            "--sysconfdir=#{etc}/prosody",
            "--datadir=#{var}/lib/prosody",
            "--with-lua=#{lua_prefix}",
            "--with-lua-include=#{lua_prefix}/include/lua5.1",
            "--runwith=lua5.1",
            "--cflags=-I#{openssl.opt_include}",
            "--ldflags=-bundle -undefined dynamic_lookup -L#{openssl.opt_lib}"]

    system "./configure", *args
    system "make"

    # patch config
    inreplace 'prosody.cfg.lua.install' do |s|
      s.sub! '--"posix";', '"posix";'
      s.sub! 'info = "prosody.log";', "-- info = \"#{var}/log/prosody/prosody.log\";"
      s.sub! 'error = "prosody.err";', "-- error = \"#{var}/log/prosody/prosody.err\";"
      # s.sub! '-- "*syslog";', '"*syslog";'
      s.sub! '-- "*console";', '"*console";'
      s.sub! '----------- Virtual hosts -----------', "daemonize=false\n\n----------- Virtual hosts -----------"
      # pid
    end

    (etc+"prosody").mkpath
    (var+"lib/prosody").mkpath
    (var+"run/prosody").mkpath
    (var+"log/prosody").mkpath

    system "make", "install"
    cd "tools/migration" do
      system "make", "install"
    end

    resource("luarocks").stage do
      args = ["--prefix=#{libexec}",
              "--rocks-tree=#{libexec}",
              "--sysconfdir=#{libexec}/etc/luarocks",
              "--force-config",
              "--with-lua=#{lua_prefix}",
              "--lua-version=5.1",
              "--lua-suffix=5.1"]

      system "./configure", *args
      system "make", "build"
      system "make", "install"
      bin.install_symlink "#{libexec}/bin/luarocks" => "prosody-luarocks"
      bin.install_symlink "#{libexec}/bin/luarocks-admin" => "prosody-luarocks-admin"

      # always build rocks against the homebrew openssl, not the system one
      File.open("#{libexec}/etc/luarocks/config-5.1.lua", "a") do |file|
        file.write("external_deps_dirs = { [[#{openssl.opt_prefix}]] }\n")
      end
    end

    # set lua paths for our prosody-luarocks
    inreplace ["#{prefix}/bin/prosody", "#{prefix}/bin/prosodyctl"] do |s|
      rep = "-- Will be modified by configure script if run --"
      luapaths = <<-EOS.undent.chomp
      package.path=[[#{libexec}/share/lua/5.1/?.lua;#{libexec}/share/lua/5.1/?/init.lua]];
      package.cpath=[[#{libexec}/lib/lua/5.1/?.so]];
      EOS
      s.sub! rep, "#{rep}\n\n#{luapaths}"
    end

    system "#{bin}/prosody-luarocks", "install", "luasocket"
    # Install old version until 0.6.x is supported
    system "#{bin}/prosody-luarocks", "install", "https://luarocks.org/manifests/brunoos/luasec-0.5-2.src.rock"
    system "#{bin}/prosody-luarocks", "install", "luafilesystem"
    system "#{bin}/prosody-luarocks", "install", "luaexpat", "EXPAT_DIR=#{Formula["expat"].opt_prefix}"
    
    #if build.with? "sqlite"
    #  system "#{bin}/prosody-luarocks", "install", "luadbi"
    #  system "#{bin}/prosody-luarocks", "install", "luadbi-sqlite3", "SQLITE_DIR=#{Formula["sqlite"].opt_prefix}"
    #  system "#{bin}/prosody-luarocks", "install", "lposix"
    #end
    
    names = []
    self.class.modules.each do |name|
      names.push(name[0].gsub("-", "_")) if build.with? "#{name[0]}-module"
    end
        
    if names.length > 0
      resource("modules").stage do
        names.each do |n|
          (lib/"prosody/modules").install "mod_#{n}/mod_#{n}.lua"
        end
      end
    end
  end

  def caveats; <<-EOS.undent
    For Prosody to work, you may need to create a prosody
    user and group depending on your configuration file
    options.
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <false/>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/prosodyctl</string>
            <string>start</string>
        </array>
        <key>EnvironmentVariables</key>
        <dict>
            <key>PATH</key>
            <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
        </dict>
        <key>StandardErrorPath</key>
        <string>#{var}/log/prosody/prosody.err</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/prosody/prosody.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/luarocks", "install", "say"
  end
end