require "formula"

class Prosody < Formula
  homepage "http://prosody.im"
  url "https://prosody.im/downloads/source/prosody-0.9.10.tar.gz"
  sha256 "4836eefed4d9bbb632cba24ac5bd8e9bc7c029a79d06084b00ffc70858d1662f"
  version "0.9.10"

  # url "https://hg.prosody.im/0.9/", :using => :hg
  # revision 1
  
  option "with-sqlite", "Build with SQLite support"
  
  depends_on "lua51"
  depends_on "expat"
  depends_on "libidn"
  depends_on "openssl"
  
  if build.with? "sqlite"
    depends_on "sqlite"
  end

  fails_with :llvm do
    cause "Lua itself compiles with llvm, but may fail when other software tries to link."
  end

  resource "luarocks" do
    url "http://luarocks.org/releases/luarocks-2.2.0.tar.gz"
    sha1 "e2de00f070d66880f3766173019c53a23229193d"
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
    
    if build.with? "sqlite"
      system "#{bin}/prosody-luarocks", "install", "luadbi"
      system "#{bin}/prosody-luarocks", "install", "luadbi-sqlite3", "SQLITE_DIR=#{Formula["sqlite"].opt_prefix}"
      system "#{bin}/prosody-luarocks", "install", "lposix"
    end
    
    # system "#{bin}/prosody-luarocks", "install", "lua-zlib"
  end

  #def caveats; <<-EOS.undent
  #  TODO: proper docs
  #  Rocks install to: #{libexec}/lib/luarocks/rocks
  #
  #  You may need to run `prosody-luarocks install` inside the Homebrew build
  #  environment for rocks to successfully build. To do this, first run `brew sh`.
  #  EOS
  #end

  test do
    system "#{bin}/luarocks", "install", "say"
  end
end

# external_deps_dirs = { "/usr/local/opt/openssl" }