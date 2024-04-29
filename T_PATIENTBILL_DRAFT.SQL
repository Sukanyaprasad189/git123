drop trigger if exists t_patientbill_draft on
billing.patientbill_draft cascade;

create or replace
function billing.trigger_fct_t_patientbill_draft() 
returns trigger 
language 'plpgsql'

as $BODY$
declare

  sess numeric;

prog varchar(200);

begin

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
	BILLING.PATIENTBILL_DRAFT_LOG
values (OLD.AGREEMENTID,
       OLD.BILLINGTYPEID,
       OLD.BILLNO,
       OLD.CREATEDBY,
       OLD.DEPOSITUSED,
       OLD.DISCOUNT,
       OLD.LOCATIONID,
       OLD.PATIENTIDENTIFIERNO,
       OLD.PATIENTNAME,
       OLD.PAYERID,
       OLD.UHID,
       OLD.REMARKS,
       OLD.REASONFORCORRECTION,
       OLD.OLDTOTALBILLAMOUNT,
       OLD.NEWTOTALBILLAMOUNT,
       OLD.OLDTOTALSERVICEAMOUNT,
       OLD.NEWTOTALSERVICEAMOUNT,
       OLD.DIFFERENCEAMOUNT,
       OLD.REFUNDAMOUNT,
       OLD.PATIENTPAYABLE,
       OLD.PAYERPAYABLE,
       user,
       LOCALTIMESTAMP,
       sys_context('USERENV',
'IP_ADDRESS'));
end if;

return new;
end;
$BODY$;

/*create trigger t_patientbill_draft
	before
update
	on
	billing.patientbill_draft for each row
	execute procedure billing.trigger_fct_t_patientbill_draft(); */
