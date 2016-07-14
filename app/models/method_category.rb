# == Schema Information
#
# Table name: method_categories
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  process_order :integer
#

class MethodCategory < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 255,
            too_long: "%{count} is the maximum character length."}
  attr_accessible :name
  has_many :characteristic_groups
  has_many :characteristics, through: :characteristic_groups
  has_many :design_methods, -> { uniq }, through: :characteristics

end
