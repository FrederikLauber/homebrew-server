class Postfix < Formula
  desc "Free and open-source mail transfer agent"
  homepage "http://postfix.org/"
  url "http://cdn.postfix.johnriley.me/mirrors/postfix-release/official/postfix-3.1.0.tar.gz"
  version "3.1.0"
  sha256 "88ac3e92755629077d9363319b1fa0db406efb10c2f22cdbb941bd8ab36fd733"

  depends_on "sqlite"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "icu4c"
  
  patch :DATA
  
  def install
    sqlite = Formula["sqlite"]
    openssl = Formula["openssl"]
    pcre = Formula["pcre"]
    
    system "make -f Makefile.init makefiles shared=yes dynamicmaps=yes command_directory=#{sbin} config_directory=#{etc}/postfix daemon_directory=#{libexec}/postfix data_directory=#{var}/lib meta_directory=#{etc}/postfix openssl_path=#{openssl.opt_bin}/openssl shlib_directory=#{lib}/postfix CCARGS='-DUSE_SASL_AUTH -DDEF_SERVER_SASL_TYPE=\\\"dovecot\\\" -DHAS_PCRE -I#{pcre.opt_include} -DUSE_TLS -I#{openssl.opt_include}/openssl -DHAS_SQLITE -I#{sqlite.opt_include}' AUXLIBS_SQLITE='-L#{sqlite.opt_lib} -lsqlite3 -lpthread' AUXLIBS_PCRE='-L#{pcre.opt_lib} -lpcre' AUXLIBS='-L#{openssl.opt_lib} -lssl -lcrypto -licuuc'"
    system "make"
    system "sudo make install mail_owner=_postfix setgid_group=_postdrop"
  end
  
  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>OnDemand</key>
        <false/>
        <key>RunAtLoad</key>
        <true/>
        <key>Program</key>
        <string>#{libexec}/postfix/master</string>
        <key>ServiceDescription</key>
        <string>Postfix mail transfer agent</string>
      </dict>
    </plist>
    EOS
  end
end