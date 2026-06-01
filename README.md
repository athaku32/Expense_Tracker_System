The following steps describe how to run the Expense Tracker system locally, including
prerequisites, installation steps, and database setup. These instructions ensure that any user can
successfully reproduce the project environment.
(i) Prerequisites
Before running the project, ensure the following tools are installed on your system:
●
Python 3.10+
●
pip (Python package manager)
●
PostgreSQL (with pgAdmin or command line access)
●
Git (for cloning the repository)
You also need the project’s database file:
●
database/expense_dump.sql (included with this submission)
(ii) Clone the Repository
Open a terminal and run:
git clone https://github.com/athaku32/Expense_Tracker_System.git
cd Expense_Tracker_System
(iii) Create and Activate a Virtual Environment
python3 -m venv venv
source venv/bin/activate # macOS / Linux
(iv) Install Project Dependencies
pip install -r requirements.txt
This installs Flask, psycopg2, python-dotenv, and other required libraries.
(v) Configure Environment Variables
Create a file named .env in the project directory and add:
DB_NAME = expense_tracker
DB_USER = postgres
DB_PASSWORD = your_password
DB_HOST = localhost
DB_PORT = 5432
Replace your_password with your actual PostgreSQL password.
(vi) Import the Database
Open pgAdmin or use the PostgreSQL command line.
Using pgAdmin
1. Right click Databases → Create → Database
2. Name it: expense_tracker
3. Right click the new database → Restore
4. Format: Plain
5. Select file: expense_dump.sql
6. Click Restore
Using Terminal : psql -U postgres -d expense_tracker -f database/expense_dump.sql
(vii) Run the Flask Application
With the virtual environment active, run:
python3 app.py
The application will start at: http://127.0.0.1:5000
(viii) Expected Output
After launching the server, you should be able to:
●
●
●
●
View the dashboard summary (income, expenses, remaining balance)
Add, edit, and delete transactions
Add and view category budgets
See updates reflected immediately in PostgreSQL
