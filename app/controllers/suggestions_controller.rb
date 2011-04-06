class SuggestionsController < ApplicationController
  def edit
  end

  def update
    @usersuggestion = Suggestion.find(params[:user_suggestion][:suggestionid])
    suggestion = params[:user_suggestion][:suggestion]
    if @usersuggestion.update_attributes(:suggestion => suggestion) #update_attributes() handles characters such as apostrophes
      redirect_to :controller => "user_suggestions", :action => "index"
    else
      render :action => "edit"
    end
  end

end
