drop trigger if exists t_patientbill_post on
billing.patientbill_post cascade;

create or replace
function billing.trigger_fct_t_patientbill_post() 
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
	BILLING.PATIENTBILL_POST_LOG
values (OLD.PATIENTBILLID,
       OLD.BILLNO,
       OLD.REGISTRATIONNO,
       OLD.PRIMARYDOCTORID,
       OLD.LOCATIONID,
       OLD.BILLDATE,
       OLD.CRETATEDBY,
       OLD.COMPANYID,
       user,
       LOCALTIMESTAMP,
       OLD.PATIENTNAME,
       OLD.TOTALBILLAMOUNT,
       OLD.PATIENTTYPE,
       OLD.BILLSTATUS,
       OLD.CREATEDDATE,
       OLD.PATIENTSERVICE,
       OLD.PATIENTIDENTIFIERNUMBER,
       OLD.BADDEBTFLAG,
       OLD.WRITEOFFFLAG,
       OLD.CLAIMSTATUSID,
       OLD.BATCHID,
       OLD.BILLINGTYPEID,
       OLD.DISCOUNTAMOUNT,
       OLD.TAXAMOUNT,
       OLD.REFFERALDOCTORID,
       OLD.PATIENTOUTSTANDINGAMOUNT,
       OLD.PATIENTPAIDAMOUNT,
       OLD.GENERALCREDITAMOUNT,
       OLD.PATIENTPAYABLEAMOUNT,
       OLD.REFFERALDOCTORFEE,
       OLD.PRINTFORAMTID,
       OLD.PRINTIND,
       OLD.CURRENCYCODE,
       OLD.CONVERSIONRATE,
       OLD.TOTALBILLAMOUNTFX,
       OLD.DISCOUNTAMOUNTFX,
       OLD.TAXAMOUNTFX,
       OLD.PATIENTOUTSTANDINGAMOUNTFX,
       OLD.DEPOSITUSED,
       OLD.DEPOSITUSEDFX,
       OLD.PATIENTPAIDAMOUNTFX,
       OLD.REFERENCENUMBER,
       OLD.PRIMARYPAYERID,
       OLD.AGGREMENTID,
       OLD.DELFLAG,
       OLD.REQUESTEDFROMURL,
       OLD.SUPPLIMANTARYBILLNO,
       OLD.REMARKS,
       OLD.SERVICETAXNO,
       OLD.SERVICETAXAMOUNT,
       OLD.TOTALSERVICEAMOUNT,
       OLD.COSMETICSERVICETAX,
       OLD.COSMETICSERVICETAXSINO,
       OLD.NATIONALITY,
       OLD.PASSPORTNO,
       OLD.PASSPORTHOLDERNAME,
       OLD.SERVICETAXAMOUNTFX,
       OLD.TOTALSERVICEAMOUNTFX,
       OLD.COSMETICSERVICETAXFX,
       OLD.CONVERSIONRATEBILL,
       OLD.FREEPATIENT,
       OLD.LUXURYTAX,
       OLD.TCS_TAX,
       OLD.LOYALTYDISCOUNTAMOUNT,
       OLD.POSTEDDATE,
       sys_context('USERENV',
'IP_ADDRESS'));
end if;

return new;
end;
$BODY$;

/*create trigger t_patientbill_post
	before
update
	on
	billing.patientbill_post for each row
	execute procedure billing.trigger_fct_t_patientbill_post();  */