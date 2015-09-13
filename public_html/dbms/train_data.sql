create table passanger
(
	Passenger_no varchar(6) primary key,
	Name varchar(20),
	Age numeric,
	Address varchar(30),
	Gender varchar(1),
	Pincode numeric(8),
	State varchar(15),
	Concession char(3),
	Moblei_Number varchar(10)
	);
	DROP TABLE train_master
select * from passanger
create table train_master
(
	Train_no varchar(6) primary key,
	Train_name varchar(30),
	Train_src varchar(5),
	Train_dest varchar(5),
	Train_dep time,
	Train_arrival time
)
select * from train_master
create table station
(
	Station_code varchar(5),
	Station_name varchar(20),
	Metro Char(1)
	)
	select * from station
select * from passanger
insert into passanger values('RLY101','Ravi Kumar',34,'Jerry VIlla','M',670303,'Kerala','Yes','9856784534')

insert into passanger values('RLY102','Ravi Kumar',34,'Naval House','M',270303,'Kerala','Yes','985623434')
insert into passanger values('RLY103','Akshay Suresh',20,'Kachepda','M',474303,'Tamil Nadu','No',982345673);
insert into passanger values('RLY104','Aswin Ramesh',21,'Kollam Road','M',170403,'Andhra Pradehs','No','4978732880');
insert into passanger values('RLY105','Suraj Karthik',20,'R K Road','M',670303,'Uttarpradesh','Yes','9856784534');
insert into passanger values('RLY106','Akhil Suresh',23,'Clappana','M',670303,'Haryana','No','8547565880');
insert into passanger values('RLY107','Rahul Kumar',25,'Rajpath','M',675303,'Assam','Yes','9447487431');
insert into passanger values('RLY108','Sidharth',27,'Ashok Villa','M',660303,'Tripura','Yes',9447487431);
insert into passanger values('RLY109','Naval Kishore',45,'Gandhi Palace','M',870303,'Goa','Yes','8534567821');
insert into passanger values('RLY110','Manish Pandey',35,'Taj Road','M',670303,'Karnataka','No','7890342567');
insert into passanger values('RLY111','Shubham Pandey',24,'R D Palace','M',970303,'Kerala','Yes','9856784534');
insert into passanger values('RLY112','Shubham Pandey',24,'R D Palace','M',970303,'Kerala','Yes','7056784534');

select * from train_master
insert into train_master values('5','BSL-PUNE EXP','BSL','PUNE','11:30','23:26');


insert into train_master values('11026','PUNE-BSL EXP','PUNE','BSL','12:30','22:26');

insert into train_master values('12117','GODAVARI EXP','LTT','MMR','08:30','20:26');

insert into train_master values('12118','LTT-MMR EXPRESS','MMR','LTT','06:30','19:26');
insert into train_master values('13131','KOAA-ANVT EXPRESS','KOAA','ANVT','20:30','23:26');

insert into train_master values('15484','SIKKIM MAHANANDA EXPRESS','DLI','APDJ','15:30','23:26');

insert into train_master values('22101','LTT-MMR RAJYA RANI EXP','LTT','MMT','19:30','23:36');
insert into train_master values('22102','MMR-LTT RAJYA RANI EXP','MMR','LTT','15:30','23:26');
insert into train_master values('51153','MUMBAI BSL PASS','CSTM','BSL','10:30','23:26');
insert into train_master values('51154','KOAA-ANVT EXPRESS','BSL','CSTM','18:30','23:26');

select * from train_master

select * from passanger

select * from station
insert into station values('MMR','MANMAD JN','N');

insert into station values('PUNE','PUNE JN','N');
insert into station values('LTT','LOKAMANYATILAK','Y');
insert into station values('KOAA','KOLKATA','Y');
insert into station values('ANVT','ANAND VIHAR TERMINAL','N');
insert into station values('DLL','DELHI','Y');
insert into station values('APDJ','ALIPUR DUAR JN','N');
insert into station values('CSTM','MUMBAI CST','Y');
insert into station values('ALP','ALLAPEY','Y');

select * from passanger
DELETE FROM passanger where moblei_number like '70%'
alter table  passanger rename coloumn moblei_number to mobile_number;
update  station set station_name='ALLAPUZHA' where station_code='ALP'

ALTER TABLE train_master add  Train_type varchar(15) check(Train_type IN ('MAIL EXP','PASSENGER','SUPERFAST'));
drop table station
select * from train_master
update train_master set Train_type ='MAIL EXP' where Train_no IN ('5','11026','13131','15484');
update train_master set Train_type ='SUPERFAST' where Train_no IN ('22102','22101','12118','12117');
update train_master set Train_type ='PASSENGER' where Train_no IN ('51153','51154')

SELECT train_name FROM train_master where train_dest in ('CSTM','PUNE') or train_src in('CSTM','PUNE')
UPDATE train_master set train_dest='ANVT' WHERE train_no='51154'

select * from train_master
select train_name from train_master
select train_name,train_src ||' to '|| train_dest from train_master

select * from passanger
select * from station

select * from train_master
alter table station add  primary key(station_code)
alter table train_master add foreign key(train_src,train_dest) references station
select * from train_master
select * from station
insert into station values('BSL','BHUSAVAL','N')
select * from train_master,station where train_src=station_code and station_name like 'BHUSAVAL'


select distinct t1.train_name,t2.train_name from train_master as t1,train_master as t2 where t1.train_src=t2.train_dest and t1.train_dest=t2.train_src

select count(train_type) from train_master where train_type like 'SUPERFAST'
select train_type,count(train_type)from train_master group by train_type



