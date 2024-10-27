create database SQL_Library_Project;

-- Creating the tables

drop table if exists branch;
create table branch (
	branch_id varchar(10) primary key,
    manager_id varchar(10),
    branch_address varchar(55),
    contact_no varchar(15)
);

drop table if exists employees;
create table employees (
	emp_id varchar(10) primary key,
    emp_name varchar(25),
    position varchar(25),	
    salary int,
    branch_id varchar(25) -- Foreing Key
); 

drop table if exists books;
create table books (
	isbn varchar(25) primary key,
    book_title varchar(55),
    category varchar(25),
    rental_price float,
    status varchar(15),
    author varchar(45),
    publisher varchar(55)
);

drop table if exists members;
create table members (
	member_id varchar(10) primary key,
    member_name	varchar(25),
    member_address varchar(100),
    reg_date date
);

drop table if exists issues_status;
create table issues_status (
	issued_id varchar(10) primary key,
    issued_member_id varchar(10), -- Foreign Key
    issued_book_name varchar(75),
    issued_date date,
    issued_book_isbn varchar(25), -- Foreign Key
    issued_emp_id varchar(10) -- Foreign Key
);

drop table if exists return_status;
create table return_status (
	return_id varchar(10) primary key,
    issued_id varchar(10), -- Foreign Key
    return_book_name varchar(75),
    return_date	date,
    return_book_isbn varchar(25),
    FOREIGN KEY (issued_id) REFERENCES issues_status(issued_id)
);

select * from return_status;

-- Foreing Key
alter table issues_status
add constraint fk_members
foreign key (issued_member_id)
references members(member_id);

alter table issues_status
add constraint fk_books
foreign key (issued_book_isbn)
references books(isbn);

alter table issues_status
add constraint fk_emp
foreign key (issued_emp_id)
references employees(emp_id);

alter table employees
add constraint fk_branch
foreign key (branch_id)
references branch(branch_id);

