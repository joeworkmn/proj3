class SuggSurveysController < ApplicationController
  def chooseSurvey
    division = cookies.signed[:user_div]
    userid = cookies.signed[:user_id]
    @notice = params[:notice]
    #@surveys = SuggSurvey.find_all_by_division(division)
    @surveysAll = SuggSurvey.find_all_by_division(division)
    @surveysTaken = UserSurvey.find_all_by_uid(userid)
    @surveysAll.each do |a|
      @surveysTaken.each do |t|
        if a.id == t.survid and t.uid == userid
          a.suggestion = a.suggestion + " (TAKEN)"
        end
      end  
    end
    @surveysRest = [[]]
    @surveysAll.each do |a|
      if a.suggestion != ""
        @surveysRest = a
      end 
    end
  end
  
  def createSurvey
    id = params[:survey][:usersuggestion]
    survey_title = params[:survey][:survey_title]
    conn = ActiveRecord::Base.connection
    #test = conn.select_value("select insertSurvey(" + id.to_s + ")").to_i
    survid = conn.select_value("select id from surveys where survey = " + id.to_s + "").to_i
    notice = ""
    if survid > 0
      notice = "Survey has already been created for this suggestion"
      redirect_to :controller => "user_suggestions", :action => "chooseSuggSurvey", :notice => notice
    else
      sql = "insert into surveys(survey, survey_title) values(" + id.to_s + ",'" + survey_title.to_s + "')"
      conn.insert(sql)
      redirect_to :action => "index"
    end
  end
  
  def index
    @surveys = SuggSurvey.order("rating DESC").find_all_by_division(cookies.signed[:user_div])
    respond_to do |format|
        format.html
        format.xml {render :xml => @surveys, :dasherize => false}
      end
  end
  
  def takeSurvey
    id = params[:id]
    userid = cookies.signed[:user_id]
    conn = ActiveRecord::Base.connection
    survid = conn.select_value("select id from surveys where survey = " + id.first.to_s + "").to_i
    target = conn.select_value("select survid from users_survey where userid = " + userid.to_s + 
      " and survid = " + survid.to_s + "").to_i
    if target > 0
      @notice = "You have already taken this survey"
      redirect_to :action => "chooseSurvey", :notice => @notice
    end
    @survey = SuggSurvey.find_by_survey(id)
  end
  
  def surveyResult
    rating = params[:choice][:rating]
    survey = params[:choice][:survey]
    userid = params[:choice][:userid]
    conn = ActiveRecord::Base.connection
    survid = conn.select_value("select id from surveys where survey = " + survey.to_s +
      "")
    count = conn.select_value("select " + rating.to_s + " from surveys where
      survey = " + survey.to_s + "").to_i
    count = count + 1
    result = conn.select_value("select insertUserSurvey(" + userid.to_s + "," + survid.to_s + ")").to_i
    if result == 1
      notice = "You have already taken that survey"
      redirect_to :action => "chooseSurvey", :notice => notice
    else
      conn.update("update surveys set " + rating.to_s + " = " + count.to_s + " where
        survey = " + survey.to_s + "")
      conn.update("update surveys set rating = ((strongly_agree*1.5)+agree)-((strongly_disagree*1.5)+disagree)
        where id = " + survid.to_s + "")
      redirect_to :action => "index"
    end
  end
  
   

end
