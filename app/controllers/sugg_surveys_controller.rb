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
          a.survey_title = a.survey_title + " (TAKEN)"
        end
      end  
    end
    @surveysAll << "json_available_surveys"
    respond_to do |format|
        format.html
        format.xml {render :xml => @surveysAll, :dasherize => false}
        format.json {render :json => @surveysAll}
    end
  end
  
  skip_before_filter :verify_authenticity_token
  def createSurvey
    xml_survey = params[:xml_survey]
    survey_array = Hash.from_xml(xml_survey)
    survey_title = params[:survey_title]
    id = params[:sugg_id].to_i
    #@survey_array = [[]]
    #i = 0
    #j = 0
    #survey_array["arrays"].each do |sa|
    #  @survey_array[i] = sa[0]
    #  i = i + 1
    #end
    #@survey_array = survey_array["arrays"][1].count()
    #@survey_title = survey_title
    #@id = id
    #redirect_to :action => "test", :survey => @survey_array
    
    #id = params[:survey][:usersuggestion]
    #survey_title = params[:survey][:survey_title]
    conn = ActiveRecord::Base.connection
    #test = conn.select_value("select insertSurvey(" + id.to_s + ")").to_i
    survid = conn.select_value("select id from surveys where survey = " + id.to_s + "").to_i
    notice = ""
    if survid > 0
      notice = "survey_already_created"
      #redirect_to :controller => "user_suggestions", :action => "chooseSuggSurvey", :notice => @notice
      #redirect_to :controller => "sugg_surveys", :action => "createSurveyResult", :notice => notice
    else
      
      sql = "insert into surveys(survey, survey_title) values(" + id.to_s + ",'" + survey_title + "')"
      conn.insert(sql)
      survid = conn.select_value("select id from surveys where survey = " + id.to_s + "").to_i
      survey_array["arrays"].each do |sa|
        conn.insert("insert into questions(survqid, question_text) values(" + survid.to_s + ",'" + sa[0] + "')")
        questionid = conn.select_value("select questionid from questions where survqid = " + survid.to_s + 
            " and question_text ='" + sa[0] +"'").to_i
        i = 1
        sa.each do |option|
          if i < sa.count() 
            option = sa[i]
            conn.insert("insert into options(questopid, option_text) values(" + questionid.to_s + ",'" + option + "')")
            i = i + 1 
          end
        end
      end
      notice = "survey_has_been_created"
      #redirect_to :action => "createSurveyResult", :notice => notice
    end
  end
  
  def createSurveyResult
    @notice = params[:notice]  
  end
  
  def index
    @surveys = SuggSurvey.order("rating DESC").find_all_by_division(cookies.signed[:user_div])
    respond_to do |format|
        format.html
        format.xml {render :xml => @surveys, :dasherize => false}
      end
  end
  
  def takeSurvey
    survid = params[:survid].to_i
    @survid = survid
    userid = cookies.signed[:user_id]
    conn = ActiveRecord::Base.connection
    #survid = conn.select_value("select id from surveys where id = " + id.to_s + "").to_i
    #target = conn.select_value("select survid from users_survey where userid = " + userid.to_s + 
    #  " and survid = " + survid.to_s + "").to_i
    
    #if target > 0
    #  @notice = "You have already taken this survey"
      #redirect_to :action => "chooseSurvey", :notice => @notice
      #redirect_to :action => "takeSurveyNotice", :notice => @notice
    #end
    
    #@survey = SuggSurvey.find_all_by_id(survid)
    @survey = TakeSurvey.find_all_by_surveyid(survid)
    @survey << "json_display_survey"
    #redirect_to :action => "test", :survey => @survey
    #@survey.to_json
    @count = @survey.count()
    respond_to do |format|
        format.html
        format.json {render :json => @survey}
    end
    
  end
  
  def takeSurveyDisplay
    @survey = params[:survey]
    respond_to do |format|
        format.html
        format.json {render :json => @survey}
    end
  end
  
  def takeSurveyNotice
    @notice = params[:notice]    
  end
  
  skip_before_filter :verify_authenticity_token
  def surveyResult
    rating = params[:initial_option]
    surveyid = params[:survey_id].to_i
    #userid = params[:choice][:userid]
    userid = cookies.signed[:user_id].to_i
    xml = params[:results_array]
    results_array = Hash.from_xml(xml)
    conn = ActiveRecord::Base.connection
    #survid = conn.select_value("select id from surveys where id = " + surveyid.to_s +
    #  "")
    count = conn.select_value("select " + rating.to_s + " from surveys where
      id = " + surveyid.to_s + "").to_i
    count = count + 1
    result = conn.select_value("select insertUserSurvey(" + userid.to_s + "," + surveyid.to_s + ")").to_i
    #if result == 1
    #  notice = "You have already taken that survey"
    #  redirect_to :action => "chooseSurvey", :notice => notice
    #else
    results_array["arrays"].each do |ra|
      option_count = 0
      qid = ra[0].to_i
      #temp = ra
      #redirect_to :action => "test", :survey => temp
      option_count = conn.select_value("select times_chosen from options where questopid="+qid.to_s+" and option_text='"+ra[1]+"'").to_i
      option_count = option_count + 1
      conn.update("update options set times_chosen="+option_count.to_s+" where questopid="+qid.to_s+" and option_text='"+ra[1]+"'")
    end
    conn.update("update surveys set " + rating.to_s + " = " + count.to_s + " where
      id = " + surveyid.to_s + "")
    conn.update("update surveys set rating = ((strongly_agree*1.5)+agree)-((strongly_disagree*1.5)+disagree)
      where id = " + surveyid.to_s + "")
    redirect_to :action => "index"
  end
  
  def test
    @survey = params[:survey]
  end

end
