Feature 1

-----sequence creation----
create sequence acc_seq start with 6;

create or replace procedure addAccount(accname in varchar,e_mail in varchar,addr in varchar, pswd in varchar)is
x int;
--v_email account.email%type;
begin 
select count(*) into x from account where email=e_mail;
if x=0 then
insert into account values(acc_seq.nextval,addr,e_mail,pswd,accname,500);
dbms_output.put_line('Account created');
else
dbms_output.put_line('Email already exists');
end if;
end;

-----------Account created----------
begin
 addAccount('Susan','susan@umbc.edu','14800 4th street','susan_123');
end;

-----------Account already exists------
begin
 addAccount('Susan','susan@umbc.edu','14800 4th street','susan_123');
end;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Feature 2

Create or replace function login (e_mail in varchar,pswd in varchar) 
return number
IS
v_email account.email%type;
begin
select email into v_email from account where email=e_mail and pwd=pswd;
if v_email is not null then
dbms_output.put_line('User has logged on');
return 1;
end if;
exception
	when no_data_found then
	dbms_output.put_line('Invalid credentials');
	return 0;
end;

--------User looged on----
declare
v_email varchar(20);
begin
v_email:=login('john@umbc.edu','john_123');
dbms_output.put_line(v_email);
end;

-------Invalid credentials----
declare
v_email varchar(20);
begin
v_email:=login('joh@umbc.edu','john_123');
dbms_output.put_line(v_email);
end;

------Invalid credentials----
declare
v_email varchar(20);
begin
v_email:=login('john@umbc.edu','joh_123');
dbms_output.put_line(v_email);
end;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Feature 3

create sequence message_id_sequence start with 106;

create or replace procedure readMessage(acct_id in number, start_date in date)is
cursor c1 is select body_message from message_table where trunc( message_time) > = start_date and acc_id=acct_id;
v_accid account.acc_id%type;
begin
select acc_id into v_accid from account where acc_id=acct_id;
for r in c1
loop
dbms_output.put_line(r.body_message||',');
end loop;
exception when no_data_found then
dbms_output.put_line('Account does not exist');
end;

------Account does not exist-------
exec readMessage(10,date '2018-01-01');

-------Bill is generated for this account-----
exec readMessage(2,date '2018-01-01');
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
Feature 4

create or replace procedure deleteVehicle(acct_id in number,lic_no in varchar, v_state in varchar) is
v_vid vehicle.vehicle_id %type;
x int;
begin
select count(*) into x from vehicle where acct_id=acc_id and lic_plate_no=lic_no and state=v_state;
;
select vehicle_id into v_vid from vehicle where acct_id=acc_id;
--dbms_output.put_line(x);
dbms_output.put_line(v_vid);
if x =0 then
dbms_output.put_line('Account id is invalid or license, state does not match');
else 
delete from video_bill where trip_id in(select trip_id from trip where vehicle_id=v_vid);
delete from trip where vehicle_id=v_vid;
delete from vehicle where acct_id=acc_id and lic_plate_no=lic_no and state=v_state;
 dbms_output.put_line('Vehicle deleted');
 dbms_output.put_line(v_vid);
 end if;
-- exception when no_data_found then
--  dbms_output.put_line('Account id is invalid or license, state does not match');
  end;


-----The vehicle gets deleted from the account---
begin
deleteVehicle(2,'DZ235','Maryland');
end;

-----The vehicle_id is invalid or state or license does not match---
begin
deleteVehicle(5,'XXXX','Maryland');
end;

------------To add a vehicle to the account-----------

-----------sequence for vehicle id
create sequence vid_seq start with 27;                                    

create or replace procedure addVehicle(acct_id in number, lic_no in varchar, v_state in varchar, v_addr in varchar, v_class in number)
is
x int;
begin
select count(*) into x from vehicle where lic_no=lic_plate_no and state=v_state;
if x=0 then
insert into vehicle values(vid_seq.nextval, acct_id, lic_no, v_state, v_class, v_addr);
dbms_output.put_line('Vehicle successfully added!');
else
dbms_output.put_line('Vehicle already exists! Class and address are updated');
update vehicle
set class=v_class, address=v_addr
where acct_id=acc_id;
end if;
end;

-----Vehicle already exists! Class and address are updated---- 
begin
addVehicle(1, 'AX215', 'Maryland', '4778 Aldgate', 2);
end;

-------Vehicle is successfully added to account-----
begin
addVehicle(6, 'CA659', 'Maryland', '555 Courtney', 2);
end;
------------------------------------------------------------------------------------------------------------------------------------------------------------------
Feature 5

--sequence for transponder_id
create sequence trid_seq start with 604;

------To Add transponder----------
show errors;
create or replace procedure addTransponder(trid in int,acct_id in int)
is
x int;
begin
select count(*) into x from transponder where trid=trans_id and acct_id=acc_id;
if x=0 then
insert into transponder values(trid_seq.nextval, acct_id);
dbms_output.put_line('Transponer successfully added!');
else
dbms_output.put_line('Transponder already exists');
update transponder
set trans_id=trid
where acct_id=acc_id;
end if;
end;

-------Transponder successfully Added-------
set serveroutput on;
begin
addTransponder(604,5);
end;

------Transponder already exists-----
set serveroutput on;
begin
addTransponder(604,5);
end;

------To Delete transponder--------
show errors;
create or replace procedure deleteTransponder(trid in int,acct_id in int) is
t_trid transponder.trans_id %type;
x int;
begin
select count(*) into x from transponder where acct_id=acc_id and trans_id=t_trid;
select trans_id into t_trid from transponder where acct_id=acc_id;
dbms_output.put_line(t_trid);
if x =0 then
dbms_output.put_line('Account id is invalid , transponder does not match');
else 
delete from trip where trans_id=t_trid;
delete from transponder where acct_id=acc_id;
 dbms_output.put_line('Transponder deleted');
 dbms_output.put_line(t_trid);
 end if;
end;

------Transponder Deleted-----
set serveroutput on;
begin
deleteTransponder(620,1);
end;

------Account_id is invalid,Transponder does not match----
set serveroutput on;
begin
deleteTransponder(601,3);
end;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
