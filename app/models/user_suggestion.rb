# == Schema Information
#
# Table name: user_suggestion_view
#
#  userid       :integer
#  first_name   :text
#  last_name    :text
#  division     :text
#  department   :text
#  suggestionid :integer
#  suggestion   :text
#  created_at   :datetime
#  updated_at   :datetime
#

#app/models/user_suggestion.rb
class UserSuggestion < ActiveRecord::Base
  set_table_name "user_suggestion_view"
end
