#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../test_helper'

class TestArchive < Test::Unit::TestCase
  
  def setup
    set_file_paths
    @git = Git.open(@wdir)
  end
  
  def tempfile
    Tempfile.new('archive-test').path
  end
  
  def test_archive
    f = @git.archive('v2.6', tempfile)
    assert(File.exist?(f))

    f = @git.object('v2.6').archive(tempfile)  # writes to given file
    assert(File.exist?(f))

    f = @git.object('v2.6').archive # returns path to temp file
    assert(File.exist?(f))
    
    f = @git.object('v2.6').archive(nil, :format => 'tar') # returns path to temp file
    assert(File.exist?(f))

    lines = `cd /tmp; tar tpf #{f}`.split("\n")
    assert_equal('ex_dir/', lines[0])
    assert_equal('example.txt', lines[2])

    f = @git.object('v2.6').archive(tempfile, :format => 'zip')
    assert(File.file?(f))

    f = @git.object('v2.6').archive(tempfile, :format => 'tgz', :prefix => 'test/')
    assert(File.exist?(f))
    
    f = @git.object('v2.6').archive(tempfile, :format => 'tar', :prefix => 'test/', :path => 'ex_dir/')
    assert(File.exist?(f))
    
    lines = `cd /tmp; tar tpf #{f}`.split("\n")
    assert_equal('test/', lines[0])
    assert_equal('test/ex_dir/ex.txt', lines[2])
  end
  
end
