class UserSuggestionsController < ApplicationController
  def index
    @usersuggestions = UserSuggestion.all
  end
  def divChairView
    division = cookies.signed[:user_div]
    @usersuggestions = UserSuggestion.find_all_by_division(division)
  end
  def depView
    department = cookies.signed[:user_dep]
    @usersuggestions = UserSuggestion.find_all_by_department(department)
  end
  def create
    suggestion = params[:user_suggestion][:suggestion]
    id = cookies.signed[:user_id]
    conn = ActiveRecord::Base.connection
    sql = "insert into user_suggestion_view (userid,suggestion) values (" + id.to_s +
      ",'" + suggestion + "')"
    conn.insert(sql)
    redirect_to :controller => "user_suggestions", :action => "index"
    
  end
  
  def chooseSuggestion
    division = cookies.signed[:user_div]
    department = cookies.signed[:user_dep]
    id = cookies.signed[:user_id]
    if division == department  
      @usersuggestions = UserSuggestion.find_all_by_division(division)
    
    else
      @usersuggestions = UserSuggestion.find_all_by_userid(id)
    end
  end
  
  def edit
    @usersuggestion = UserSuggestion.find_by_suggestionid(params[:id])
  end
end