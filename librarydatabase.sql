Drop database Library;
----------------------------------
Create database  Library;
----------------------------------
use Library;
----------------------------------

-- creating users table
create table roles(
role_id int not null auto_increment,
role_name varchar(20) not null,
role_description varchar(30) not null,
CONSTRAINT role_id PRIMARY KEY (role_id)
);
----------------------------------
-- inserting into roles table
insert into roles values(1,"staff","employees");
insert into roles values(2,"member","library members");
----------------------------------
-- creating users table
create table Users(
User_Id int  not null AUTO_INCREMENT  ,
role_id int not null,
User_name varchar(25) not null,
date_of_birth date not null,
email_id varchar(40) not null unique,
phone_num int not null unique,
address varchar(500) not null ,
Joined_on date not null,
login_name varchar(20) not null unique,
user_password varchar(10) not null,
CONSTRAINT user_id_pk PRIMARY KEY (User_Id), 
FOREIGN KEY (role_id) REFERENCES roles(role_id) on delete cascade
);
----------------------------------
-- inserting into users table
insert into Users values(1, 1, "Cassidy", "2000-01-22","Cassidy@yahoo.com",123456789,  "St Lucia QLD 4072, Australia",  "2000-01-22",  "cassidy", "123456");
insert into Users values(2,  2,"Gordon","2000-01-22","Gordon@yahoo.com",12345089,  "St Lucia QLD 4072, Australia",  "2000-01-22",  "gordon", "123456");
insert into Users values(3,  2,"Rebecca","2000-01-22","Rebecca@yahoo.com",156753589,  "St Lucia QLD 4072, Australia",  "2000-01-22",  "rebecca", "123456");
insert into Users values(4,  2,"Vivienne",  "2000-01-22","Vivienne@yahoo.com",154566449,  "St Lucia QLD 4072, Australia",  "2000-01-22",  "vivienne", "123456");
insert into Users values(5,  2,"Melvin", "2000-01-22","Melvin@yahoo.com",123467449,  "St Lucia QLD 4072, Australia",  "2000-01-22",  "melvin", "123456");
----------------------------------

-- creating privilege table
create table privilege(
privilege_id int not null ,
privilege_type varchar(20) not null,
role_id int not null,
CONSTRAINT privilege_id_pk PRIMARY KEY (privilege_id,role_id),
FOREIGN KEY (role_id) REFERENCES roles(role_id) on delete cascade
);
----------------------------------
-- inserting into privilege table
insert into privilege values(1,"browse",1);
insert into privilege values(2,"update",2);
insert into privilege values(3,"insert",2);
insert into privilege values(4,"delete",2);
insert into privilege values(5,"browse",2);
----------------------------------

-- Creating staff table
create table Staff(
user_id int not null   ,
prior_experience int not null,
CONSTRAINT staff_user_id_pk PRIMARY KEY (user_id),
FOREIGN KEY (user_id) REFERENCES Users(User_id) on delete cascade
);
----------------------------------
-- inserting into staff table
insert into staff values(1,5);
insert into staff values(2,5);
insert into staff values(3,5);
insert into staff values(4,5);
insert into staff values(5,5);
----------------------------------
-- Creating library_member table
create table library_member(
user_id int not null   ,
organization_name varchar(30) not null,
CONSTRAINT library_id_pk PRIMARY KEY (user_id),
FOREIGN KEY (user_id) REFERENCES users(user_id) on delete cascade
);
----------------------------------
-- inserting into library_member table
insert into library_member values(1,"uq");
insert into library_member values(2,"uq");
insert into library_member values(3,"uq");
insert into library_member values(4,"uq");
insert into library_member values(5,"uq");
----------------------------------
-- creating category table
create table category(
category_id int not null AUTO_INCREMENT  ,
category_name varchar(30) not null,
CONSTRAINT category_id_pk PRIMARY KEY (category_id)
);
----------------------------------
-- inserting into category table
insert into category values(1,"Fiction");
insert into category values(2,"Literature");
insert into category values(3,"Art");
insert into category values(4,"Biograpghy");
insert into category values(5,"Science");
----------------------------------
-- creating books table
create table book_inventory(
Book_id int not null AUTO_INCREMENT  ,
category_id int not null,
Book_author varchar(30) not null,
Book_name varchar(50) not null,
year_of_publication year not null,
ISBN varchar(100) not null unique,
available_ind bit,
CONSTRAINT book_id_pk PRIMARY KEY (book_id),
FOREIGN KEY (category_id) REFERENCES category(category_id)
);
----------------------------------
-- inserting into book_inventory
insert into book_inventory values (1,1,"George Orwell","Nineteen Eighty-Four",1949,1234,1);
insert into book_inventory values (2,2," F. Scott Fitzgerald","The Great Gatsby",1925,2345,1);
insert into book_inventory values (3,3,"Reuben Fowkes","Central and Eastern European Art Since 1950",2020,4567,1);
insert into book_inventory values (4,4,"Michelle Obama","Becoming",2018,5678,1);
insert into book_inventory values (5,5,"Stephen Hawking","A Brief History of Time",1988,2245,1);
----------------------------------

-- creating book_issue table
create table books_issue(
Book_issue_id int not null AUTO_INCREMENT,
book_id int not null,
user_id int not null,
date_of_issue datetime not null,
due_date datetime not null,
date_of_return datetime,
CONSTRAINT book_issue_id_pk PRIMARY KEY (book_issue_id),
FOREIGN KEY (book_id) REFERENCES book_inventory(book_id),
FOREIGN KEY (user_id) REFERENCES users(user_id)
);

----------------------------------
-- inserting into book issue
insert into books_issue values(1,1,1,"2019-02-22","2019-02-23","2019-02-23");
insert into books_issue values(2,2,1,"2019-02-22","2019-02-23","2019-02-23");
insert into books_issue values(3,3,1,"2019-02-22","2019-02-23","2019-02-23");
insert into books_issue values(4,4,1,"2019-02-22","2019-02-23","2019-02-23");
insert into books_issue values(6,5,1,"2019-02-22","2019-02-23",null);
----------------------------------
select * from book_inventory;
select * from books_issue;
select * from roles;
select * from users;
select * from privilege;
select * from category;
select * from staff;
select * from library_member;

use Library;


SELECT count(available_ind) AS Books_available from library.book_inventory where  available_ind="1";
SELECT count(available_ind) AS Books_issued from library.book_inventory where  available_ind="0";



select u.user_id ,u.user_name,r.role_name,
 GROUP_CONCAT(DISTINCT p.privilege_type SEPARATOR ",") as priviledge_type from users u join privilege p on u.role_id =p.role_id
 join roles r on r.role_id = u.role_id where u.user_id =1;
 
 select u.user_id ,u.user_name,r.role_name,
 GROUP_CONCAT(DISTINCT p.privilege_type SEPARATOR ",") as priviledge_type from users u join privilege p on u.role_id =p.role_id
 join roles r on r.role_id = u.role_id where u.login_name ="Gordon";
 
 select u.user_id ,u.user_name,r.role_name,
 GROUP_CONCAT(DISTINCT p.privilege_type SEPARATOR ",") as priviledge_type from users u join privilege p on u.role_id =p.role_id
 join roles r on r.role_id = u.role_id
 GROUP BY u.user_id;
 
 

