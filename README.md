Expense Tracker System
A full-stack web application for managing personal finances. Built with Flask and PostgreSQL for CSE 412 at Arizona State University.
Features

Dashboard with real-time summary of total income, expenses, and remaining balance
Add, edit, and delete transactions with category and payment method tracking
Budget management — set spending limits per category
Multi-table SQL queries for clean, human-readable data display
Live database updates verified through pgAdmin

Tech Stack

Backend: Python, Flask, psycopg2
Database: PostgreSQL
Frontend: HTML, CSS (Jinja2 templates)
Tools: Git, GitHub, python-dotenv, virtualenv

Setup Instructions
Prerequisites

Python 3.10+
pip
PostgreSQL (with pgAdmin or command line access)
Git

1. Clone the Repository
bashgit clone https://github.com/athaku32/Expense_Tracker_System.git
cd Expense_Tracker_System
2. Create and Activate a Virtual Environment
bashpython3 -m venv venv
source venv/bin/activate   # macOS / Linux
3. Install Dependencies
bashpip install -r requirements.txt
4. Configure Environment Variables
Create a .env file in the project root and add:
DB_NAME = expense_tracker
DB_USER = postgres
DB_PASSWORD = your_password
DB_HOST = localhost
DB_PORT = 5432
5. Import the Database
Using pgAdmin:

Right click Databases → Create → Database
Name it: expense_tracker
Right click the new database → Restore
Format: Plain → select database/expense_dump.sql → click Restore

Using Terminal:
bashpsql -U postgres -d expense_tracker -f database/expense_dump.sql
6. Run the App
bashpython3 app.py
Visit: http://127.0.0.1:5000
Database Schema
Five tables: USER, CATEGORY, BUDGET, PAYMENT_METHOD, TRANSACTION

One user creates many categories, budgets, and transactions
Each transaction belongs to one category and one payment method
Normalized schema with proper foreign key constraints
