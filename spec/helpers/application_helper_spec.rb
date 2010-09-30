require 'spec_helper'

describe ApplicationHelper do

  describe "#time_ago_in_mostly_words" do
    long_format = /\d+. \w+ \d{4}/
    it "formats dates older than six days with long format" do
      time_ago_in_mostly_words(Time.now - 7.days).should =~ long_format
    end

    it "formats dates newer than six days with words" do
      time_ago_in_mostly_words(Time.now - 6.days).should_not =~ long_format
    end
  end
end
