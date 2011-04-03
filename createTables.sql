-- createTables.sql

-- create sequences
drop sequence if exists user_id_seq cascade;
create sequence user_id_seq;
drop sequence if exists suggestion_id_seq cascade;
create sequence suggestion_id_seq;
drop sequence if exists survey_id_seq cascade;
create sequence survey_id_seq;

-- create tables
drop table if exists users cascade;
create table users(
  id integer not null primary key default nextval('user_id_seq'),
  first_name text,
  last_name text,
  username text unique,
  password text,
  enc_pass text not null,
  salt text,
  division text,
  department text
);
drop table if exists suggestions cascade;
create table suggestions(
  id integer not null primary key default nextval('suggestion_id_seq'),
  suggestion text unique,
  created_at timestamp,
  updated_at timestamp,
  user_id integer references users(id)
);

--drop table if exists user_suggestions cascade;
--create table user_suggestions(
--  user_id integer references users(id),
--  suggestion_id integer references suggestions(id)
--);

drop table if exists surveys cascade;
create table surveys(
  id integer not null primary key default nextval('survey_id_seq'),
  survey integer references suggestions(id),
  strongly_agree integer default 0, agree integer default 0, neutral integer default 0,
  disagree integer default 0, strongly_disagree integer default 0
);

drop table if exists users_survey cascade;
create table users_survey(
  userid integer references users(id),
  survid integer references surveys(id)
);

--create view for web app
drop view if exists user_suggestion_view cascade;
create view user_suggestion_view as 
  select users.id as userid,users.first_name,users.last_name,users.username,users.password,users.enc_pass,
  users.salt,users.division,users.department,suggestions.id as suggestionid,suggestions.suggestion,suggestions.created_at,
  suggestions.updated_at,suggestions.user_id 
  from users join suggestions on users.id = suggestions.user_id;
  
-- create view for sql script
drop view if exists user_suggestion_view_init cascade;
create view user_suggestion_view_init as 
  select users.id as userid,users.first_name,users.last_name,users.username,users.password,users.enc_pass,
  users.salt,users.division,users.department,suggestions.id as suggestionid,suggestions.suggestion,suggestions.created_at,
  suggestions.updated_at, suggestions.user_id
  from users join suggestions on users.id = suggestions.user_id;
  
-- create view for selecting a survey create
drop view if exists sugg_survey_view cascade;
create view sugg_survey_view as select * from user_suggestion_view, surveys where
  user_suggestion_view.suggestionid = surveys.survey;
  
-- create view for choosing a survey to take
drop view if exists user_survey_view cascade;
create view user_suvey_view as select *
