class PamSqlite3 < Formula
  desc "PAM Module using a sqlite3 database as a backend"
  homepage "https://github.com/jkingweb/pam_sqlite3"
  head "https://github.com/jkingweb/pam_sqlite3.git"

  depends_on "sqlite"

  def install
      args = %W[
        --prefix=#{prefix}
        --bindir=#{bin}
        --sbindir=#{sbin}
        --libexecdir=#{libexec}
        --datadir=#{share}
        --localstatedir=#{var}
        --libdir=#{lib}
        --includedir=#{include}
        --infodir=#{info}
        --mandir=#{man}
        --enable-debug
      ]
    
    system "chmod +x configure"
    system "./configure", *args
    
    sqlite = Formula["sqlite"]
    
    system "clang -g -DDEBUG -fPIC -DPIC -Wall -Wimplicit-function-declaration -Wint-conversion -D_GNU_SOURCE -I/usr/include -c -o pam_sqlite3.o pam_sqlite3.c"
    system "clang -g -DDEBUG -fPIC -DPIC -Wall -D_GNU_SOURCE -I/usr/include -c -o crypt.o crypt.c"
    system "clang -g -DDEBUG -fPIC -DPIC -Wall -D_GNU_SOURCE -I/usr/include -c -o crypt_sha512.o crypt_sha512.c"
    system "clang -g -DDEBUG -fPIC -DPIC -Wall -D_GNU_SOURCE -I/usr/include -c -o pam_get_pass.o pam_get_pass.c"
    system "clang -g -DDEBUG -fPIC -DPIC -Wall -D_GNU_SOURCE -I/usr/include -c -o pam_std_option.o pam_std_option.c"
    system "clang -g -DDEBUG -fPIC -DPIC -Wall -D_GNU_SOURCE -I/usr/include -c -o pam_get_service.o pam_get_service.c"
    system "clang -g -DDEBUG -fPIC -DPIC -Wall -D_GNU_SOURCE -I/usr/include -I#{HOMEBREW_PREFIX}/include -shared -o -c -o pam_sqlite3.so crypt.o crypt_sha512.o pam_sqlite3.o pam_get_pass.o pam_std_option.o pam_get_service.o -lpam -L#{sqlite.opt_lib} -lsqlite3"
    
    lib.install "pam_sqlite3.so"
  end
end