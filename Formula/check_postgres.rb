class CheckPostgres < Formula
  desc "Monitor Postgres databases"
  homepage "https://bucardo.org/wiki/Check_postgres"
  url "https://bucardo.org/downloads/check_postgres-2.22.0.tar.gz"
  sha256 "29cd8ea0a0c0fcd79a1e6afb3f5a1d662c1658eef207ea89276ddb30121b85a8"
  revision 2

  head "https://github.com/bucardo/check_postgres.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f7c7742a460bc88cce9855d2427cf0b8a09f4bc636dbdc7b8cd2557b1542de7" => :high_sierra
    sha256 "36f0895bc5985115dd5b3525b7fbc1f49a2e432e4a52de0a148d8279ac548daf" => :sierra
    sha256 "36f0895bc5985115dd5b3525b7fbc1f49a2e432e4a52de0a148d8279ac548daf" => :el_capitan
    sha256 "36f0895bc5985115dd5b3525b7fbc1f49a2e432e4a52de0a148d8279ac548daf" => :yosemite
  end

  depends_on :postgresql

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make", "install"
    mv bin/"check_postgres.pl", bin/"check_postgres"
    inreplace [bin/"check_postgres", man1/"check_postgres.1p"], "check_postgres.pl", "check_postgres"
    rm_rf prefix/"Library"
    rm_rf prefix/"lib"
  end

  test do
    # This test verifies that check_postgres fails correctly, assuming
    # that no server is running at that port.
    output = shell_output("#{bin}/check_postgres --action=connection --port=65432", 2)
    assert_match /POSTGRES_CONNECTION CRITICAL/, output
  end
end
