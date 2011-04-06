create or replace function resetPass(_username text, _password text)
  returns boolean as
  $func$
  declare
    rec record;
    salt1 text;
    success boolean;
  begin
    select into rec * from users where username=_username;
    if not found then
      return 'f';
    else
      salt1 := make_salt(now()||_password);
      execute 'update users set enc_pass=' || 
        quote_literal(make_pass(salt1||_password))
        || ',salt=' || quote_literal(salt1) || 
        ' where username=' || quote_literal(_username);
      get diagnostics success = row_count;
      return success;
    end if;
  end;
  $func$
  language plpgsql;
      
