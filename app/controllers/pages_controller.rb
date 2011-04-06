class PagesController < ApplicationController
  def login
    if params[:user] == nil
      username = password = ""
    else
      username = params[:user][:username]
      password = params[:user][:password]
    end
    conn = ActiveRecord::Base.connection
    user_id = conn.select_value("select get_id('" + username + "','" + password +
              "')").to_i
    user = conn.select_one("select * from users where id=" + user_id.to_s + "")
    if user_id > 0
      cookies.signed[:admin] = false
      cookies.signed[:divChair] = false
      cookies.signed[:user_id] = user_id
      cookies.signed[:user_div] = user['division']
      cookies.signed[:user_dep] = user['department']
      cookies.signed[:user_fname] = user['first_name']
      cookies.signed[:user_lname] = user['last_name']
      cookies.signed[:authenticated] = true
      if cookies.signed[:user_div] == "admin" && cookies.signed[:user_dep] == "admin"
        cookies.signed[:admin] = true
      elsif cookies.signed[:user_div] == cookies.signed[:user_dep]
        cookies.signed[:divChair] = true
      end
      redirect_to :controller => "pages", :action => "continue"
    end
  end

  def logout
    #cookies.signed[:admin] = false
    #cookies.signed[:divChair] = false
    #cookies.signed[:user_id] = nil
    #cookies.signed[:user_div] = nil
    #cookies.signed[:user_dep] = nil
    #cookies.signed[:user_fname] = nil
    #cookies.signed[:user_lname] = nil
    #cookies.signed[:authenticated] = false
    cookies.delete :admin
    cookies.delete :divChair
    cookies.delete :user_id
    cookies.delete :user_div
    cookies.delete :user_dep
    cookies.delete :user_fname
    cookies.delete :user_lname
    cookies.delete :authenticated
    redirect_to :controller => "pages", :action => "login"
  end

end
