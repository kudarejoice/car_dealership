create table car(
	"car_id" INT primary key,
	"salesman_id" SERIAL,
	"owner_id" INT,
	"model" VARCHAR(20),
	"make" VARCHAR(20),
	"year" INT,
	"color" VARCHAR(20),
	"MSRP" DECIMAL(6,2),
	foreign key (salesman_id) references employee(employee_id),
	foreign key (owner_id) references customer(customer_id)
);

create table employee(
	"employee_id" SERIAL primary key,
	"employee_type" INTEGER,
	"first_name" VARCHAR(20),
	"last_name" VARCHAR(20)
);

create table customer(
	"customer_id" INT primary key,
	"first_name" VARCHAR(50),
	"last_name" VARCHAR(50),
	"address" VARCHAR(50),
	"billing_info" VARCHAR(50)
);

create table invoice(
	"invoice_id" SERIAL primary key,
	"employee_id" SERIAL,
	"car_id" INT,
	"customer_id" SERIAL,
	foreign key (employee_id) references employee(employee_id),
	foreign key (customer_id) references customer(customer_id),
	foreign key (car_id) 	references car(car_id)
);

create table service_labor_log(
	"labor_id" INT primary key,
	"ticket_id" INT,
	"mechanic_id" SERIAL,
	foreign key (ticket_id) references service_ticket(ticket_id),
	foreign key (mechanic_id) references employee(employee_id)
);

create table service_ticket(
	"ticket_id" INT primary key,
	"car_id" INT,
	"customer_id" INT,
	"price" MONEY,
	"needs_parts" BOOLEAN,
	foreign key (car_id) references car(car_id),
	foreign key (customer_id) references customer(customer_id)
);

insert into employee (
	"employee_id",
	"employee_type",
	"first_name",
	"last_name"
)
VALUES(
	01,
	5213,
	'Donnie',
	'Williams'
);

insert into customer(
	"customer_id",
	"first_name",
	"last_name",
	"address",
	"billing_info"
)
VALUES(
	2,
	'Henry',
	'Clark',
	'9532 Windmill ln, Allen, Tx',
	23-968337695-071
);

insert into car(
	"car_id",
	"salesman_id",
	"owner_id",
	"make",
	"model",
	"year",
	"color",
	"MSRP"
)
VALUES(
	001,
	01,
	2,
	'Audi',
	'A6',
	2010,
	'black',
	9683.00
);

insert into invoice(
	"invoice_id",
	"employee_id",
	"car_id",
	"customer_id"
)
VALUES(
	8792,
	01,
	001,
	2
);

insert into service_ticket(
	"ticket_id",
	"car_id",
	"customer_id",
	"price",
	"needs_parts"
)
VALUES(
	00142,
	001,
	2,
	691,
	'True'
);

insert into service_labor_log(
	"labor_id",
	"ticket_id",
	"mechanic_id"
)
VALUES(
	8423,
	00754,
	02
);

create or replace procedure oilChange(
	car INT,
	oilChangeCharge DECIMAL  
)
language plpgsql
as $main$
begin 
	update service_ticket 
	set price = oilChangeCharge
	where car_id = car;
	
	commit;
end;
$main$ 

call oilChange(001, 46.99);

select * from service_ticket where car_id = 001;

drop procedure oilChange;

create or replace procedure getCar(
	car_id INT,
	salesman_id INTEGER,
	MSRP MONEY
)
language plpgsql 
as $main$ 
begin 
	update service_ticket  
	set price = price + MSRP 
	from employee 
	where salesman_id = employee_id; 
	
	commit;
end;
$main$ 

call getCar(001, 01, cast(86975.78 as MONEY));

select * from service_ticket where car_id = 001;

drop procedure getCar;

