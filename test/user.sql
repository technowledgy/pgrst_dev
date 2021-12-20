CREATE ROLE authenticator LOGIN NOINHERIT;
CREATE ROLE anonymous NOLOGIN ROLE authenticator;

CREATE FUNCTION get_users ()
  RETURNS TEXT
  LANGUAGE SQL AS
$sql$
  SELECT '=====get_users=====' || concat_ws(',', SESSION_USER, CURRENT_USER);
$sql$;
