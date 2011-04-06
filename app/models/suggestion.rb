# == Schema Information
#
# Table name: suggestions
#
#  id         :integer         not null, primary key
#  suggestion :text            unique
#  created_at :datetime
#  updated_at :datetime
#

#app/models/suggestion.rb
class Suggestion < ActiveRecord::Base
end
