require File.dirname(__FILE__) + "/spec_helper"

describe "Model validation", :type => :model do
  before do
    @model = Person.new(
      :first_name => "Adam",
      :last_name  => "Williams"
    )
  end
  
  it "should allow me to specify a model be_valid_with a field set to various values" do
    lambda do
      @model.should be_valid_with(:first_name, "abcd", "defg")
    end.should_not raise_error
  end
  
  it "should tell me when any value is not valid with a field" do
    lambda do
      @model.should be_valid_with(:first_name, "", nil)
    end.should raise_error(Spec::Expectations::ExpectationNotMetError)
  end
  
  it "should allow me to specify a model not be_valid_with a field set to various values" do
    lambda do
      @model.should_not be_valid_with(:first_name, "", nil)
    end.should_not raise_error
  end
end