create database library;
use library;
create table branch(Branch_no int primary key not null, Manager_Id int, Branch_address varchar(30) not null, contact_no varchar(15)); 

create table Employee(Emp_Id int primary key not null, Emp_name varchar(25) not null, Position varchar(25), Salary int not null, 
Branch_no int, foreign key (Branch_no) references branch (Branch_no));

create table Book(ISBN int primary key, Book_title varchar(50) not null, Category varchar(50), Rental_Price int not null,
Status boolean, Author varchar(50), Publisher varchar(50));

create table Customer(Customer_Id int primary key not null, Customer_name varchar(50) not null, 
Customer_address varchar(50) not null, Reg_date date); 

create table IssueStatus(Issue_Id int primary key not null, 
Issued_cust int, foreign key(Issued_cust) references Customer (Customer_Id),
Issued_book_name varchar(50) not null, Issue_date date, 
Isbn_book int, foreign key(Isbn_book) references Book(ISBN));

create table ReturnStatus(Return_Id int primary key not null, Return_cust varchar(50), Return_book_name varchar(100), 
Return_date date, Isbn_book2 int, foreign key(Isbn_book2) references Book(ISBN));

insert into branch(Branch_no, Manager_Id, Branch_address, contact_no) values 
(1, 101, '123 Main St, Anytown, USA', '555-1234'),
(2, 102, '456 Oak Ave, Another City, USA', '555-5678'),
(3, 103, '789 Elm Rd, Somewhere Else, USA', '555-9876');

insert into Employee(Emp_Id, Emp_name, Position, Salary, Branch_no) values 
(1, 'John Doe', 'Manager', 60000.00, 1),
(2, 'Jane Smith', 'Assistant Manager', 50000.00, 2),
(3, 'Michael Johnson', 'Sales Associate', 40000.00, 1),
(4, 'Emily Davis', 'Clerk', 35000.00, 3);


insert into Book(ISBN, Book_title, Category, Rental_Price, Status, Author, Publisher) values
('1234', 'SQL Fundamentals', 'Programming', 10.99, 'yes', 'John Smith', 'Tech Books Inc.'),
('5432', 'Python for Beginners', 'Programming', 12.50, 'yes', 'Jane Doe', 'Coding Press'),
('8765', 'Data Science Essentials', 'Data Science', 15.75, 'no', 'Michael Johnson', 'Data Books LLC');

insert into Customer(Customer_Id, Customer_name, Customer_address, Reg_date) values
(1, 'Alice Brown', '123 Elm St, Anytown, USA', '2023-01-15'),
(2, 'Bob Smith', '456 Oak Ave, Another City, USA', '2023-02-20'),
(3, 'Charlie Green', '789 Maple Dr, Somewhere Else, USA', '2023-03-25');

insert into IssueStatus (Issue_Id, Issued_cust, Issued_book_name, Issue_date, Isbn_book) values
(1, 1, 'SQL Fundamentals', '2023-04-01', '1234'),
(2, 2, 'Python for Beginners', '2023-04-05', '5432'),
(3, 3, 'Data Science Essentials', '2023-04-10', '8765');

insert into ReturnStatus(Return_Id, Return_cust, Return_book_name, Return_date, Isbn_book2) values
(1, 1, 'SQL Fundamentals', '2023-04-10', '1234'),
(2, 2, 'Python for Beginners', '2023-04-15', '5432'),
(3, 3, 'Data Science Essentials', '2023-04-20', '8765');

select * from branch;

select * from Employee;

select * from Book;

select * from Customer;

select * from IssueStatus;

select * from ReturnStatus;

-- 1. Retrieve the book title, category, and rental price of all available books. 
select Book_title, Category, Rental_Price from Book where Status = 'yes';

-- 2. List the employee names and their respective salaries in descending order of salary. 
select Emp_name, Salary from Employee order by Salary desc;

-- 3. Retrieve the book titles and the corresponding customers who have issued those books. 
select i.Issued_book_name, c.Customer_name from IssueStatus i 
inner join Customer c on i.Issued_cust = c.Customer_Id;

-- 4. Display the total count of books in each category. 
select Category, count(Category) from Book group by Category;

-- 5. Retrieve the employee names and their positions for the employees whose salaries are above Rs.50,000. 
select Emp_name, Position from Employee where Salary >= '50000';

-- 6. List the customer names who registered before 2022-01-01 and have not issued any books yet.
select Customer_name from Customer where Reg_date > '2022-01-01' and 
Customer_Id not in (select Issued_cust from IssueStatus);

-- 7. Display the branch numbers and the total count of employees in each branch. 
select Branch_no, count(Branch_no) no_employees from Employee group by Branch_no;

-- 8. Display the names of customers who have issued books in the month of June 2023.
select Customer_name from Customer where Customer_Id in 
(select Issued_cust from IssueStatus where Issue_date between '2023-06-01' and '2023-06-31');

-- 9. Retrieve book_title from book table containing history. 
select Book_title from Book where ISBN in (select Isbn_book2 from ReturnStatus);

-- 10.Retrieve the branch numbers along with the count of employees for branches having more than 5 employees
select b.Branch_no, count(Emp_name) Empolyee_Count from Employee E 
inner join branch b on E.Branch_no = b.Branch_no group by E.Branch_no having count(E.Emp_name)>5;

-- 11. Retrieve the names of employees who manage branches and their respective branch addresses.
select E.Emp_name, b.Branch_address from Employee E 
inner join branch b on E.Branch_no = b.Branch_no;

-- 12.  Display the names of customers who have issued books with a rental price higher than Rs. 25.
select C.Customer_name from Customer C 
inner join IssueStatus I on C.Customer_Id = I.Issued_cust where I.Isbn_book in 
(select ISBN from Book where Rental_Price > 25);
