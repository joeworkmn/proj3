-- createTables.sql

-- create sequences
drop sequence if exists user_id_seq cascade;
create sequence user_id_seq;
drop sequence if exists suggestion_id_seq cascade;
create sequence suggestion_id_seq;
drop sequence if exists survey_id_seq cascade;
create sequence survey_id_seq;
drop sequence if exists question_id_seq cascade;
create sequence question_id_seq;
drop sequence if exists option_id_seq cascade;
create sequence option_id_seq;

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
  survey_title text,
  strongly_agree integer default 0, agree integer default 0, neutral integer default 0,
  disagree integer default 0, strongly_disagree integer default 0,
  rating float default 0
);

drop table if exists users_survey cascade;
create table users_survey(
  userid integer references users(id),
  survid integer references surveys(id)
);

drop table if exists questions cascade;
create table questions(
  questionid integer not null primary key default nextval('question_id_seq'),
  survqid integer references surveys(id),
  question_text text
);

drop table if exists options cascade;
create table options(
  optionid integer not null primary key default nextval('option_id_seq'),
  questopid integer references questions(questionid),
  option_text text,
  times_chosen integer default 0
);

drop view if exists survey_suggestion;
create view survey_suggestion as select suggestions.id as suggid, suggestions.suggestion, 
  surveys.id as surveyid, surveys.survey, surveys.survey_title, surveys.strongly_agree,
  surveys.agree, surveys.neutral, surveys.disagree, surveys.strongly_disagree from suggestions join surveys on suggestions.id = surveys.survey;

drop view if exists survey_questions_view;
create view survey_questions_view as select survey_suggestion.suggid, survey_suggestion.suggestion, 
  survey_suggestion.surveyid, survey_suggestion.survey_title, survey_suggestion.strongly_agree,
  survey_suggestion.agree, survey_suggestion.neutral, survey_suggestion.disagree, survey_suggestion.strongly_disagree,
  questions.questionid, questions.survqid, questions.question_text from survey_suggestion LEFT OUTER join questions on survey_suggestion.surveyid = questions.survqid;
  
drop view if exists take_survey_view;
create view take_survey_view as select survey_questions_view.suggestion, survey_questions_view.surveyid, 
  survey_questions_view.survey_title, survey_questions_view.strongly_agree, survey_questions_view.agree, survey_questions_view.neutral,
  survey_questions_view.disagree, survey_questions_view.strongly_disagree, survey_questions_view.questionid, 
  survey_questions_view.question_text, options.questopid, options.option_text, 
  options.times_chosen from survey_questions_view left outer join options on survey_questions_view.questionid = options.questopid;
  


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
  
-- create view for the surveys that have been created
drop view if exists sugg_survey_view cascade;
create view sugg_survey_view as select * from user_suggestion_view, surveys where
  user_suggestion_view.suggestionid = surveys.survey;
  
-- create initial view to be joined with user_survey_view
drop view if exists part1 cascade;
create view part1 as select users.id as uid, users.first_name, users.last_name, users.division, 
  users.department, users_survey.userid as survey_uid, users_survey.survid, 
  surveys.id as sid, surveys.survey, surveys.survey_title, surveys.strongly_agree, surveys.agree, 
  surveys.neutral, surveys.disagree, surveys.strongly_disagree  from users join 
  users_survey on users.id = users_survey.userid join surveys on users_survey.survid = surveys.id;

--create view to show what surveys a user has taken
drop view if exists user_survey_view cascade;
create view user_survey_view as select * from part1, suggestions where part1.survey = suggestions.id;

--create view for GWT. Contains suggestions with their ID so a user can choose a suggestin
drop view if exists gwt_sugg_view cascade;
create view gwt_sugg_view as select suggestion, suggestionid from user_suggestion_view;


--select part1.uid, part1.sid, part1.survey, suggestions.id as suggid, 
--  suggestions.suggestion from part1 join suggestions on part1.survey = suggestions.id;

