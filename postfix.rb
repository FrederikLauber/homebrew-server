class Postfix < Formula
  desc "Free and open-source mail transfer agent"
  homepage "http://postfix.org/"
  url "http://cdn.postfix.johnriley.me/mirrors/postfix-release/official/postfix-3.1.0.tar.gz"
  version "3.1.0"
  sha256 "88ac3e92755629077d9363319b1fa0db406efb10c2f22cdbb941bd8ab36fd733"
  
  depends_on "icu4c"
  depends_on "sqlite"
  depends_on "openssl"
  depends_on "pcre"
  
  patch :DATA
  
  def install
    sqlite = Formula["sqlite"]
    openssl = Formula["openssl"]
    pcre = Formula["pcre"]
    
    system "make -f Makefile.init makefiles dynamicmaps=yes shared=yes command_directory=#{sbin} config_directory=#{etc}/postfix daemon_directory=#{libexec}/postfix data_directory=#{var}/lib mail_spool_directory=#{var}/mail mailq_path=#{bin}/mailq meta_directory=#{etc}/postfix newaliases_path=#{bin}/newaliases openssl_path=#{openssl.opt_bin}/openssl queue_directory=#{var}/spool/postfix sendmail_path=#{sbin}/sendmail shlib_directory=#{lib}/postfix CCARGS='-DUSE_SASL_AUTH -DDEF_SERVER_SASL_TYPE=\\\"dovecot\\\" -DHAS_PCRE -I#{pcre.opt_include} -DUSE_TLS -I#{openssl.opt_include}/openssl -DHAS_SQLITE -I#{sqlite.opt_include}' AUXLIBS_SQLITE='-L#{sqlite.opt_lib} -lsqlite3 -lpthread' AUXLIBS_PCRE='-L#{pcre.opt_lib} -lpcre' AUXLIBS='-L#{openssl.opt_lib} -lssl -lcrypto -licuuc'"
    system "make"
    system "make install mail_owner=_postfix setgid_group=_postdrop"
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
  
  def caveats; <<-EOS.undent
    This formula patches postfix's install script so it doesn't need root privileges to run. Postfix requires permissions to be just right, so it is necessary to run the following commands with sudo manually:
    
    sudo chmod -R +x #{libexec}/postfix
    sudo #{HOMEBREW_PREFIX}/sbin/postfix post-install create-missing
    sudo #{HOMEBREW_PREFIX}/sbin/postfix set-permissions
    EOS
  end
end

__END__
diff --git a/postfix-install b/postfix-install
old mode 100644
new mode 100755
index 922402b..b62ee2b
--- a/postfix-install
+++ b/postfix-install
@@ -306,9 +306,9 @@ compare_or_replace() {
 	rm -f $tempdir/junk || exit 1
 	cp $src $tempdir/junk || exit 1
 	mv -f $tempdir/junk $dst || exit 1
-	test -z "$owner" || chown $owner $dst || exit 1
-	test -z "$group" || chgrp $group $dst || exit 1
-	chmod $mode $dst || exit 1
+	#test -z "$owner" || chown $owner $dst || exit 1
+	#test -z "$group" || chgrp $group $dst || exit 1
+	#chmod $mode $dst || exit 1
     }
 }
 
@@ -453,10 +453,11 @@ test -z "$non_interactive" && for name in install_root tempdir config_directory
 do
     while :
     do
-	echo
-	eval echo Please specify \$${name}_prompt | ${FMT}
-	eval echo \$n "$name: [\$$name]\  \$c"
-	read ans
+#	echo
+#	eval echo Please specify \$${name}_prompt | ${FMT}
+#	eval echo \$n "$name: [\$$name]\  \$c"
+#	read ans
+    ans=""
 	case $ans in
 	"") break;;
 	 *) case $ans in
@@ -533,10 +534,11 @@ test -z "$non_interactive" && for name in $CONFIG_PARAMS
 do
     while :
     do
-	echo
-	eval echo Please specify \$${name}_prompt | ${FMT}
-	eval echo \$n "$name: [\$$name]\  \$c"
-	read ans
+#	echo
+#	eval echo Please specify \$${name}_prompt | ${FMT}
+#	eval echo \$n "$name: [\$$name]\  \$c"
+#	read ans
+    ans=""
 	case $ans in
 	"") break;;
 	 *) eval $name=$ans; break;;
@@ -624,26 +626,26 @@ trap "rm -f $tempdir/junk" 0 1 2 3 15
     exit 1
 }
 
-test -z "$install_root" && {
-
-    chown root $tempdir/junk >/dev/null 2>&1 || {
-	echo Error: you have no permission to change file ownership. 1>&2
-	exit 1
-    }
-
-    chown "$mail_owner" $tempdir/junk >/dev/null 2>&1 || {
-	echo $0: Error: \"$mail_owner\" needs an entry in the passwd file. 1>&2
-	echo Remember, \"$mail_owner\" needs a dedicated user and group id. 1>&2
-	exit 1
-    }
-
-    chgrp "$setgid_group" $tempdir/junk >/dev/null 2>&1 || {
-	echo $0: Error: \"$setgid_group\" needs an entry in the group file. 1>&2
-	echo Remember, \"$setgid_group\" needs a dedicated group id. 1>&2
-	exit 1
-    }
-
-}
+# test -z "$install_root" && {
+# 
+#     chown root $tempdir/junk >/dev/null 2>&1 || {
+# 	echo Error: you have no permission to change file ownership. 1>&2
+# 	exit 1
+#     }
+# 
+#     chown "$mail_owner" $tempdir/junk >/dev/null 2>&1 || {
+# 	echo $0: Error: \"$mail_owner\" needs an entry in the passwd file. 1>&2
+# 	echo Remember, \"$mail_owner\" needs a dedicated user and group id. 1>&2
+# 	exit 1
+#     }
+# 
+#     chgrp "$setgid_group" $tempdir/junk >/dev/null 2>&1 || {
+# 	echo $0: Error: \"$setgid_group\" needs an entry in the group file. 1>&2
+# 	echo Remember, \"$setgid_group\" needs a dedicated group id. 1>&2
+# 	exit 1
+#     }
+# 
+# }
 
 rm -f $tempdir/junk || exit 1
 
@@ -746,9 +748,9 @@ do
      d) eval path=$install_root$path
 	test "$path" = "${install_root}no" -o -d $path || {
 	    mkdir -p $path || exit 1
-	    test -z "$owner" || chown $owner $path || exit 1
-	    test -z "$group" || chgrp $group $path || exit 1
-	    chmod $mode $path || exit 1
+#	    test -z "$owner" || chown $owner $path || exit 1
+#	    test -z "$group" || chgrp $group $path || exit 1
+#	    chmod $mode $path || exit 1
 	}
 	continue;;
 
@@ -830,7 +832,6 @@ IFS="$BACKUP_IFS"
 # changed from their current default. Defaults can change between
 # Postfix releases, and software should not suddenly be installed in
 # the wrong place when Postfix is being upgraded.
-
 case "$mail_version" in
 "") mail_version="`bin/postconf -dhx mail_version`" || exit 1
 esac
@@ -876,6 +877,6 @@ bin/postconf -c $CONFIG_DIRECTORY -e \
 # The unexpansion above may have side effects on exported variables.
 # It does not matter because bin/postfix below will override them.
 
-test -n "$install_root" || {
-    bin/postfix post-install $post_install_options || exit 1
-}
+#test -n "$install_root" || {
+#    bin/postfix post-install $post_install_options || exit 1
+#}
