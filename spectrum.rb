class Spectrum < Formula
  desc "Spectrum is an XMPP transport/gateway."
  homepage "http://spectrum.im/"
  head "https://github.com/hanzz/libtransport.git"
  url "https://github.com/hanzz/spectrum2/archive/2.0.3.tar.gz"
  version "2.0.3"
  sha256 '694172dfbf62d7de19bbcc06ba11113d238c86e36d39297b2f80d4b277e03933'
  
  depends_on "boost"
  depends_on "cmake"
  depends_on "cppunit"
  depends_on "pidgin" => ["without-gui", "without-consoleui"]
  depends_on "libev"
  depends_on "libevent"
  depends_on "libswiften"
  depends_on "log4cxx"
  depends_on "protobuf"
  depends_on "sqlite"
  depends_on "openssl"
  depends_on "popt"
  
  patch :DATA
  
  def install
    openssl = Formula["openssl"]
    
    system "cmake . -DCMAKE_INSTALL_PREFIX=#{prefix} -DOPENSSL_INCLUDE_DIR=#{openssl.include} -DCMAKE_BUILD_TYPE=Debug -DCMAKE_FIND_FRAMEWORK=LAST -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_OSX_SYSROOT=/ -Wno-dev"
    
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/spectrum2_manager"
  end
  
  plist_options :startup => true
  
  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
     <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
       <string>#{bin}/spectrum2_manager</string>
       <string>start</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>EnvironmentVariables</key>
      <dict>
      	<key>PATH</key>
      	<string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
      </dict>
      <key>StandardErrorPath</key>
      <string>#{var}/log/spectrum/spectrum.err</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/spectrum/spectrum.log</string>
     </dict>
    </plist>
    EOS
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index d941288..0d7a545 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -85,6 +85,9 @@ if (WIN32)
 	set(Boost_USE_MULTITHREADED      ON)
 	set(Boost_USE_STATIC_RUNTIME    OFF)
 	find_package(Boost COMPONENTS program_options date_time system filesystem regex thread signals locale REQUIRED)
+elseif (APPLE)
+    set(Boost_USE_MULTITHREADED      ON)
+    find_package(Boost COMPONENTS program_options date_time system filesystem regex thread signals locale REQUIRED)
 else(WIN32)
 	LIST_CONTAINS(contains -lboost_program_options ${SWIFTEN_LIBRARY})
 	if(contains)
diff --git a/backends/smstools3/main.cpp b/backends/smstools3/main.cpp
index b31d496..f297d3f 100644
--- a/backends/smstools3/main.cpp
+++ b/backends/smstools3/main.cpp
@@ -124,7 +124,7 @@ class SMSNetworkPlugin : public NetworkPlugin {
 		}
 
 		void handleSMSDir() {
-			std::string dir = "/var/spool/sms/incoming/";
+			std::string dir = "/usr/local/var/spool/sms/incoming/";
 			if (CONFIG_HAS_KEY(config, "backend.incoming_dir")) {
 				dir = CONFIG_STRING(config, "backend.incoming_dir");
 			}
@@ -160,7 +160,7 @@ class SMSNetworkPlugin : public NetworkPlugin {
 				uuid += bucket[rand() % bucket.size()];
 			}
 			std::ofstream myfile;
-			myfile.open (std::string("/var/spool/sms/outgoing/spectrum." + uuid).c_str());
+			myfile.open (std::string("/usr/local/var/spool/sms/outgoing/spectrum." + uuid).c_str());
 			myfile << data;
 			myfile.close();
 		}
