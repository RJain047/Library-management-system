import flask_mysqldb
from flask import Flask, render_template, request, redirect, url_for, session
import pandas as pd


from flask import Flask, render_template, request
from flask_mysqldb import MySQL
app = Flask(__name__)
app.secret_key = "super secret key"

app.config['MYSQL_HOST'] = '127.0.0.1'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = '123qaz'
app.config['MYSQL_DB'] = 'Library'
app.config['MYSQL_CURSORCLASS']='DictCursor'

mysql = MySQL(app)


# http://localhost:5000/login/ - this will be the login page, we need to use both GET and POST requests
@app.route('/login/', methods=['GET', 'POST'])
def login():
    # Output message if something goes wrong...
    msg = ''
    # Check if "username" and "password" POST requests exist (user submitted form)
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
        # Create variables for easy access
        username = request.form['username']
        password = request.form['password']
        # Check if account exists using MySQL
        cursor = mysql.connection.cursor()
        cursor.execute('SELECT * FROM users WHERE login_name = %s AND user_password = %s', (username, password,))
        # Fetch one record and return result
        account = cursor.fetchone()
         # If account exists in accounts table in out database
        if account:
            # Create session data, we can access this data in other routes
            session['loggedin'] = True
            session['id'] = account['User_Id']
            session['username'] = account['login_name']
            # Redirect to home page
            return redirect(url_for('home'))
        else:
            # Account doesnt exist or username/password incorrect
            msg = 'Incorrect username/password!'
    return render_template('index.html', msg=msg)

# http://localhost:5000/logout - this will be the logout page
@app.route('/logout/')
def logout():
    # Remove session data, this will log the user out
   session.pop('loggedin', None)
   session.pop('id', None)
   session.pop('username', None)
   # Redirect to login page
   return redirect(url_for('login'))


# http://localhost:5000/home - this will be the home page, only accessible for loggedin users
@app.route('/home')
def home():
    # Check if user is loggedin
    if 'loggedin' in session:
        # User is loggedin show them the home page
        return render_template('home.html', username=session['username'])
    # User is not loggedin redirect to login page
    return redirect(url_for('login'))

# http://localhost:5000/profile - this will be the profile page, only accessible for loggedin users
@app.route('/profile')
def profile():
    # Check if user is loggedin
    if 'loggedin' in session:
        # We need all the account info for the user so we can display it on the profile page
        cursor = mysql.connection.cursor()
        cursor.execute('SELECT * FROM users WHERE login_name = %s', (session['username'],))
        account = cursor.fetchone()
        # Show the profile page with account info
        return render_template('profile.html', account=account)
    # User is not loggedin redirect to login page
    return redirect(url_for('login'))

#endpoint for search
@app.route('/search', methods=['GET', 'POST'])
def search():
    if request.method == "POST":
        cursor = mysql.connection.cursor()
        #conn = mysql.connect()
        book = request.form['book']
        # search by author or book
        cursor.execute("SELECT Book_name,Book_author from library.book_inventory WHERE Book_name LIKE %s OR Book_author LIKE %s", (book, book))
        #conn.commit()
        data = cursor.fetchall()
        # all in the search box will return all the tuples
        if len(data) == 0 and book == 'all': 
            cursor.execute("SELECT Book_name,Book_author from library.book_inventory")
            #conn.commit()
            data = cursor.fetchall()
            print(data)
        return render_template('search.html', data=data)
    return render_template('search.html')

# end point for inserting data dynamicaly in the database
@app.route('/insert', methods=['GET', 'POST'])
def insert():
    msg = ''
    if request.method == "POST":
        cursor = mysql.connection.cursor()
        book = request.form['book']
        author = request.form['author']
        year = request.form['year']
        cursor.execute('SELECT * FROM book_inventory WHERE Book_name = %s', (book,))
        inventory = cursor.fetchone()
        print(inventory)
         # If inventory exists in books_inventory table in our database
        if inventory:
             msg = 'Book already exists!'
        else:
            cursor.execute("INSERT INTO book_inventory (category_id,Book_author,Book_name,year_of_publication,ISBN) Values (5,%s, %s,%s,uuid())", (book, author,year))
            
            mysql.connection.commit()
            msg='Book added to the Inventory!'
    
    return render_template('insert.html',msg=msg)
    #return redirect("http://localhost:5000/search")

# end point for inserting data dynamicaly in the database
@app.route('/delete', methods=['GET', 'POST'])
def delete():
    msg = ''
    if request.method == "POST":
        cursor = mysql.connection.cursor()
        name = request.form['name']
        select = request.form.get('selectType')
        cursor.execute("SELECT * from book_inventory WHERE Book_name LIKE %s OR Book_author LIKE %s", (name, name))
        data = cursor.fetchall()
        # all in the search box will return all the tuples
        if len(data) == 0:
             msg = select +' does not exists!'
        elif select=="Author":
            cursor.execute('DELETE FROM book_inventory WHERE Book_author = %s', (name,))
            mysql.connection.commit()
            msg = 'Deleted Sucessfully!'
        else:
            cursor.execute('DELETE FROM book_inventory WHERE Book_name = %s', (name,))
            mysql.connection.commit()
            msg = 'Deleted Sucessfully!'

    return render_template('delete.html',msg=msg)
    #return redirect("http://localhost:5000/search")

#endpoint for search
@app.route('/update', methods=['GET', 'POST'])
def update():
    if request.method == "POST":
        cursor = mysql.connection.cursor()
        #conn = mysql.connect()
        book = request.form['book']
        # search by author or book
        cursor.execute("SELECT * from library.book_inventory WHERE Book_name LIKE %s OR Book_author LIKE %s", (book, book))
        data = cursor.fetchall()
        # all in the search box will return all the tuples
        if len(data) == 0 and book == 'all': 
            cursor.execute("SELECT * from library.book_inventory")
            data = cursor.fetchall()
            print(data)
        return render_template('update.html', data=data)
    return render_template('update.html')

#endpoint for search
@app.route('/edit', methods=['GET', 'POST'])
def edit():
    msg = ''
    if request.method == "GET":
        cursor = mysql.connection.cursor()
        #conn = mysql.connect()
        book_id = request.args.get('id')
        # search by author or book
        cursor.execute("SELECT * from library.book_inventory WHERE Book_id = %s", (book_id))
        data = cursor.fetchone()
        return render_template('edit.html', data=data)
    if request.method == "POST":
        cursor = mysql.connection.cursor()
        book = request.form['book']
        author = request.form['author']
        year = request.form['year']
        book_id = request.form['id']
        cursor.execute("UPDATE book_inventory set Book_author=%s,Book_name=%s,year_of_publication=%s where Book_id=%s",(author,book,year,book_id))
        mysql.connection.commit()
        msg="Book information updated sucessfully!!"
    return render_template('edit.html',msg=msg,data=[])
if __name__ == '__main__':
    app.run()
