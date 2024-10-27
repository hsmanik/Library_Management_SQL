-- Library management system part 2
-- Adding some new columns

INSERT INTO issues_status(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
VALUES
('IS151', 'C118', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL 24 day,  '978-0-553-29698-2', 'E108'),
('IS152', 'C119', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL 13 day,  '978-0-553-29698-2', 'E109'),
('IS153', 'C106', 'Pride and Prejudice', CURRENT_DATE - INTERVAL 7 day,  '978-0-14-143951-8', 'E107'),
('IS154', 'C105', 'The Road', CURRENT_DATE - INTERVAL 32 day,  '978-0-375-50167-0', 'E101');

-- Adding new column in return_status

ALTER TABLE return_status
ADD Column book_quality VARCHAR(15) DEFAULT('Good');

UPDATE return_status
SET book_quality = 'Damaged'
WHERE issued_id 
    IN ('IS112', 'IS117', 'IS118');
SELECT * FROM return_status;


select * from books;
select * from issues_status;
select * from branch;
select * from members;
select * from return_status; 


-- Task 13 : Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period).
-- Display the member's_id, member's name, book title, issue date, and days overdue.

select i.issued_member_id, m.member_name, i.issued_book_name, i.issued_date, r.return_date,
	DATEDIFF( CURRENT_DATE() , i.issued_date) as over_due_date
from issues_status i
join members m on i.issued_member_id = m.member_id
left join return_status r on r.issued_id = i.issued_id
where r.return_date is null and DATEDIFF( CURRENT_DATE() , i.issued_date) > 30
order by 1;


-- Task 14: Update Book Status on Return
-- Write a query to update the status of books in the books table to "Yes",
-- when they are returned (based on entries in the return_status table).

select * from books
where isbn = '978-0-451-52994-2';

-- stored procedures
delimiter $$
create procedure add_return_records(return_id_p VARCHAR(10), issued_id_p VARCHAR(10), book_quality_p VARCHAR(15))
begin
	declare v_isbn varchar(50);
    declare v_book_name varchar(80);
	-- inserting into return_status based on input
	insert into return_status(return_id, issued_id, return_date, book_quality)
    values(return_id_p,issued_id_p,current_date(), book_quality_p);
    
    -- retrieving the book isbn
    select issued_book_isbn,issued_book_name into v_isbn,v_book_name from issues_status where issued_id = issued_id_p;
    
    -- updating the status to yes in books table
    update books
    set status = 'yes'
    where isbn = v_isbn;
    
    -- output a mesage
    SELECT CONCAT('Thank you for returning the book: ', v_book_name) AS return_message;
	
end$$
delimiter ;

-- testing the procedure
SELECT * FROM books
WHERE isbn = '978-0-307-58837-1';

SELECT * FROM issues_status
WHERE issued_book_isbn = '978-0-307-58837-1';

SELECT * FROM return_status
WHERE issued_id = 'IS135';

CALL add_return_records('RS138', 'IS135', 'Good');


-- Task 15: Branch Performance Report
-- Create a query that generates a performance report for each branch,
-- showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

select * from books;
select * from return_status;


select b.branch_id, b.manager_id,
	count(i.issued_id) as number_of_books_issued, 
    count(rs.return_id) as number_of_books_returned,
	sum(bk.rental_price) as total_revenue
from employees e
join issues_status i on e.emp_id = i.issued_emp_id
join branch b on b.branch_id = e.branch_id
left join return_status rs on rs.issued_id = i.issued_id
join books bk on bk.isbn = i.issued_book_isbn
group by 1,2;


-- Task 16: View: Create a View of Active Members
-- Use View statement to view the active_members 
-- containing members who have issued at least one book in the last 3 months.

CREATE VIEW active_members_last_90_days AS
select * from members where member_id in (
select distinct issued_member_id
from issues_status
where issued_date >= current_date() - interval 90 day);

select * from active_members_last_90_days;


-- Task 17: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. 
-- Display the employee name, number of books processed, and their branch.

select e.emp_name, e.branch_id ,count(i.issued_id) as books_issues
from employees e
join issues_status i on e.emp_id = i.issued_emp_id
group by 1, 2
order by 3 desc
limit 3;

-- Task 18: Identify Members Issuing High-Risk Books
-- Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. 
-- Display the member name, book title, and the number of times they've issued damaged books.

select m.member_name, i.issued_book_name, COUNT(*) AS times_issued_damaged
from members m
join issues_status i on m.member_id = i.issued_member_id
join return_status rs on rs.issued_id = i.issued_id
where rs.book_quality = 'Damaged'
GROUP BY m.member_name, i.issued_book_name;
-- having count(*) > 2; this will print null because nobody issued the damaged books twice
