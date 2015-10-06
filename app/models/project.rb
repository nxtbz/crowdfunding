# == Schema Information
#
# Table name: projects
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  name              :string
#  short_description :text
#  description       :text
#  image_url         :string
#  status            :string           default("pending")
#  goal              :decimal(8, 2)
#  expiration_date   :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Project < ActiveRecord::Base
	belongs_to :user 
	has_many :rewards
	has_many :pledges

	validates :name, :short_description, :description, :image_url, :expiration_date, :goal, presence: true 

	def pledges
		rewards.flat_map(&:pledges)
	end
end
