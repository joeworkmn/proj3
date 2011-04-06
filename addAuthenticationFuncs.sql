-- addAuthenticationFuncs.sql - used to aid authentication
-- requires adding pgcrypto.sql
-- pgcrypto must be added by superuser
-- To install pgcrypto
-- sudo apt-get install postgresql-contrib-8.4
-- connect to psql using a superuser account
-- \i /usr/share/postgresql/8.4/contrib/pgcrypto.sql
-- This must be done for each database that you want
-- to use the digest function for
create or replace function make_salt(_text text)
  returns text as
  $func$
  begin
    return encode(digest(now()||_text,'sha256'),'hex');
  end;
  $func$
  language 'plpgsql';
create or replace function make_pass(_secret text)
  returns text as
  $func$
  begin
    return encode(digest(_secret,'sha256'),'hex');
  end;
  $func$
  language 'plpgsql';
  
-- create view and rule for inserting into users
drop view if exists users_view;
create view users_view as select users.first_name,users.last_name,users.username,
  users.password, users.division, users.department from users;
create or replace rule ins_user as on insert to users_view
  do instead insert into users(first_name,last_name,username,enc_pass,salt,division,department)
  values (new.first_name,new.last_name,new.username,make_pass(make_salt(new.password)||new.password),
  make_salt(new.password),new.division,new.department);
  
-- create function for getting id
-- will return the actual id if the user is authenticated
-- will return -1 if the authentication fails
create or replace function get_id(_username text, _password text)
  returns integer as
  $func$
  declare
    rec record;
  begin
    select into rec * from users where username=_username;
    if not found then
      return -1;
    elseif (make_pass(rec.salt||_password) = rec.enc_pass) then
      return rec.id;
    else
      return -1;
    end if;
  end;
  $func$
  language 'plpgsql';
