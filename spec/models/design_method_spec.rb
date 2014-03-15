# == Schema Information
#
# Table name: design_methods
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  overview   :text             not null
#  process    :text             not null
#  principle  :text             not null
#  owner_id   :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe DesignMethod do
  before do
    @user = User.create(email: "creator@example.com", password: "create123")
    @design_method = DesignMethod.new(name: "example", overview: "overview",
                                      process: "process", principle: "principle",
                                      owner_id: @user.id)

  end

  subject { @design_method }

  it { should respond_to(:name) }
  it { should respond_to(:overview)}
  it { should respond_to(:process)}
  it { should respond_to(:principle)}
  it { should respond_to(:owner_id)}

  it { should respond_to(:method_categories)}
  it { should respond_to(:citations)}
  it { should respond_to(:owner)}


  it { should be_valid }

  describe "when name is not present" do
    before { @design_method.name = ""}
    it { should_not be_valid }
  end

  describe "when overview is not present" do
    before { @design_method.overview = ""}
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @design_method.name = "a" * 256}
    it { should_not be_valid }
  end

  describe "when name is already taken" do
    before do
      same_name = @design_method.dup
      same_name.save
    end
    it { should_not be_valid }
  end

  describe "when method has no owner" do
    before { @design_method.owner = nil }
    it { should_not be_valid }
  end

end