diff --git a/libtransport/Config.cpp b/libtransport/Config.cpp
index f932411..efaaf5e 100644
--- a/libtransport/Config.cpp
+++ b/libtransport/Config.cpp
@@ -80,9 +80,9 @@ bool Config::load(std::istream &ifs, boost::program_options::options_description
 		("service.group", value<std::string>()->default_value(""), "The name of group Spectrum runs as.")
 		("service.backend", value<std::string>()->default_value("libpurple_backend"), "Backend")
 		("service.protocol", value<std::string>()->default_value(""), "Protocol")
-		("service.pidfile", value<std::string>()->default_value("/var/run/spectrum2/$jid.pid"), "Full path to pid file")
-		("service.portfile", value<std::string>()->default_value("/var/run/spectrum2/$jid.port"), "File to store backend_port to. It's used by spectrum2_manager.")
-		("service.working_dir", value<std::string>()->default_value("/var/lib/spectrum2/$jid"), "Working dir")
+		("service.pidfile", value<std::string>()->default_value("/usr/local/var/run/spectrum2/$jid.pid"), "Full path to pid file")
+		("service.portfile", value<std::string>()->default_value("/usr/local/var/run/spectrum2/$jid.port"), "File to store backend_port to. It's used by spectrum2_manager.")
+		("service.working_dir", value<std::string>()->default_value("/usr/local/var/lib/spectrum2/$jid"), "Working dir")
 		("service.allowed_servers", value<std::vector<std::string> >()->multitoken(), "Only users from these servers can connect")
 		("service.server_mode", value<bool>()->default_value(false), "True if Spectrum should behave as server")
 		("service.users_per_backend", value<int>()->default_value(100), "Number of users per one legacy network backend")
@@ -128,7 +128,7 @@ bool Config::load(std::istream &ifs, boost::program_options::options_description
 		("gateway_responder.prompt", value<std::string>()->default_value("Contact ID"), "Value of <prompt> </promt> field")
 		("gateway_responder.label", value<std::string>()->default_value("Enter legacy network contact ID."), "Label for add contact ID field")
 		("database.type", value<std::string>()->default_value("none"), "Database type.")
-		("database.database", value<std::string>()->default_value("/var/lib/spectrum2/$jid/database.sql"), "Database used to store data")
+		("database.database", value<std::string>()->default_value("/usr/local/var/lib/spectrum2/$jid/database.sql"), "Database used to store data")
 		("database.server", value<std::string>()->default_value("localhost"), "Database server.")
 		("database.user", value<std::string>()->default_value(""), "Database user.")
 		("database.password", value<std::string>()->default_value(""), "Database Password.")
@@ -189,17 +189,17 @@ bool Config::load(std::istream &ifs, boost::program_options::options_description
 
 	if (!found_working) {
 		std::vector<std::string> value;
-		value.push_back("/var/lib/spectrum2/$jid");
+		value.push_back("/usr/local/var/lib/spectrum2/$jid");
 		parsed.options.push_back(boost::program_options::basic_option<char>("service.working_dir", value));
 	}
 	if (!found_pidfile) {
 		std::vector<std::string> value;
-		value.push_back("/var/run/spectrum2/$jid.pid");
+		value.push_back("/usr/local/var/run/spectrum2/$jid.pid");
 		parsed.options.push_back(boost::program_options::basic_option<char>("service.pidfile", value));
 	}
 	if (!found_portfile) {
 		std::vector<std::string> value;
-		value.push_back("/var/run/spectrum2/$jid.port");
+		value.push_back("/usr/local/var/run/spectrum2/$jid.port");
 		parsed.options.push_back(boost::program_options::basic_option<char>("service.portfile", value));
 	}
 	if (!found_backend_port) {
@@ -210,7 +210,7 @@ bool Config::load(std::istream &ifs, boost::program_options::options_description
 	}
 	if (!found_database) {
 		std::vector<std::string> value;
-		value.push_back("/var/lib/spectrum2/$jid/database.sql");
+		value.push_back("/usr/local/var/lib/spectrum2/$jid/database.sql");
 		parsed.options.push_back(boost::program_options::basic_option<char>("database.database", value));
 	}
 
diff --git a/packaging/debian/debian/spectrum2-backend-frotz.install b/packaging/debian/debian/spectrum2-backend-frotz.install
index a84229c..0d71b2e 100644
--- a/packaging/debian/debian/spectrum2-backend-frotz.install
+++ b/packaging/debian/debian/spectrum2-backend-frotz.install
@@ -1,2 +1,2 @@
-/usr/bin/spectrum2_frotz_backend
-/usr/bin/dfrotz
+/usr/local/bin/spectrum2_frotz_backend
+/usr/local/bin/dfrotz
diff --git a/packaging/debian/debian/spectrum2-backend-libcommuni.install b/packaging/debian/debian/spectrum2-backend-libcommuni.install
index e999ea2..197d1f7 100644
--- a/packaging/debian/debian/spectrum2-backend-libcommuni.install
+++ b/packaging/debian/debian/spectrum2-backend-libcommuni.install
@@ -1 +1 @@
-/usr/bin/spectrum2_libcommuni_backend
+/usr/local/bin/spectrum2_libcommuni_backend
diff --git a/packaging/debian/debian/spectrum2-backend-libpurple.install b/packaging/debian/debian/spectrum2-backend-libpurple.install
index dabf6b0..b52915f 100644
--- a/packaging/debian/debian/spectrum2-backend-libpurple.install
+++ b/packaging/debian/debian/spectrum2-backend-libpurple.install
@@ -1 +1 @@
-/usr/bin/spectrum2_libpurple_backend
+/usr/local/bin/spectrum2_libpurple_backend
diff --git a/packaging/debian/debian/spectrum2-backend-smstools3.install b/packaging/debian/debian/spectrum2-backend-smstools3.install
index 948195f..8bd6108 100644
--- a/packaging/debian/debian/spectrum2-backend-smstools3.install
+++ b/packaging/debian/debian/spectrum2-backend-smstools3.install
@@ -1 +1 @@
-/usr/bin/spectrum2_smstools3_backend
+/usr/local/bin/spectrum2_smstools3_backend
diff --git a/packaging/debian/debian/spectrum2-backend-swiften.install b/packaging/debian/debian/spectrum2-backend-swiften.install
index cac3d12..85b93a0 100644
--- a/packaging/debian/debian/spectrum2-backend-swiften.install
+++ b/packaging/debian/debian/spectrum2-backend-swiften.install
@@ -1 +1 @@
-/usr/bin/spectrum2_swiften_backend
+/usr/local/bin/spectrum2_swiften_backend
diff --git a/packaging/debian/debian/spectrum2-backend-twitter.install b/packaging/debian/debian/spectrum2-backend-twitter.install
index 088dacf..c1937e0 100644
--- a/packaging/debian/debian/spectrum2-backend-twitter.install
+++ b/packaging/debian/debian/spectrum2-backend-twitter.install
@@ -1 +1 @@
-/usr/bin/spectrum2_twitter_backend
+/usr/local/bin/spectrum2_twitter_backend
diff --git a/packaging/debian/debian/spectrum2.install b/packaging/debian/debian/spectrum2.install
index 0a06e97..efb363d 100644
--- a/packaging/debian/debian/spectrum2.install
+++ b/packaging/debian/debian/spectrum2.install
@@ -1,4 +1,4 @@
-/etc/spectrum2
-/usr/bin/spectrum2
-/usr/bin/spectrum2_manager
-/var/lib/spectrum2_manager
+/usr/local/etc/spectrum2
+/usr/local/bin/spectrum2
+/usr/local/bin/spectrum2_manager
+/var/local/lib/spectrum2_manager
diff --git a/packaging/docker/run.sh b/packaging/docker/run.sh
index 17198c3..8e3973f 100755
--- a/packaging/docker/run.sh
+++ b/packaging/docker/run.sh
@@ -6,6 +6,6 @@ do
 	echo "You should mount the directory with configuration files to /etc/spectrum2/transports/."
 	echo "Check the http://spectrum.im/documentation for more information."
 	spectrum2_manager start
-	tail -f /var/log/spectrum2/*/* 2>/dev/null
+	tail -f /usr/local/var/log/spectrum2/*/* 2>/dev/null
 	sleep 2
 done
diff --git a/packaging/fedora/spectrum2.spec b/packaging/fedora/spectrum2.spec
index fe8b14d..66f34e6 100644
--- a/packaging/fedora/spectrum2.spec
+++ b/packaging/fedora/spectrum2.spec
@@ -46,7 +46,7 @@ install -d %{buildroot}%{_localstatedir}/{lib,run,log}/spectrum2
 install -p -D -m 755 packaging/fedora/spectrum2.init \
     %{buildroot}%{_initddir}/spectrum2
 
-ln -s /usr/bin/spectrum2_libpurple_backend %{buildroot}/usr/bin/spectrum_libpurple_backend
+ln -s /usr/local/bin/spectrum2_libpurple_backend %{buildroot}/usr/local/bin/spectrum_libpurple_backend
 
 %pre
 getent group %{groupname} >/dev/null || groupadd -r %{groupname}
@@ -81,10 +81,10 @@ Spectrum2 libpurple backend
 
 %files libpurple-backend
 %defattr(-, root, root,-)
-/usr/bin/spectrum2_libpurple_backend
-/usr/bin/spectrum_libpurple_backend
-/usr/bin/spectrum2_frotz_backend
-/usr/bin/dfrotz
+/usr/local/bin/spectrum2_libpurple_backend
+/usr/local/bin/spectrum_libpurple_backend
+/usr/local/bin/spectrum2_frotz_backend
+/usr/local/bin/dfrotz
 
 # FROTZ
 
@@ -99,8 +99,8 @@ Spectrum2 frotz backend
 
 %files frotz-backend
 %defattr(-, root, root,-)
-/usr/bin/spectrum2_frotz_backend
-/usr/bin/dfrotz
+/usr/local/bin/spectrum2_frotz_backend
+/usr/local/bin/dfrotz
 
 # COMMUNI
 
@@ -114,7 +114,7 @@ Spectrum2 libpurple backend
 
 %files libcommuni-backend
 %defattr(-, root, root,-)
-/usr/bin/spectrum2_libcommuni_backend
+/usr/local/bin/spectrum2_libcommuni_backend
 
 # SMSTOOLS3
 
@@ -129,7 +129,7 @@ Spectrum2 SMSTools3 backend
 
 %files smstools3-backend
 %defattr(-, root, root,-)
-/usr/bin/spectrum2_smstools3_backend
+/usr/local/bin/spectrum2_smstools3_backend
 
 # SWIFTEN
 
@@ -144,7 +144,7 @@ Spectrum2 Swiften backend
 
 %files swiften-backend
 %defattr(-, root, root,-)
-/usr/bin/spectrum2_swiften_backend
+/usr/local/bin/spectrum2_swiften_backend
 
 # TWITTER
 
@@ -159,7 +159,7 @@ Spectrum2 libyahoo2 backend
 
 %files twitter-backend
 %defattr(-, root, root,-)
-/usr/bin/spectrum2_twitter_backend
+/usr/local/bin/spectrum2_twitter_backend
 
 # LIBTRANSPORT
 
diff --git a/spectrum/src/CMakeLists.txt b/spectrum/src/CMakeLists.txt
index 4f901d0..2ccbd78 100644
--- a/spectrum/src/CMakeLists.txt
+++ b/spectrum/src/CMakeLists.txt
@@ -26,7 +26,11 @@ endif()
 
 if (NOT MSVC)
 # export all symbols (used for loading frontends)
-set(CMAKE_EXE_LINKER_FLAGS "-Wl,-export-dynamic")
+    if (NOT APPLE)
+        set(CMAKE_EXE_LINKER_FLAGS "-Wl,-export-dynamic")
+    else (NOT APPLE)
+        set(CMAKE_EXE_LINKER_FLAGS "-Wl")
+    endif(NOT APPLE)
 endif()
 
 INSTALL(TARGETS spectrum2 RUNTIME DESTINATION bin)
@@ -34,27 +38,27 @@ INSTALL(TARGETS spectrum2 RUNTIME DESTINATION bin)
 INSTALL(FILES
 	sample2_gateway.cfg
 	RENAME spectrum.cfg.example
-	DESTINATION /etc/spectrum2/transports
+	DESTINATION /usr/local/etc/spectrum2/transports
 	)
 
 INSTALL(FILES
 	sample2.cfg
 	RENAME spectrum_server_mode.cfg.example
-	DESTINATION /etc/spectrum2/transports
+	DESTINATION /usr/local/etc/spectrum2/transports
 	)
 
 INSTALL(FILES
 	backend-logging.cfg
-	DESTINATION /etc/spectrum2
+	DESTINATION /usr/local/etc/spectrum2
 	)
 
 INSTALL(FILES
 	logging.cfg
-	DESTINATION /etc/spectrum2
+	DESTINATION /usr/local/etc/spectrum2
 	)
 
 INSTALL(FILES
 	manager-logging.cfg
-	DESTINATION /etc/spectrum2
+	DESTINATION /usr/local/etc/spectrum2
 	)
 
diff --git a/spectrum/src/backend-logging.cfg b/spectrum/src/backend-logging.cfg
index 1078afe..fa43284 100644
--- a/spectrum/src/backend-logging.cfg
+++ b/spectrum/src/backend-logging.cfg
@@ -1,7 +1,7 @@
 log4j.rootLogger=debug, R
 
 log4j.appender.R=org.apache.log4j.RollingFileAppender
-log4j.appender.R.File=/var/log/spectrum2/${jid}/backends/backend-${id}.log
+log4j.appender.R.File=/usr/local/var/log/spectrum2/${jid}/backends/backend-${id}.log
 
 log4j.appender.R.MaxFileSize=10000KB
 # Keep one backup file
diff --git a/spectrum/src/logging.cfg b/spectrum/src/logging.cfg
index f662de5..0449afb 100644
--- a/spectrum/src/logging.cfg
+++ b/spectrum/src/logging.cfg
@@ -1,7 +1,7 @@
 log4j.rootLogger=debug, R
 
 log4j.appender.R=org.apache.log4j.RollingFileAppender
-log4j.appender.R.File=/var/log/spectrum2/${jid}/spectrum2.log
+log4j.appender.R.File=/usr/local/var/log/spectrum2/${jid}/spectrum2.log
 
 log4j.appender.R.MaxFileSize=10000KB
 # Keep one backup file
diff --git a/spectrum/src/manager-logging.cfg b/spectrum/src/manager-logging.cfg
index 607a3d8..cb8880b 100644
--- a/spectrum/src/manager-logging.cfg
+++ b/spectrum/src/manager-logging.cfg
@@ -1,7 +1,7 @@
 log4j.rootLogger=debug, R
 
 log4j.appender.R=org.apache.log4j.RollingFileAppender
-log4j.appender.R.File=/var/log/spectrum2/spectrum_manager.log
+log4j.appender.R.File=/usr/local/var/log/spectrum2/spectrum_manager.log
 
 log4j.appender.R.MaxFileSize=10000KB
 # Keep one backup file
diff --git a/spectrum/src/sample2.cfg b/spectrum/src/sample2.cfg
index 0201bc2..972aa9b 100644
--- a/spectrum/src/sample2.cfg
+++ b/spectrum/src/sample2.cfg
@@ -35,7 +35,7 @@ users_per_backend=10
 #users_per_backend=1
 
 # Full path to backend binary.
-backend=/usr/bin/spectrum2_libpurple_backend
+backend=/usr/local/bin/spectrum2_libpurple_backend
 #backend=/usr/bin/spectrum2_libcommuni_backend
 # For skype:
 #backend=/usr/bin/xvfb-run -a -s "-screen 0 10x10x8" -f /tmp/x-skype-gw /usr/bin/spectrum2_skype_backend
diff --git a/spectrum/src/sample2_gateway.cfg b/spectrum/src/sample2_gateway.cfg
index 32245f6..a8a05c7 100644
--- a/spectrum/src/sample2_gateway.cfg
+++ b/spectrum/src/sample2_gateway.cfg
@@ -29,7 +29,7 @@ users_per_backend=10
 #users_per_backend=1
 
 # Full path to backend binary.
-backend=/usr/bin/spectrum2_libpurple_backend
+backend=/usr/local/bin/spectrum2_libpurple_backend
 #backend=/usr/bin/spectrum2_libcommuni_backend
 # For skype:
 #backend=/usr/bin/xvfb-run -a -s "-screen 0 10x10x8" -f /tmp/x-skype-gw /usr/bin/spectrum2_skype_backend
diff --git a/spectrum_manager/src/CMakeLists.txt b/spectrum_manager/src/CMakeLists.txt
index 2fb114a..595f60a 100644
--- a/spectrum_manager/src/CMakeLists.txt
+++ b/spectrum_manager/src/CMakeLists.txt
@@ -18,16 +18,16 @@ target_link_libraries(spectrum2_manager transport ${APPLE_FRAMEWORKS})
 endif()
 INSTALL(TARGETS spectrum2_manager RUNTIME DESTINATION bin)
 
-# IF(NOT EXISTS "/etc/spectrum2/spectrum_manager.cfg")
+# IF(NOT EXISTS "/usr/local/etc/spectrum2/spectrum_manager.cfg")
 # INSTALL(FILES
 # 	spectrum_manager.cfg
-# 	DESTINATION /etc/spectrum2
+# 	DESTINATION /usr/local/etc/spectrum2
 # 	)
 # ENDIF()
 
 install(CODE "
-if (NOT EXISTS \"/etc/spectrum2/spectrum_manager.cfg\")
-file(INSTALL DESTINATION \"/etc/spectrum2\" TYPE FILES \"${CMAKE_CURRENT_SOURCE_DIR}/spectrum_manager.cfg\")
+if (NOT EXISTS \"/usr/local/etc/spectrum2/spectrum_manager.cfg\")
+file(INSTALL DESTINATION \"/usr/local/etc/spectrum2\" TYPE FILES \"${CMAKE_CURRENT_SOURCE_DIR}/spectrum_manager.cfg\")
 endif()
 ")
 
@@ -35,5 +35,5 @@ endif()
 
 INSTALL(DIRECTORY
 	html
-	DESTINATION /var/lib/spectrum2_manager
+	DESTINATION /usr/local/var/lib/spectrum2_manager
 	)
diff --git a/spectrum_manager/src/main.cpp b/spectrum_manager/src/main.cpp
index a8eef61..1f8deeb 100644
--- a/spectrum_manager/src/main.cpp
+++ b/spectrum_manager/src/main.cpp
@@ -41,7 +41,7 @@ int main(int argc, char **argv)
 													 "Allowed options");
 	desc.add_options()
 		("help,h", "Show help output")
-		("config,c", boost::program_options::value<std::string>(&config_file)->default_value("/etc/spectrum2/spectrum_manager.cfg"), "Spectrum manager config file")
+		("config,c", boost::program_options::value<std::string>(&config_file)->default_value("/usr/local/etc/spectrum2/spectrum_manager.cfg"), "Spectrum manager config file")
 		("command", boost::program_options::value<std::vector<std::string> >(&command), "Command")
 		;
 	try
diff --git a/spectrum_manager/src/managerconfig.cpp b/spectrum_manager/src/managerconfig.cpp
index e24ad09..75dc5d0 100644
--- a/spectrum_manager/src/managerconfig.cpp
+++ b/spectrum_manager/src/managerconfig.cpp
@@ -33,18 +33,18 @@ bool ManagerConfig::load(const std::string &configfile, boost::program_options::
 		("service.admin_password", value<std::string>()->default_value(""), "Administrator password.")
 		("service.port", value<int>()->default_value(8081), "Web interface port.")
 		("service.cert", value<std::string>()->default_value(""), "Web interface certificate in PEM format when TLS should be used.")
-		("service.config_directory", value<std::string>()->default_value("/etc/spectrum2/transports/"), "Directory with spectrum2 configuration files. One .cfg file per one instance")
-		("service.data_dir", value<std::string>()->default_value("/var/lib/spectrum2_manager/html"), "Directory to store Spectrum 2 manager data")
+		("service.config_directory", value<std::string>()->default_value("/usr/local/etc/spectrum2/transports/"), "Directory with spectrum2 configuration files. One .cfg file per one instance")
+		("service.data_dir", value<std::string>()->default_value("/usr/local/var/lib/spectrum2_manager/html"), "Directory to store Spectrum 2 manager data")
 		("service.base_location", value<std::string>()->default_value("/"), "Base location of the web interface")
 		("servers.server", value<std::vector<std::string> >()->multitoken(), "Server.")
 		("database.type", value<std::string>()->default_value("none"), "Database type.")
-		("database.database", value<std::string>()->default_value("/var/lib/spectrum2/$jid/database.sql"), "Database used to store data")
+		("database.database", value<std::string>()->default_value("/usr/local/var/lib/spectrum2/$jid/database.sql"), "Database used to store data")
 		("database.server", value<std::string>()->default_value("localhost"), "Database server.")
 		("database.user", value<std::string>()->default_value(""), "Database user.")
 		("database.password", value<std::string>()->default_value(""), "Database Password.")
 		("database.port", value<int>()->default_value(0), "Database port.")
 		("database.prefix", value<std::string>()->default_value(""), "Prefix of tables in database")
-		("logging.config", value<std::string>()->default_value("/etc/spectrum2/manager_logging.cfg"), "Logging configuration file")
+		("logging.config", value<std::string>()->default_value("/usr/local/etc/spectrum2/manager_logging.cfg"), "Logging configuration file")
 	;
 
 	store(parse_config_file(ifs, opts), m_variables);
diff --git a/spectrum_manager/src/spectrum_manager.cfg b/spectrum_manager/src/spectrum_manager.cfg
index eb0c5a3..3a7cf07 100644
--- a/spectrum_manager/src/spectrum_manager.cfg
+++ b/spectrum_manager/src/spectrum_manager.cfg
@@ -1,5 +1,5 @@
 [service]
-config_directory=/etc/spectrum2/transports/
+config_directory=/usr/local/etc/spectrum2/transports/
 
 # Username and password of admin for Web interface
 admin_username=admin
@@ -15,7 +15,7 @@ base_location=/
 
 [database]
 type=sqlite3
-database=/var/lib/spectrum2_manager/database.sql
+database=/usr/local/var/lib/spectrum2_manager/database.sql
 
 [servers]
 server=localhost