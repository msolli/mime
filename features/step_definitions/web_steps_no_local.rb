# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Gitt /^(?:|at )jeg står på (.*)$/ do |page_name|
  Given %{I am on #{page_name}}
end
