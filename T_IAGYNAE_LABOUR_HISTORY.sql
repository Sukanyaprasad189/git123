
drop trigger if exists t_iagynae_labour_history on digital.iagynaeobs_labour cascade ;
create or replace function digital.trigger_fct_t_iagynae_labour_history(  )
returns trigger
language 'plpgsql'
security definer 
as 
$body$ 
declare 
v_ipaddress varchar( 50 ) ;

begin 
set search_path to digital ;

 select sys_context( 'USERENV', 'IP_ADDRESS' )|| '--' || to_char( localtimestamp, 'DD-MON-YYYY HH24:MI:SS' )
 into strict v_ipaddress ;
insert into 
digital.iagynaeobs_labour_history
( gynaeobstetricesid, needsid, isassessment, assessmentaction, createdby, createddate, 
updatedby, updateddate, status, systemipaddress, systemupdateddate, actiondata )
values
( case when old.gynaeobstetricesid = new.gynaeobstetricesid then old.gynaeobstetricesid else new.gynaeobstetricesid end, 
case when old.needsid = new.needsid then old.needsid else new.needsid end, 
case when old.isassessment = new.isassessment then null else new.isassessment end, 
case when old.assessmentaction = new.assessmentaction then null else new.assessmentaction end, 
new.createdby, new.createddate, new.updatedby, new.updateddate, new.status, v_ipaddress, localtimestamp, 
case when old.assessmentaction = new.assessmentaction then null 
else( select string_agg( pi.lovdetailvalue, ',' order by pi.lovdetailid )from wards.lovdetail pi 
	 where pi.lovdetailid in (select regexp_split_to_table(new.assessmentaction,','))
	 /*( with recursive cte as( select( select array_to_string( a, '' )from regexp_matches( new.assessmentaction, '[^,]+', 'g' )as foo( a )limit 1 offset( level - 1 ) )( select array_to_string( a, '' )from regexp_matches( new.assessmentaction, '[^,]+', 'g' )as foo( a )limit 1 offset( level - 1 ) )is not null 
union all 
select( select array_to_string( a, '' )from regexp_matches( new.assessmentaction, '[^,]+', 'g' )as foo( a )limit 1 offset( level - 1 ) )( select array_to_string( a, '' )from regexp_matches( new.assessmentaction, '[^,]+', 'g' )as foo( a )limit 1 offset( level - 1 ) )is not null join cte c on(  ) )select * from cte ;
 )*/
	)end );
 return new;
 end;
 $body$  ;
/*create trigger 
t_iagynae_labour_history 
before 
delete 
or 
update 
or 
insert 
on 
digital.iagynaeobs_labour 
for each row 
execute procedure digital.trigger_fct_t_iagynae_labour_history(  ) ;*/





