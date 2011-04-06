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
    execute 'insert into users (first_name, last_name, username, password, enc_pass,
             salt, division, department) values (' || quote_literal(_fname) || ', '
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
  
-- create function for inserting into Users and Suggestions
create or replace function insertUserSuggestion(_fname text, _lname text, 
  _uname text, _password text, _division text, _department text, _suggestion text)
  returns boolean as
  $func$
  declare
    sql1 text;
    sql2 text;
  begin
    sql1 := 'coalesce((select id from users where username = '
      || quote_literal(_uname) || '), insertUser(' 
      || quote_literal(_fname) || ',' || quote_literal(_lname) || 
      ', ' || quote_literal(_uname) || ', ' || quote_literal(_password) || ', '
      || quote_literal(_division) || ', ' || quote_literal(_department)|| '))';
    sql2 := 'coalesce((select id from suggestions where suggestion = ' 
      || quote_literal(_suggestion) || '),insertSuggestion(' ||
      quote_literal(_suggestion) || '))';
    execute 'insert into user_suggestions (user_id, suggestion_id) values (' 
      || sql1 || ',' || sql2 || ')';
    return 't';
  end;
  $func$
  language 'plpgsql';
  
-- create rule
create or replace rule user_suggestion_ins as on insert to user_suggestion_view
  do instead select insertUserSuggestion(new.first_name, new.last_name, new.username,
  new.password, new.division, new.department, new.suggestion);
