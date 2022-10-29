ALTER ROLE postgres SET pgrst.db_anon_role = 'postgres';

CREATE ROLE authenticator LOGIN NOINHERIT;
CREATE ROLE anonymous NOLOGIN ROLE authenticator;

CREATE FUNCTION get_database ()
  RETURNS TEXT
  LANGUAGE SQL AS
$sql$
  SELECT '=====get_database=====' || CURRENT_CATALOG;
$sql$;
