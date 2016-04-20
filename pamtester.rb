class Pamtester < Formula
  desc "Tests PAM configurations"
  homepage "http://pamtester.sourceforge.net/"
  url "http://downloads.sourceforge.net/project/pamtester/pamtester/0.1.2/pamtester-0.1.2.tar.gz"
  version "0.1.2"
  sha256 "83633d0e8a4f35810456d9d52261c8ae0beb9148276847cae8963505240fb2d5"

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
      ]
      
    system "./configure", *args
    system "make", "install"
  end
end
