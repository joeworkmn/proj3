class SuggSurveysController < ApplicationController
  def chooseSurvey
    division = cookies.signed[:user_div]
    userid = cookies.signed[:user_id]
    @surveys = SuggSurvey.find_all_by_division(division)
    
  end
  
  def createSurvey
    id = params[:id].first
    conn = ActiveRecord::Base.connection
    #test = conn.select_value("select insertSurvey(" + id.to_s + ")").to_i
    survid = conn.select_value("select id from surveys where survey = " + id.to_s + "").to_i
    notice = ""
    if survid > 0
      notice = "Survey has already been created for this suggestion"
      redirect_to :controller => "user_suggestions", :action => "chooseSuggSurvey", :notice => notice
    else
      sql = "insert into surveys(survey) values(" + id.to_s + ")"
      conn.insert(sql)
      redirect_to :action => "index"
    end
  end
  
  def index
    @surveys = SuggSurvey.find_all_by_division(cookies.signed[:user_div])
  end
  
  def takeSurvey
    id = params[:id]
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
    conn.update("update surveys set " + rating.to_s + " = " + count.to_s + " where
      survey = " + survey.to_s + "")
    conn.insert("insert into users_survey(userid, survid) values('" + userid.to_s +
      "','" + survid.to_s + "')")
    redirect_to :action => "index"
  end

end
