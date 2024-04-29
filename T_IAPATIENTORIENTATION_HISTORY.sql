drop trigger if exists t_iapatientorientation_history on digital.iapatientorientation cascade ;
create or replace function digital.trigger_fct_t_iapatientorientation_history(  )
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
insert into digital.iapatientorientation_history
( uhid, ipnumber, doctorid, nurseid, generalorientation, rightsresponsibilities, isspecialneeds, 
specialneedsdesc, patientdiet1, patientdiet2, patientdiet3, isother, otherdesc, generaldesc, 
rightsdesc, createdby, createddate, updatedby, updateddate, status, locationid, systemipaddress, 
systemupdateddate, patientorientationid )
values
( new.uhid, new.ipnumber, new.doctorid, new.nurseid, 
case when old.generalorientation = new.generalorientation then null else new.generalorientation end, 
case when old.rightsresponsibilities = new.rightsresponsibilities then null else new.rightsresponsibilities end, 
case when old.isspecialneeds = new.isspecialneeds then null else new.isspecialneeds end, 
case when old.specialneedsdesc = new.specialneedsdesc then null else new.specialneedsdesc end, 
case when old.patientdiet1 = new.patientdiet1 then null else new.patientdiet1 end, 
case when old.patientdiet2 = new.patientdiet2 then null else new.patientdiet2 end, 
case when old.patientdiet3 = new.patientdiet3 then null else new.patientdiet3 end, 
case when old.isother = new.isother then null else new.isother end, 
case when old.otherdesc = new.otherdesc then null else new.otherdesc end, 
case when old.generalorientation = new.generalorientation then null 
else( select string_agg( pi.lovdetailvalue, ',' order by pi.lovdetailid )from wards.lovdetail pi
	 where pi.lovdetailid in (select regexp_split_to_table(new.generalorientation,','))
	 /*( with recursive cte as( select( select array_to_string( a, '' )from regexp_matches( new.generalorientation, '[^,]+', 'g' )as foo( a )limit 1 offset( level - 1 ) )s( select array_to_string( a, '' )from regexp_matches( new.generalorientation, '[^,]+', 'g' )as foo( a )limit 1 offset( level - 1 ) )is not null union all select( select array_to_string( a, '' )from regexp_matches( new.generalorientation, '[^,]+', 'g' )as foo( a )limit 1 offset( level - 1 ) )s( select array_to_string( a, '' )from regexp_matches( new.generalorientation, '[^,]+', 'g' )as foo( a )limit 1 offset( level - 1 ) )is not null join cte c on(  ) )select * from cte ;
 ) */
	
	)end, 
 case when old.rightsresponsibilities = new.rightsresponsibilities then null 
 else( select string_agg( pi.lovdetailvalue, ',' order by pi.lovdetailid )from wards.lovdetail pi 
	  where pi.lovdetailid in (select regexp_split_to_table(new.rightsresponsibilities,','))
	 /* ( with recursive cte as( select( select array_to_string( a, '' )from regexp_matches( new.rightsresponsibilities, '[^,]+', 'g' )as foo( a )limit 1 offset( level - 1 ) )s( select array_to_string( a, '' )from regexp_matches( new.rightsresponsibilities, '[^,]+', 'g' )as foo( a )limit 1 offset( level - 1 ) )is not null union all select( select array_to_string( a, '' )from regexp_matches( new.rightsresponsibilities, '[^,]+', 'g' )as foo( a )limit 1 offset( level - 1 ) )s( select array_to_string( a, '' )from regexp_matches( new.rightsresponsibilities, '[^,]+', 'g' )as foo( a )limit 1 offset( level - 1 ) )is not null join cte c on(  ) )select * from cte ;
 )*/
	 )end, 
 new.createdby, new.createddate, new.updatedby, new.updateddate, new.status, new.locationid, v_ipaddress, localtimestamp, 
 case when old.patientorientationid = new.patientorientationid then old.patientorientationid 
 else new.patientorientationid end );
 return new;
 end;
 $body$;
--create trigger t_iapatientorientation_history before delete or update or insert on digital.iapatientorientation for each row execute procedure digital.trigger_fct_t_iapatientorientation_history(  ) ;





