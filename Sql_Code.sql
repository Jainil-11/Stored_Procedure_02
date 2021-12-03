create or replace procedure trip_end(bookid DECIMAL(8),tollfee INT,tax INT,charperkm INT,accharges INT,dis INT,droploc VARCHAR(50),dist DECIMAL(4))
as $BODY$
declare
basefee int;
tot int;
t_regno VARCHAR(10);
t_driverid DECIMAL(4,0);
t_book DECIMAL(8);
begin
select booking_id into t_book from ride where booking_id=bookid;
If not found then
	raise exception 'No Such Booking Found';
	end if;
select reg_no into t_regno from ride where booking_id=bookid;
select driver_id into t_driverid from ride where booking_id=bookid;
update ride set end_time=CURRENT_TIME,drop_loc=droploc,distance=dist where booking_id=bookid;
basefee:=dist*charperkm;
tot:=basefee+tollfee+tax+accharges-dis;
update bill_detail set base_fee=basefee,toll_fee=tollfee,taxes=tax,total=tot,ac_charges=accharges,
discount=dis where booking_id=bookid;
update driver set status='True' where driver_id=t_driverid;
update taxi set status='True' where reg_no=t_regno;
end $BODY$ LANGUAGE 'plpgsql';
