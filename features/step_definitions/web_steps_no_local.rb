# encoding: utf-8

require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

def assert_response_status(http_status)
  page.status_code.should == http_status.to_i
end

Then /^I should get a "(\d+)" response$/ do |http_status|
  assert_response_status(http_status)
end

Så /^(?:|skal )jeg få "(\d+)" som respons$/ do |http_status|
  Then %{I should get a "#{http_status}" response}
end

Gitt /^at jeg går til (.*)$/ do |page_name|
  Given %{I go to #{page_name}}
end

Gitt /^(?:|at )jeg står på (.*)$/ do |page_name|
  Given %{I am on #{page_name}}
end

Så /^(?:|skal )feltet "([^"]*)" (?:|skal )ikke inneholde "([^"]*)"$/ do |field, value|
  Then %{the "#{field}" field should not contain "#{value}"}
end

Then /^"([^\"]*)" should be visible$/ do |selector|
  page.should have_css(selector, :visible => true)
end

Then /^"([^\"]*)" should be invisible$/ do |selector|
  page.should have_no_css(selector, :visible => true)
end

Så /^(?:skal )"([^"]*)" være synlig$/ do |selector|
  Then %{"#{selector}" should be visible}
end

Så /^(?:skal )"([^"]*)" være usynlig$/ do |selector|
  Then %{"#{selector}" should be invisible}
end

Then /^"([^\"]*)" should not exist$/ do |selector|
  page.should have_no_css(selector)
end

Så /^(?:skal )ikke "([^"]*)" finnes$/ do |selector|
  Then %{"#{selector}" should not exist}
end

Given /^I wait (\d+) seconds$/ do |count|
  sleep count.to_i
end

Gitt /^jeg venter (\d+) sekund(?:er)$/ do |count|
  Given %{I wait #{count} seconds}
end


Then /^I debug$/ do
  debugger
  0 # necesary, else breakpoint will loose context
end

Så /^debugger jeg$/ do
  Then %{I debug}
end

Så /^skal det være (\d+) av "([^"]*)"$/ do |count, selector|
  page.should have_selector(selector, :count => count.to_i)
end

Så /^skal feltet "([^"]*)" være tomt$/ do |field|
  field = find_field(field)
  field_value = (field.tag_name == 'textarea') ? field.text : field.value
  if field_value.respond_to? :should
    field_value.should == ''
  else
    assert_blank field_value
  end
end

Så /^jeg skal se formatert tekst med en verktøylinje$/ do
  page.should have_xpath("//*[contains(@class, 'cke_editor')]")
end

Når /^jeg legger ved bildet "([^"]*)" til "([^"]*)"$/ do |path, selector|
  Når %{jeg legger ved filen "#{Rails.root}/#{path}" til "#{selector}"}
end

