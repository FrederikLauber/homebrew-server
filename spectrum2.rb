class Spectrum2 < Formula
  desc "Spectrum is an open source instant messaging transport"
  homepage "http://spectrum.im/"
  head "https://github.com/hanzz/libtransport.git"
  url "https://github.com/hanzz/spectrum2/archive/2.0.3.tar.gz"
  sha256 '694172dfbf62d7de19bbcc06ba11113d238c86e36d39297b2f80d4b277e03933'

  depends_on "boost"
  depends_on "cmake" => :build
  depends_on "cppunit"
  depends_on "libev"
  depends_on "libswiften"
  depends_on "log4cxx"
  depends_on "mysql" => :optional
  depends_on "openssl"
  depends_on "pidgin" => ["without-gui"]
  depends_on "popt"
  depends_on "protobuf"
  depends_on "sqlite"

  patch :DATA

  def install
    ENV.deparallelize
    openssl = Formula["openssl"]

    system "cmake . -DCMAKE_INSTALL_PREFIX=/ -DOPENSSL_ROOT_DIR=#{openssl.prefix} -DOPENSSL_INCLUDE_DIR=#{openssl.include} -DOPENSSL_LIBRARIES=#{openssl.lib}/libssl.dylib -DCMAKE_BUILD_TYPE=Debug -DCMAKE_FIND_FRAMEWORK=LAST -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_OSX_SYSROOT=/ -Wno-dev"

    system "make"
    system "make install DESTDIR=#{prefix}"

    if Dir.exist? "#{etc}/spectrum2" then
      # Remove etc folder so linking it isn't attempted.
      (prefix/"etc").rmtree
    else
      etc.install Dir["#{prefix}/etc/*"]

      # File locations are hard-coded into the configuration files. Correct them.
      inreplace ["#{etc}/spectrum2/backend-logging.cfg", "#{etc}/spectrum2/logging.cfg", "#{etc}/spectrum2/manager-logging.cfg", "#{etc}/spectrum2/spectrum_manager.cfg", "#{etc}/spectrum2/transports/spectrum_server_mode.cfg.example", "#{etc}/spectrum2/transports/spectrum.cfg.example"], "/var", "#{opt_prefix}/var"
      inreplace ["#{etc}/spectrum2/spectrum_manager.cfg", "#{etc}/spectrum2/transports/spectrum_server_mode.cfg.example", "#{etc}/spectrum2/transports/spectrum.cfg.example"], "/etc", "#{HOMEBREW_PREFIX}/etc"
      inreplace ["#{etc}/spectrum2/transports/spectrum_server_mode.cfg.example", "#{etc}/spectrum2/transports/spectrum.cfg.example"], "/usr/bin", "#{HOMEBREW_PREFIX}/bin"
    end
  end

  def caveats; <<-EOS.undent
    For Spectrum to work, you may need to create a spectrum
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

  test do
    assert_match /#{version}/, shell_output("#{bin}/spectrum2_manager --version")
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index d941288..1c6efc9 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -85,6 +85,9 @@ if (WIN32)
 	set(Boost_USE_MULTITHREADED      ON)
 	set(Boost_USE_STATIC_RUNTIME    OFF)
 	find_package(Boost COMPONENTS program_options date_time system filesystem regex thread signals locale REQUIRED)
+elseif(APPLE)
+    set(Boost_USE_MULTITHREADED      ON)
+    find_package(Boost COMPONENTS program_options date_time system filesystem regex thread signals locale REQUIRED)
 else(WIN32)
 	LIST_CONTAINS(contains -lboost_program_options ${SWIFTEN_LIBRARY})
 	if(contains)
@@ -198,7 +201,7 @@ if (WIN32)
 endif()
 
 
-if (CMAKE_COMPILER_IS_GNUCXX)
+if (CMAKE_COMPILER_IS_GNUCXX OR APPLE)
 set(openssl_DIR "${CMAKE_SOURCE_DIR}/cmake_modules")
 find_package(openssl)
 endif()
@@ -439,7 +442,7 @@ include_directories(${EVENT_INCLUDE_DIRS})
 include_directories(${SWIFTEN_INCLUDE_DIR})
 include_directories(${Boost_INCLUDE_DIRS})
 
-if (CMAKE_COMPILER_IS_GNUCXX)
+if (CMAKE_COMPILER_IS_GNUCXX OR APPLE)
 include_directories(${OPENSSL_INCLUDE_DIR})
 endif()
 
diff --git a/spectrum_manager/src/CMakeLists.txt b/spectrum_manager/src/CMakeLists.txt
index 7ddcc25..7ba2ee4 100644
--- a/spectrum_manager/src/CMakeLists.txt
+++ b/spectrum_manager/src/CMakeLists.txt
@@ -10,7 +10,7 @@ target_link_libraries(spectrum2_manager transport ${SWIFTEN_LIBRARY} ${PROTOBUF_
 if (${OPENSSL_FOUND})
 add_definitions(-DMG_ENABLE_SSL)
 endif()
-if (CMAKE_COMPILER_IS_GNUCXX)
+if (CMAKE_COMPILER_IS_GNUCXX OR APPLE)
 target_link_libraries(spectrum2_manager ${OPENSSL_LIBRARIES})
 endif()
