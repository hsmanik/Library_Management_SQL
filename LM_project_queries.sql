select * from books;
select * from branch;
select * from employees;
select * from members;
select * from issues_status;
select * from return_status;

-- CRUD operations
-- Create: Inserted sample records into the books table.
-- Read: Retrieved and displayed data from various tables.
-- Update: Updated records in the employees table.
-- Delete: Removed records from the members table as needed.

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
insert into books(isbn, book_title, category, rental_price, status, author, publisher)
values ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
select * from books;

-- Task 2: Update an Existing Member's Address
update members
set member_address = '125 Main St'
where member_id = 'C101';
select * from members;

-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
delete from issues_status where issued_id = 'IS121';
select * from issues_status;
select * from issues_status where issued_id = 'IS121';

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
select * from issues_status where issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
select issued_emp_id, count(*) as 'total_books'
from issues_status
group by issued_emp_id
having count(*) > 1;

-- CTAS (create table as select)
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
create table book_counts
as
select b.isbn, b.book_title  ,count(*) as 'number_issues'
from books b
join issues_status ist on b.isbn = ist.issued_book_isbn
group by 1, 2;

select * from book_counts;


-- Data Analysis & Findings
-- Retrieve All Books in a Specific Category 'Classic'
select * from books where category = 'Classic';

-- Task 8: Find Total Rental Income by Category
select b.category, sum(b.rental_price) as 'Total_Price', count(*) as 'count'
from books b
join issues_status ist on b.isbn = ist.issued_book_isbn
group by 1;

-- Task 9: List Members Who Registered in the Last 180 Days
select * from members
where reg_date >= '2024-05-10' - interval 180 day;

-- Task 10 : List Employees with Their Branch Manager's Name and their branch details
select e.emp_id, e.emp_name, e2.emp_name as 'manager_name' , br.branch_address, br.contact_no
from employees e
left join branch br on e.branch_id = br.branch_id
join employees e2
on br.manager_id = e2.emp_id;

-- Task 11: Create a Table of Books with Rental Price Above a Certain Threshold
-- create table books_threshold
-- as
select * from books
where rental_price > 7;

-- Task 12: Retrieve the List of Books Not Yet Returned
select * 
from issues_status ist
left join return_status rs on ist.issued_id = rs.issued_id
where rs.return_id is null;


