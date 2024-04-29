DROP TRIGGER IF EXISTS t_longstaypatient ON billing.longstaypatient CASCADE;
CREATE OR REPLACE FUNCTION billing.trigger_fct_t_longstaypatient() 
RETURNS trigger 
LANGUAGE 'plpgsql'
security definer
AS 
$BODY$
DECLARE
  sess numeric;
  prog varchar(200);
BEGIN
set
search_path to billing ;

  sess := sys_context('USERENV', 'SESSIONID');

  SELECT program
    INTO STRICT prog
    FROM vw_session_for_billing
   WHERE audsid = sess
     and rownum <= 1;

  IF ((UPPER(prog) <> 'W3WP.EXE') and (UPPER(prog) <> 'SQLPLUS.EXE') and (UPPER(prog) is not null)) THEN
    case
      when TG_OP = 'INSERT' then
        insert into billing.longstaypatient_log values (
        NEW.ipno,
        NEW.dateofadmission,
        NEW.dateofexecution,
        NEW.locationid,
        sys_context('USERENV', 'IP_ADDRESS'),
        UPPER(prog),
        null,
        null,
        user,
        LOCALTIMESTAMP
        );
        when TG_OP = 'UPDATE'   then
         insert into billing.longstaypatient_log values (
        OLD.ipno,
        OLD.dateofadmission,
        OLD.dateofexecution,
        OLD.locationid,
        sys_context('USERENV', 'IP_ADDRESS'),
        UPPER(prog),
        user,
        LOCALTIMESTAMP,
        null,
        null
        );

  end case;
  END IF;
RETURN NEW;
end;
$BODY$;

/*CREATE TRIGGER t_longstaypatient
	after update or insert ON billing.longstaypatient FOR EACH ROW
	EXECUTE PROCEDURE billing.trigger_fct_t_longstaypatient();*/

