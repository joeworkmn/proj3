-- addInitData.sql
-- Script to add some initial data
-- must run addInsertFuncs.sql first for this to work

-- Add users and suggestions records
--insert into user_suggestion_view_init(first_name, last_name, username, password, 
 -- division, department, suggestion, user_id) values ('john','doe','johnuser','johnpass',
  --'admin','admin','johns suggestion', 1);
insert into users_view(first_name, last_name, username, password, division, department) 
  values('jane', 'doe', 'janeuser', 'janepass', 'admin', 'admin');
insert into user_suggestion_view_init(first_name, last_name, username, password, 
  division, department, suggestion, user_id) values ('john','doe','johnuser','johnpass',
  'TECH','TECH','johns suggestion', 2);
insert into user_suggestion_view_init(first_name, last_name, username, password, 
  division, department, suggestion, user_id) values ('bill','paul','billuser','billpass',
  'TECH','CENT','bills suggestion', 3);
insert into user_suggestion_view_init(first_name, last_name, username, password, 
  division, department, suggestion, user_id) values ('tim','bill','timuser','timpass',
  'TECH','ICS','tims suggestion', 4);
insert into user_suggestion_view_init(first_name, last_name, username, password, 
  division, department, suggestion, user_id) values ('james','smith','jamesuser','jamespass',
  'LIBARTS','LIBARTS','james suggestion', 5);
insert into user_suggestion_view_init(first_name, last_name, username, password, 
  division, department, suggestion, user_id) values ('smith','james','smithuser','smithpass',
  'LIBARTS','MATH','smiths suggestion', 6);
insert into user_suggestion_view_init(first_name, last_name, username, password, 
  division, department, suggestion, user_id) values ('paul','john','pauluser','paulpass',
  'LIBARTS','SCI','pauls suggestion', 7);
  
--Add extra suggestions for each user
insert into user_suggestion_view(suggestion, user_id) values('johns second suggestion', 2);
insert into user_suggestion_view(suggestion, user_id) values('We need a new Division Chair', 3);
insert into user_suggestion_view(suggestion, user_id) values('bills second suggestion', 3);
insert into user_suggestion_view(suggestion, user_id) values('tims second suggestion', 4);
