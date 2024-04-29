drop trigger if exists t_patientbilldetails_draft on
billing.patientbilldetails_draft cascade;

create or replace
function billing.trigger_fct_t_patientbilldetails_draft() 
returns trigger 
language 'plpgsql'
security definer
as 
$BODY$
declare
sess numeric;

prog varchar(200);

begin
set
search_path to billing ;
  sess := sys_context('USERENV',
'SESSIONID');

select
	program
    into
	strict prog
from
	BILLING.VW_SESSION_FOR_BILLING
where
	audsid = sess
	and rownum <= 1;

if /*UPPER(prog) <> 'W3WP.EXE' and*/
UPPER(prog) is not null then

    insert
	into
	BILLING.PATIENTBILLDETAILS_DRAFT_LOG
values (OLD.SERVICEID,
       OLD.STARTDATETIME,
       OLD.SERVICENAME,
       OLD.BEDCATEGORY,
       OLD.DEPARTMENT,
       OLD.FINALTARIFF,
       OLD.AMENDMENTAMOUNT,
       OLD.DIFFAMOUNT,
       OLD.BILLNO,
       OLD.SERVICEREQUESTDTLID,
       user,
       LOCALTIMESTAMP,
       sys_context('USERENV',
'IP_ADDRESS'));
end if;

return new;
end;
$BODY$;

/*create trigger t_patientbilldetails_draft
	before
update
	on
	billing.patientbilldetails_draft for each row
	execute procedure billing.trigger_fct_t_patientbilldetails_draft();*/