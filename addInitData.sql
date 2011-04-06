-- addInitData.sql
-- Script to add some initial data
-- must run addInsertFuncs.sql first for this to work

-- Add users and suggestions records
insert into user_suggestion_view_init(first_name, last_name, username, password, 
  division, department, suggestion, user_id) values ('john','doe','johnuser','johnpass',
  'admin','admin','johns suggestion', 1);
insert into user_suggestion_view_init(first_name, last_name, username, password, 
  division, department, suggestion, user_id) values ('jane','doe','janeuser','janepass',
  'TECH','TECH','janes suggestion', 2);
insert into user_suggestion_view_init(first_name, last_name, username, password, 
  division, department, suggestion, user_id) values ('bill','clinton','billuser','billpass',
  'TECH','CENT','bills suggestion', 3);
insert into user_suggestion_view_init(first_name, last_name, username, password, 
  division, department, suggestion, user_id) values ('tim','duncan','timuser','timpass',
  'TECH','ICS','tims suggestion', 4);
insert into user_suggestion_view_init(first_name, last_name, username, password, 
  division, department, suggestion, user_id) values ('james','smith','jamesuser','jamespass',
  'LIBARTS','LIBARTS','james suggestion', 5);
insert into user_suggestion_view_init(first_name, last_name, username, password, 
  division, department, suggestion, user_id) values ('smith','james','smithuser','smithpass',
  'LIBARTS','MATH','smiths suggestion', 6);
insert into user_suggestion_view_init(first_name, last_name, username, password, 
  division, department, suggestion, user_id) values ('paul','jackson','pauluser','paulpass',
  'LIBARTS','SCI','pauls suggestion', 7);
