drop trigger if exists t_iariskassessment_history on
digital.iariskassessment cascade ;

create or replace
function digital.trigger_fct_t_iariskassessment_history( )
returns trigger 
language 'plpgsql' 
security definer
as 
$body$ 
declare 
v_ipaddress varchar(50) ;

begin 
set
search_path to digital ;

select
	sys_context( 'USERENV',
	'IP_ADDRESS' )|| '--' || to_char( localtimestamp,
	'DD-MON-YYYY HH24:MI:SS'
)into
	strict v_ipaddress ;

insert
	into
	digital.iariskassessment_history( uhid,
	ipnumber,
	doctorid,
	nurseid,
	ismobilityaid,
	mobilityaiddesc,
	isrisk,
	specialnotes,
	createdby,
	createddate,
	updatedby,
	updateddate,
	status,
	locationid,
	systemipaddress,
	systemupdateddate,
	riskassessmentid,
	isartificialprosthesisid,
	artificialprosthesisdesc,
	istherapeuticdietid,
	therapeuticdietdesc )
values( new.uhid,
new.ipnumber,
new.doctorid,
new.nurseid,
new.ismobilityaid,
case
	when old.mobilityaiddesc = new.mobilityaiddesc then null
	else new.mobilityaiddesc
end,
new.isrisk,
case
	when old.specialnotes = new.specialnotes then null
	else new.specialnotes
end,
new.createdby,
new.createddate,
new.updatedby,
new.updateddate,
new.status,
new.locationid,
v_ipaddress,
localtimestamp,
case
	when old.riskassessmentid = new.riskassessmentid then old.riskassessmentid
	else new.riskassessmentid
end,
new.isartificialprosthesisid,
case
	when old.artificialprosthesisdesc = new.artificialprosthesisdesc then null
	else new.artificialprosthesisdesc
end,
new.istherapeuticdietid,
case
	when old.therapeuticdietdesc = new.therapeuticdietdesc then null
	else new.therapeuticdietdesc
end );
end;
$body$ ;

/*create trigger t_iariskassessment_history before
delete
	or
update
	or
insert
	on
	digital.iariskassessment for each row execute procedure digital.trigger_fct_t_iariskassessment_history( ) ;*/
