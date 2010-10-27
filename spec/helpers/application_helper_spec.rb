require 'spec_helper'

describe ApplicationHelper do

  describe "#timeago" do
    it "wraps the time in a HTML5 time tag" do
      timeago(Time.now).should =~ /^<time[^>]+>.*<\/time>/
    end
  end
end
