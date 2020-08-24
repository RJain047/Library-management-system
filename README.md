# Library-management-system
The Domain being modelled is a library management system. The database is designed to save information on the books inventory, books issued, books returned, authors of books, library staff and the member of the library. The database is built using MySQL workbench which will be working on the backend of the application program built using python with an extensive use of flask package. The application programmed to work on the database has functionalities that aims to support the roles of a librarian as well as assisting library members by providing six functionalities. Firstly, insert a book in the inventory, allowing the library staff to add a new book in the book inventory. Secondly, update a book in the inventory, allowing the library staff to change the book information in the book inventory. Thirdly, search books in the library, allowing the library staff and members to search for all books in the library system based on book name, author, or all. Fourthly, delete a book in the book inventory, this functionality allows the library staff to delete a book from the book inventory as it is needed in case the book is lost. Fifthly, the library staff will be able to view the number of books available in the inventory and the number of books issued. Sixthly, the library admin will be able to search for privileges for each user by their user id , login id or by selecting all as an option in the system .

Info-
App.py contains the python code.
The application connects with Mysql database which is created using librarydatabase.sql.
Post executing the code the site is available at localhost ip address 127.0.0.1

##Functionalities are as follows
A.	Select – the search form performs the function of selecting available books in the inventory. The form allows the user to enter a book name or author name or all for searching for all available books in the inventory. Use http://127.0.0.1:5000/search to explore this functionality.


![1](https://user-images.githubusercontent.com/62599559/91018674-39765b80-e633-11ea-81f1-d4b497ae5d00.png)



 
There are 2 sql queries that get executed depending on user input.

A.1 Selecting book using book name or author name where %s is author name or book name
SELECT Book_name,Book_author from library.book_inventory WHERE Book_name LIKE %s OR Book_author LIKE %s 

Search by book name
![2](https://user-images.githubusercontent.com/62599559/91018676-3a0ef200-e633-11ea-955e-9714a9a4dceb.png)

 

Search by author name
 
![3](https://user-images.githubusercontent.com/62599559/91018679-3a0ef200-e633-11ea-9885-37c7c0a4bd0f.png)



A.2For selecting all books in the inventory,
SELECT Book_name,Book_author from library.book_inventory
![4](https://user-images.githubusercontent.com/62599559/91018680-3aa78880-e633-11ea-8ff1-a138f5859c7f.png)


 


B.	Update – the update form performs the function of updating the book details i.e. book name and author name and year of publication. This form navigates to a edit page post entering the author name , book name or all if all the books need to be  viewed for updating. Use http://127.0.0.1:5000/update to explore this option.
The sql queries executed for this areas shown below where -
SELECT * from library.book_inventory WHERE Book_name LIKE %s OR Book_author LIKE %s"
SELECT * from library.book_inventory
SELECT * from library.book_inventory WHERE Book_id = %s
UPDATE book_inventory set Book_author=%s,Book_name=%s,year_of_publication=%s where Book_id=%s


Forms used for update-for searching the book that needs to be updated.
 ![5](https://user-images.githubusercontent.com/62599559/91018684-3b401f00-e633-11ea-84e9-f0996e6e62f9.png)

After entering all in the search box-
![6](https://user-images.githubusercontent.com/62599559/91018685-3bd8b580-e633-11ea-966a-87b88887bedb.png)

 

After clicking edit corresponding to the book.
![7](https://user-images.githubusercontent.com/62599559/91018687-3bd8b580-e633-11ea-8c85-9b252701ed11.png)

 

Enter new values and click update.



C.	Delete – this function allows the library staff to delete a book from the book inventory. In case of a missing book the library no longer keeps the information in the system. On the form enter the book name or author name and select the corresponding option from the drop down and click delete. Use http://127.0.0.1:5000/delete to explore this option

Following 2 commands delete the bok by book name or author %s is for the book name that is to be deleted . 
DELETE FROM book_inventory WHERE Book_author = %s

DELETE FROM book_inventory WHERE Book_name = %s
![8](https://user-images.githubusercontent.com/62599559/91018688-3c714c00-e633-11ea-8cf8-de279ad5b155.png)

 
D.	Insert – this form allows the user to insert  a book in the book inventory table.the page takes 3 inputs from the user book name , author and year of publication. Queries used for this page is where uuid is a random generator for ISBN number and % s are the name of the books ,author and year of publication.
   
INSERT INTO book_inventory (category_id,Book_author,Book_name,year_of_publication,ISBN,available_ind) Values (5,%s, %s,%s,uuid(),1)
 ![9](https://user-images.githubusercontent.com/62599559/91018672-38452e80-e633-11ea-853c-87dc98daa38f.png)
            

