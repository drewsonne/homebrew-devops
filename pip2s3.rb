
class Pip2s3 < Formula
  desc "Creates a repository in s3 based on a requirements"
  homepage "https://github.com/drewsonne/pip2s3"
  url "https://github.com/drewsonne/pip2s3/archive/0.1.3.tar.gz"
  version "0.1.3"
  sha256 "4442656b052c246fcf58bd8e691a83260def139edc5725c9653b45df6d24e598"
  depends_on "awscli"

  resource "pip2pi" do
    url "https://pypi.python.org/packages/source/p/pip2pi/pip2pi-0.6.8.tar.gz"
    sha256 "01102883670742bdc2d3e6cc572fbb7263b3396699d2368d575dae9c6b4cbb87"
  end

  resource "awscli" do
    url "https://pypi.python.org/packages/source/a/awscli/awscli-1.9.3.tar.gz"
    sha256 "2b932748f5293f76cc0582a4c7dcd8ec7a74455b7b287127cc7f9b124dc5b5bc"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[pip2pi awscli].each do |dependency|
      resource(dependency).stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }
    end

    bin.install "pip2s3"

    inreplace "#{bin}/pip2s3" do |s|
      s.gsub! /pip2pi/, "#{libexec}/vendor/bin/pip2pi"
    end

    inreplace "#{bin}/pip2s3" do |s|
      s.gsub! /aws/, "#{libexec}/vendor/bin/aws"
    end

    bin.env_script_all_files(libexec/"vendor/bin", :PYTHONPATH => ENV["PYTHONPATH"])

  end

  test do
    system "#{bin}/pip2s3", "-h"
  end

end
