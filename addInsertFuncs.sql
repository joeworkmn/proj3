-- addInsertFuncs.sql - this script will make it easier to add Users and Suggestions
-- make sure that createTables.sql is run before this

-- create plpgsql language
drop language if exists plpgsql cascade;
create language plpgsql;

-- create function for adding User and returning id
create or replace function insertUser(_fname text, _lname text, _uname text, _password
                  text, _division text, _department text)
  returns integer as
  $func$
  begin
    execute 'insert into users_view (first_name, last_name, username, password, 
             division, department) values (' || quote_literal(_fname) || ', '
             || quote_literal(_lname) || ',' || quote_literal(_uname) || ', ' ||
             quote_literal(_password) || ', ' || quote_literal(_division) || ', ' || 
             quote_literal(_department) || ')';
    return currval('user_id_seq');
  end;
  $func$
  language 'plpgsql';
  

-- create function for adding Suggestion and returning id
create or replace function insertSuggestion(_suggestion text)
  returns integer as
  $func$
  begin
    execute 'insert into suggestions (suggestion, created_at, updated_at) values ('
      || quote_literal(_suggestion) || ',' || quote_literal(now()) || ',' || 
      quote_literal(now()) || ')';
    return currval('suggestion_id_seq');
  end;
  $func$
  language 'plpgsql';
  
-- create function for inserting into Users and Suggestions through web app
create or replace function insertUserSuggestion(_userid integer, _suggestion text)
  returns boolean as
  $func$
  declare
  begin
    execute 'insert into suggestions (suggestion, userid) values(' || quote_literal(_suggestion) ||
      ',' || _userid || ')';
    return 't';
  end;
  $func$
  language 'plpgsql';
  

-- create rule for inserting through web app
create or replace rule user_suggestion_ins as on insert to user_suggestion_view
  do instead select insertUserSuggestion(new.userid, new.suggestion);
  
-- create function for inserting into Users and Suggestions using sql script
create or replace function insertUserSuggestionInit(_fname text, _lname text, 
  _uname text, _password text, _division text, _department text, _suggestion text, _userid integer)
  returns boolean as
  $func$
  declare
    sql1 text;
    sql2 text;
  begin
    select insertUser(_fname, _lname,_uname,_password, _division , _department);
    execute 'insert into suggestions (suggestion, userid) values (' 
      || quote_literal(_suggestion) || ',' || _userid || ')';
    return 't';
  end;
  $func$
  language 'plpgsql';  

-- create rule for inserting sql script
create or replace rule user_suggestion_ins_init as on insert to user_suggestion_view_init
  do instead select insertUserSuggestionInit(new.first_name, new.last_name, new.username,
  new.password, new.division, new.department, new.suggestion, new.userid);
  
-- create function for inserting into surveys
create or replace function insertSurvey(_survey integer)
  returns integer as
  $func$
  declare
    survid record;
  begin
    select * from surveys where surveys.survey = _survey;
    if found then
      return -1;
      --survid := -1;
    else
      execute 'insert into surveys(survey) values(' || _survey || ')';
      select into survid * from surveys where surveys.survey = _survey;
      return survid.id;
    end if;
    --return survid;
  end
  $func$
  language 'plpgsql';
