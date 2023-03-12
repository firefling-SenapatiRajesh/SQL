use aircargo;
##Create an ER diagram for the given airlines database.
##Write a query to create route_details table using suitable data types for the fields, such as route_id, flight_num, origin_airport, destination_airport, aircraft_id, and distance_miles. Implement the check constraint for the flight number and unique constraint for the route_id fields. Also, make sure that the distance miles field is greater than 0.
show tables;
#Write a query to display all the passengers (customers) who have travelled in routes 01 to 25. Take data  from the passengers_on_flights table.
select count(*) from passengers_on_flights where route_id between 1 and 25 order by route_id,customer_id;

##4.Write a query to identify the number of passengers and total revenue in business class from the ticket_details table.
select * from ticket_details;
select count(*) as number_of_passengers,sum(Price_per_ticket) as total_revenue from ticket_details where class_id="Bussiness";

##5.Write a query to display the full name of the customer by extracting the first name and last name from the customer table.
select concat(first_name,' ',last_name) as 'full name' from customer;
select * from customer;

##6.Write a query to extract the customers who have registered and booked a ticket. Use data from the customer and ticket_details tables.
select * from customer c where c.customer_id in (select distinct customer_id from ticket_details) order by customer_id;

##7.Write a query to identify the customer’s first name and last name based on their customer ID and brand (Emirates) from the ticket_details table.
select c.customer_id,c.first_name,c.last_name from customer c where exists(select 1 from ticket_details t where t.customer_id=c.customer_id and brand="Emirates");

##8.Write a query to identify the customers who have travelled by Economy Plus class using Group By and Having clause on the passengers_on_flights table.
select * from passengers_on_flights;
select * from passengers_on_flights group by customer_id having class_id="Economy Plus" order by customer_id;

##9.Write a query to identify whether the revenue has crossed 10000 using the IF clause on the ticket_details table.
select * from ticket_details;
select if(sum(no_of_tickets*Price_per_ticket)>10000,
'Yes, Revenue crossed 10000','No revenue has not crossed 10000') as results from ticket_details;


##10.Write a query to create and grant access to a new user to perform operations on a database.
create user 'aircargouser' @ 'localhost' identified by '<password>';
grant all privileges on aircargo.* to 'aircargouser' @ 'localhost';

##11.Write a query to find the maximum ticket price for each class using window functions on the ticket_details table.
select class_id,Price_per_ticket,max(Price_per_ticket) over(partition by class_id) as max_ticket_price from ticket_details;

##12.Write a query to extract the passengers whose route ID is 4 by improving the speed and performance of the passengers_on_flights table.
create index route_id_search on passengers_on_flights(route_id);
select * from passengers_on_flights where route_id=4;

##13.For the route ID 4, write a query to view the execution plan of the passengers_on_flights table.
explain analyze select * from passengers_on_flights where route_id=4;

##14.Write a query to calculate the total price of all tickets booked by a customer across different aircraft IDs using rollup function.
select customer_id,aircraft_id,sum(no_of_tickets*Price_per_ticket) as 'Total price' from ticket_details 
group by customer_id,aircraft_id with rollup;

##15.Write a query to create a view with only business class customers along with the brand of airlines.
create view Bussiness_class_customers as select * from ticket_details where class_id="Bussiness";
select * from Bussiness_class_customers;

##16.Write a query to create a stored procedure to get the details of all passengers flying between a range of routes defined in run time. Also, return an error message if the table doesn't exist.
CREATE DEFINER=`root`@`localhost` PROCEDURE `Pasenger_by_routes`(in p_from_route_id int,in p_to_route_id int, out o_msg varchar(100))
USE `aircargo`;
DROP procedure IF EXISTS `Pasenger_by_routes`;

USE `aircargo`;
DROP procedure IF EXISTS `aircargo`.`Pasenger_by_routes`;
;

DELIMITER $$
USE `aircargo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Pasenger_by_routes`(in p_from_route_id int,in p_to_route_id int)
BEGIN
select c.customer_id,c.first_name,c.last_name,f.route_id 
from passengers_on_flights f inner join customer c on c.customer_id=f.customer_id where f.route_id 
between p_from_route_id and p_to_route_id order by route_id;
END$$

DELIMITER ;
;

call Pasenger_by_routes(10,20);


call Pasenger_by_routes(15,25);

##17.Write a query to create a stored procedure that extracts all the details from the routes table where the travelled distance is more than 2000 miles.
call route_morethan_2000miles();

##18.Write a query to create a stored procedure that groups the distance travelled by each flight into three categories. The categories are, short distance travel (SDT) for >=0 AND <= 2000 miles, intermediate distance travel (IDT) for >2000 AND <=6500, and long-distance travel (LDT) for >6500.
USE `aircargo`;
DROP procedure IF EXISTS `Desc_by_distance`;

DELIMITER $$
USE `aircargo`$$
CREATE PROCEDURE `Desc_by_distance` ()
BEGIN
select flight_num,
case
	when sum(distance_miles) <=2000  then "SDT"
    when sum(distance_miles) <=6500  then "IDT"
    when sum(distance_miles)>6500  then "LDT" end as Distance_description 
from routes group by flight_num;
END$$

DELIMITER ;

call Desc_by_distance();

##19.Write a query to extract ticket purchase date, customer ID, class ID and specify if the complimentary services are provided for the specific class using a stored function in stored procedure on the ticket_details table.
select p_date,customer_id,class_id,getCompservice(class_id) from ticket_details;
select * from ticket_details;

##20.Write a query to extract the first record of the customer whose last name ends with Scott using a cursor from the customer table.
select * from customer;
call getCustName();


