require 'spec_helper'

describe Location do
  before(:each) do
    @location = Location.new(:lat => 60, :lng => 10)
  end
  
  it 'should be valid' do
    @location.should be_valid
  end
  
  it { should be_embedded_in(:article).as_inverse_of(:location) }
  it { should validate_numericality_of(:latitude) }
  it { should validate_numericality_of(:longitude) }
  
  it 'should be valid if both latitude and longitude are blank' do
    @location = Location.new
    @location.should be_valid
  end

  context 'with either latitude or longitude as nil' do
    it 'should not be valid if latitude is nil' do
      @location.lat = nil
      Rails.logger.debug @location.inspect
      @location.should_not be_valid
    end
    it 'should not be valid if longitude is nil' do
      @location.lng = nil
      Rails.logger.debug @location.inspect
      @location.should_not be_valid
    end
  end

  it 'should only allow latitude between 90 and -90' do
    @location.lat = 91
    @location.should_not be_valid
    @location.lat = -91
    @location.should_not be_valid
  end
  it 'should only allow longitude between 180 and -180' do
    @location.lng = 191
    @location.should_not be_valid
    @location.lng = -191
    @location.should_not be_valid
  end
end
