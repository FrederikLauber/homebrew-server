class LuaPam < Formula
  desc "Lua module for PAM authentication"
  homepage "https://github.com/devurandom/lua-pam"
  head "https://github.com/dustinwilson/lua-pam.git"

  depends_on "lua51"
  
  keg_only ""

  def install
    ENV.deparallelize
    lua51 = Formula["lua51"]
    
    system "make LUA_VERSION=5.1 LUA_CPPFLAGS=-I#{lua51.include}/lua-5.1"
    lib.install "pam.so"
  end
end