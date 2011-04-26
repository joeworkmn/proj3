class UserSuggestionsController < ApplicationController
  def index
    #sortBy = params[:sortBy]
    #if sortBy != nil
    #  @usersuggestions = UserSuggestion.order("" + sortBy + " ASC")
    #  respond_to do |format|
    #    format.html
    #    format.xml {render :xml => @usersuggestions, :dasherize => false}
    #    format.json {render :json => @usersuggestions}
    #  end
    #else
      @usersuggestions = GwtSugg.all
      #@usersuggestions = UserSuggestion.order("division ASC")
      #@usersuggestions << "json_num_of_suggs_by_div"
      respond_to do |format|
        format.html
        format.xml {render :xml => @usersuggestions, :dasherize => false}
        format.json {render :json => @usersuggestions}
      end
    #end
  end
 
  def numSuggsByDiv
    @usersuggestions = UserSuggestion.order("division ASC")
      @usersuggestions << "json_num_of_suggs_by_div"
      respond_to do |format|
        format.html
        format.xml {render :xml => @usersuggestions, :dasherize => false}
        format.json {render :json => @usersuggestions}
      end  
  end
  
  def  allSuggestions
    @usersuggestions = UserSuggestion.find_all_by_division(cookies.signed[:user_div])
    @usersuggestions << "json_all_suggs_for_celltable"
    respond_to do |format|
        format.html
        format.xml {render :xml => @usersuggestions, :dasherize => false}
        format.json {render :json => @usersuggestions}
    end
  end
    
  def divChairView
    division = cookies.signed[:user_div]
    @usersuggestions = UserSuggestion.find_all_by_division(division)
    @surveys = Survey.all
    @usersuggestions.each do |us|
      @surveys.each do |s|
        if us.suggestionid == s.survey
          us.suggestion = ""
        end
      end
    end
    @usersuggestions << "json_user_sugg_by_div"
    respond_to do |format|
        format.html
        format.xml {render :xml => @usersuggestions, :dasherize => false}
        format.json {render :json => @usersuggestions}
    end
  end
  
  def depView
    department = cookies.signed[:user_dep]
    @usersuggestions = UserSuggestion.find_all_by_department(department)
  end
  
  skip_before_filter :verify_authenticity_token
  def create
    suggestion = params[:suggestion]
    #suggestion = suggestion.gsub(/'/,"''")
    id = cookies.signed[:user_id]
    conn = ActiveRecord::Base.connection
    sql = "insert into user_suggestion_view (user_id,suggestion) values (" + id.to_s +
      ",'" + suggestion + "')"
    conn.insert(sql)
    #redirect_to :controller => "user_suggestions", :action => "index"
  end
  
  def chooseSuggestion
    id = cookies.signed[:user_id]
    division = cookies.signed[:user_div]
    ownOrDiv = params[:editOwnOrDiv]
    if ownOrDiv == "editOwn"  
      
      @usersuggestions = UserSuggestion.find_all_by_userid(id)
    else ownOrDiv == "editDiv"
      @usersuggestions = UserSuggestion.find_all_by_division(division)
    end
    @usersuggestions << "json_choose_sugg_edit"
    respond_to do |format|
        format.html
        format.xml {render :xml => @usersuggestions, :dasherize => false}
        format.json {render :json => @usersuggestions}
    end
    @usersuggestions << "json_choose_sugg_edit"
  end
  
  def edit
    @usersuggestion = UserSuggestion.find_by_suggestionid(params[:id])
  end
  
  def divSuggestions
    conn = ActiveRecord::Base.connection
    @divs = conn.select_values("select distinct division from users")
    @numOfSuggs = []
    i = 0
    @divs.each do |d|
      @numOfSuggs[i] = UserSuggestion.find_all_by_division(d).length
      i = i + 1
    end
  end
  
  def chooseSuggSurvey
    @usersuggestions = UserSuggestion.find_all_by_division(cookies.signed[:user_div])
    @createdSurveys = SuggSurvey.all
    @usersuggestions.each do |us|
      @createdSurveys.each do |cs|
        if us.suggestionid == cs.survey
          us.suggestion = us.suggestion + " (SURVEY)"
        end
      end
    end
    @notice = params[:notice]
  end
  
  def  pdfTest
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => 'pdfTest', :template => 'user_suggestions/depView.pdf.erb', :layout => 'pdf'
      end
    end
  end
  
  def test_pdf
  
  end
  
  def suggsByDiv
    conn = ActiveRecord::Base.connection
    divisions = conn.select_values("select distinct division from users where division <> 'admin'")
    allSuggs = UserSuggestion.all
    @divSuggs = [[]]
    #i = 0
    divisions.each do |d|
      numSuggs = 0
      allSuggs.each do |as|
        if d == as.division
          numSuggs = numSuggs + 1
        end
      end
      @singleDivSuggs = []
      
      @singleDivSuggs[0] = d
      @singleDivSuggs[1] = numSuggs
      @divSuggs << @singleDivSuggs
      #i = i + 1
    end
    @divSuggs << "json_amount_of_suggs_by_div"
    respond_to do |format|
      format.html
      format.xml {render :xml => @divSuggs, :dasherize => false}
      format.json {render :json => @divSuggs}
    end
  end
end
