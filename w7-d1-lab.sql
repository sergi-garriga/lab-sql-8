use sakila;



-- Rank films by length (filter out the rows with nulls or zeros in length column). 
-- Select only columns title, length and rank in your output.
select title, length, 
rank() over(order by length desc) as 'rank by length' 
from film 
where length <> " " or length is not null or length <> 0;



-- Rank films by length within the rating category (filter out the rows with nulls 
-- or zeros in length column). In your output, only select the columns title, length, 
-- rating and rank.
select * from film;

select title, length, rating,
rank() over(partition by rating order by length desc) as 'rank by length'
from film
where length <> " " or length is not null or length <> 0;



-- How many films are there for each of the categories in the category table? 
-- Hint: Use appropriate join between the tables "category" and "film_category".
select * from film_category; -- fc Table A
select * from category; -- c Table B
		-- SELECT TableA.MyColumn, COUNT(TableB.SomeColumn) AS MyCount
		-- FROM TableA
		-- LEFT OUTER JOIN TableB ON TableA.TableAKeyColumn = TableB.TableAKeyColumn
		-- GROUP BY TableA.MyColumn

select count(fc.film_id) as 'films count', fc.category_id, c.name
from film_category fc
left outer join category c on fc.category_id = c.category_id
group by category_id;



-- Which actor has appeared in the most films? Hint: You can create a join 
-- between the tables "actor" and "film actor" and count the number of times 
-- an actor appears.
select * from film_actor; -- fa Table A
select * from actor; -- a Table B
		-- SELECT TableA.MyColumn, COUNT(TableB.SomeColumn) AS MyCount
		-- FROM TableA
		-- LEFT OUTER JOIN TableB ON TableA.TableAKeyColumn = TableB.TableAKeyColumn
		-- GROUP BY TableA.MyColumn

select fa.actor_id, count(fa.film_id) 'film count',  a.first_name, a.last_name
from film_actor fa
left outer join actor a on fa.actor_id = a.actor_id
group by actor_id;
-- I add the acting rank.
select fa.actor_id, count(fa.film_id) 'film count',  a.first_name, a.last_name, rank() over(order by count(fa.film_id) desc) 'acting rank'
from film_actor fa
left outer join actor a on fa.actor_id = a.actor_id
group by actor_id;



-- Which is the most active customer (the customer that has rented the most number
-- of films)? Hint: Use appropriate join between the tables "customer" and "rental"
-- and count the rental_id for each customer.
select * from rental; -- r Table A
select * from customer; -- c Table B
		-- SELECT TableA.MyColumn, COUNT(TableB.SomeColumn) AS MyCount
		-- FROM TableA
		-- LEFT OUTER JOIN TableB ON TableA.TableAKeyColumn = TableB.TableAKeyColumn
		-- GROUP BY TableA.MyColumn

select r.customer_id, count(r.rental_id), c.first_name, c.last_name, rank() over(order by count(r.rental_id) desc) 'active customer rank'
from rental r
left outer join customer c on r.customer_id = c.customer_id
group by customer_id
limit 1;



-- Bonus: Which is the most rented film? (The answer is Bucket Brotherhood).
-- This query might require using more than one join statement. Give it a try. We will talk about queries with multiple
-- join statements later in the lessons.
-- Hint: You can use join between three tables - "Film", "Inventory", and "Rental" and count the rental ids for each film.
select * from rental; -- r Table A
select * from inventory; -- i Table B
select * from film; -- f Table C

select count(r.rental_id) 'rental count', f.title, rank() over(order by count(r.rental_id) desc) as 'rental ranking'
from rental r
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
group by title;


