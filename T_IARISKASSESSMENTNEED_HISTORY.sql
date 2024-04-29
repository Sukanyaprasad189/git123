drop trigger if exists t_iariskassessmentneed_history on
digital.iariskassessmentneed cascade ;

create or replace
function digital.trigger_fct_t_iariskassessmentneed_history( )
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
	digital.iariskassessmentneed_history( riskassessmentid,
	riskneedid,
	isriskneedreq,
	riskneeddesc,
	createdby,
	createddate,
	updatedby,
	updateddate,
	status,
	systemipaddress,
	systemupdateddate,
	riskneeddesctext )
values( case
	when old.riskassessmentid = new.riskassessmentid then old.riskassessmentid
	else new.riskassessmentid
end,
new.riskneedid,
new.isriskneedreq,
case
	when old.riskneeddesc = new.riskneeddesc then null
	else new.riskneeddesc
end,
new.createdby,
new.createddate,
new.updatedby,
new.updateddate,
new.status,
v_ipaddress,
localtimestamp,
case
	when old.riskneeddesc = new.riskneeddesc then null
	else(
	select
		string_agg( pi.lovdetailvalue,
		','
	order by
		pi.lovdetailid )
		from wards.lovdetail pi
	where
		pi.lovdetailid in   (select regexp_split_to_table(new.riskneeddesc,','))
		
		/*( with recursive cte as(
		select
			(
			select
				array_to_string( a,
				'' )
				from regexp_matches( new.riskneeddesc,
				'[^,]+',
				'g' )as foo(a)
			limit 1 offset( level - 1 ) )(
			select
				array_to_string( a,
				'' )
				from regexp_matches( new.riskneeddesc,
				'[^,]+',
				'g' )as foo(a)
			limit 1 offset( level - 1 ) )is not null
	union all
		select
			(
			select
				array_to_string( a,
				'' )
				from regexp_matches( new.riskneeddesc,
				'[^,]+',
				'g' )as foo(a)
			limit 1 offset( level - 1 ) )(
			select
				array_to_string( a,
				'' )
				from regexp_matches( new.riskneeddesc,
				'[^,]+',
				'g' )as foo(a)
			limit 1 offset( level - 1 ) )is not null
		join cte c on
			())
		select
			*
		from
			cte ;

)*/
)
end);
end;
$body$;

/*create trigger t_iariskassessmentneed_history 
before
delete
	or
update
	or
insert
	on
	digital.iariskassessmentneed 
	for each row 
	execute procedure digital.trigger_fct_t_iariskassessmentneed_history( ) ;  */
