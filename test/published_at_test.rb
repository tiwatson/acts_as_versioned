require File.join(File.dirname(__FILE__), 'abstract_unit')
require File.join(File.dirname(__FILE__), 'fixtures/page')
require File.join(File.dirname(__FILE__), 'fixtures/widget')

class Published_At_Test < ActiveSupport::TestCase
  fixtures :pages, :page_versions, :locked_pages, :locked_pages_revisions, :authors, :landmarks, :landmark_versions, :published_pages, :published_page_versions
  set_fixture_class :page_versions => Page::Version

  def test_version_published_at
    p = PublishedPage.create! :title => "title"
    assert_equal 1, p.version
    assert_equal nil, p.published_at

    p.update_attributes(:title => 'title a', :published_at => Time.parse('1-1-2020'), :published => true)  
    assert_equal 1, p.version
    assert_equal 2, p.versions.count
    assert_equal nil, p.published_at
    assert_equal true, p.has_unpublished_version      
  end

  def test_version_published_at_1
    p = PublishedPage.create! :title => "title", :published_at => Time.now, :published => true
    assert_equal 1, p.version
    assert_not_equal nil, p.published_at
    assert_equal false, p.has_unpublished_version    

    p.update_attributes(:title => 'title a', :published_at => 1.month.ago, :published => true)  
    assert_equal 2, p.version
  end

  def test_version_work flow
    p = PublishedPage.create! :title => "title", :published_at => Time.now, :published => true
    assert_equal 1, p.version
    assert_not_equal nil, p.published_at
    assert_equal false, p.has_unpublished_version    

    p.update_attributes(:title => 'title a', :published => false)
    assert_equal 1, p.version
    assert_equal 2, p.versions.count
    assert_not_equal nil, p.published_at
    assert_equal true, p.has_unpublished_version      

    p.update_attributes(:title => 'title b', :published => true)
    assert_equal 3, p.version
    assert_equal 3, p.versions.count
    assert_not_equal nil, p.published_at
    assert_equal false, p.has_unpublished_version  
  end

  def test_initial_draft
    p = PublishedPage.create! :title => "title", :published_at => Time.now
    assert_equal 1, p.version
    assert_equal nil, p.published_at    
    assert_equal true, p.has_unpublished_version
  end

end
