# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  first_name :text
#  last_name  :text
#  username   :text            unique
#  password   :text
#  enc_pass   :text
#  salt       :text
#  division   :text
#  department :text
#

#app/models/user.rb
class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :username, :division, :department
end
