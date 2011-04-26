class SuggestionsController < ApplicationController
  def edit
  end
  
  skip_before_filter :verify_authenticity_token
  def update
    @usersuggestion = Suggestion.find(params[:suggestionid])
    suggestion = params[:suggestion]
    if @usersuggestion.update_attributes(:suggestion => suggestion) #update_attributes() handles characters such as quotes
      redirect_to :controller => "user_suggestions", :action => "index"
    else
      render :action => "edit"
    end
  end

end
