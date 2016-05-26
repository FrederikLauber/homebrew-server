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
  depends_on "libevent"
  depends_on "libswiften"
  depends_on "log4cxx"
  depends_on "mysql" => :optional
  depends_on "openssl"
  depends_on "pidgin" => ["without-gui"]
  depends_on "popt"
  depends_on "protobuf"
  depends_on "sqlite"

  def install
    ENV.deparallelize
    openssl = Formula["openssl"]
    
    inreplace "#{buildpath}/CMakeLists.txt" do |s|
      s.sub! /(if\s*\(WIN32\))([\n\s]+)(set\(Boost_USE_STATIC_LIBS)(?m:(.+?))(else\(WIN32\))/, "\\1\\2\\3\\4elseif(APPLE)\n    set(Boost_USE_MULTITHREADED      ON)\n    find_package(Boost COMPONENTS program_options date_time system filesystem regex thread signals locale REQUIRED)\n\\5"
      s.sub! /if(\s+)?\((CMAKE_COMPILER_IS_GNUCXX)\)([\n\s]+)(set\(openssl_DIR)/, "if\\1(\\2 OR APPLE)\\3\\4"
      s.sub! /if(\s+)?\((CMAKE_COMPILER_IS_GNUCXX)\)([\n\s]+)(include_directories)/, "if\\1(\\2 OR APPLE)\\3\\4"
    end
    
    inreplace "#{buildpath}/spectrum/src/CmakeLists.txt", /if(\s+)?\(NOT MSVC\)/, "if\\1(CMAKE_COMPILER_IS_GNUCXX)"
    inreplace "#{buildpath}/spectrum_manager/src/CMakeLists.txt", /if(\s+)?\((CMAKE_COMPILER_IS_GNUCXX)\)([\n\s]+)(target_link_libraries)/, "if\\1(\\2 OR APPLE)\\3\\4"
          
    system "cmake . -DCMAKE_INSTALL_PREFIX=/ -DOPENSSL_ROOT_DIR=#{openssl.prefix} -DOPENSSL_INCLUDE_DIR=#{openssl.include} -DOPENSSL_LIBRARIES=#{openssl.lib}/libssl.dylib -DCMAKE_BUILD_TYPE=Debug -DCMAKE_FIND_FRAMEWORK=LAST -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_OSX_SYSROOT=/ -Wno-dev"

    system "make"
    system "make install DESTDIR=#{prefix}"

    if Dir.exist? "#{var}/lib/spectrum2_manager" then
      (prefix/"var/lib").rmtree
    else
      (var/"lib").install Dir["#{prefix}/var/lib/*"]
    end

    if Dir.exist? "#{etc}/spectrum2" then
      (prefix/"etc").rmtree
    else
      etc.install Dir["#{prefix}/etc/*"]

      inreplace ["#{etc}/spectrum2/backend-logging.cfg", "#{etc}/spectrum2/logging.cfg", "#{etc}/spectrum2/manager-logging.cfg", "#{etc}/spectrum2/spectrum_manager.cfg", "#{etc}/spectrum2/transports/spectrum_server_mode.cfg.example", "#{etc}/spectrum2/transports/spectrum.cfg.example"], "/var", "#{HOMEBREW_PREFIX}/var"
      inreplace ["#{etc}/spectrum2/spectrum_manager.cfg", "#{etc}/spectrum2/transports/spectrum_server_mode.cfg.example", "#{etc}/spectrum2/transports/spectrum.cfg.example"], "/etc", "#{HOMEBREW_PREFIX}/etc"
      inreplace ["#{etc}/spectrum2/transports/spectrum_server_mode.cfg.example", "#{etc}/spectrum2/transports/spectrum.cfg.example"] do |s|
        s.gsub! "/usr/bin", "#{HOMEBREW_PREFIX}/bin"
        s.sub! /jid = .+?\n/,  "\\0\nworking_dir = #{var}/lib/spectrum2/$jid/\npidfile = #{var}/run/spectrum2/$jid/spectrum2.pid\nportfile = #{var}/run/spectrum2/$jid/.port\n"
      end
    end
  end

  def post_install
    (var/"lib/spectrum2").mkpath
    (var/"log/spectrum2").mkpath
    (var/"run/spectrum2").mkpath
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
       <string>-c</string>
       <string>#{etc}/spectrum2/spectrum_manager.cfg</string>
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
      <string>#{var}/log/spectrum2/spectrum2.err</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/spectrum2/spectrum2.log</string>
     </dict>
    </plist>
    EOS
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/spectrum2_manager --version")
  end
end