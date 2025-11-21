import psycopg2
from flask import Flask, render_template, request, redirect, url_for
from dotenv import load_dotenv
import os

# Load environment variables from .env
load_dotenv()

app = Flask(__name__)

# Database settings from environment, with safe defaults
DB_NAME = os.getenv("DB_NAME", "expense_tracker")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASSWORD = os.getenv("DB_PASSWORD")  # no default on purpose
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "5432")


def get_connection():
    return psycopg2.connect(
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
        host=DB_HOST,
        port=DB_PORT,
    )


# ------------------ Dashboard / Home ------------------ #
@app.route("/")
def index():
    try:
        conn = get_connection()
        cur = conn.cursor()

        # Total income
        cur.execute(
            """
            SELECT COALESCE(SUM(t_amount), 0)
            FROM "TRANSACTION"
            WHERE t_type = 'Income';
            """
        )
        total_income = float(cur.fetchone()[0])

        # Total expense
        cur.execute(
            """
            SELECT COALESCE(SUM(t_amount), 0)
            FROM "TRANSACTION"
            WHERE t_type = 'Expense';
            """
        )
        total_expense = float(cur.fetchone()[0])

        # Number of transactions
        cur.execute('SELECT COUNT(*) FROM "TRANSACTION";')
        tx_count = cur.fetchone()[0]

        # Number of budgets
        cur.execute("SELECT COUNT(*) FROM BUDGET;")
        budget_count = cur.fetchone()[0]

        cur.close()
        conn.close()

        remaining_balance = total_income - total_expense

        return render_template(
            "index.html",
            total_income=total_income,
            total_expense=total_expense,
            remaining_balance=remaining_balance,
            transaction_count=tx_count,   # used by index.html
            budget_count=budget_count,
        )
    except Exception as e:
        return f"Database connection error: {e}"


# ------------------ Transactions list ------------------ #
@app.route("/transactions")
def list_transactions():
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute(
            """
            SELECT
                t.t_transaction_id,
                u.u_name,
                c.c_category_name,
                p.p_payment_type,
                t.t_amount,
                t.t_type,
                t.t_tx_date,
                t.t_description
            FROM "TRANSACTION" t
            JOIN "USER" u ON t.t_user_id = u.u_user_id
            JOIN CATEGORY c ON t.t_category_id = c.c_category_id
            LEFT JOIN PAYMENT_METHOD p ON t.t_payment_id = p.p_payment_id
            ORDER BY t.t_tx_date DESC, t.t_transaction_id;
        """
        )
        rows = cur.fetchall()
        cur.close()
        conn.close()

        transactions = []
        for r in rows:
            transactions.append(
                {
                    "id": r[0],
                    "user_name": r[1],
                    "category_name": r[2],
                    "payment_type": r[3],
                    "amount": r[4],
                    "type": r[5],
                    "date": r[6],
                    "description": r[7],
                }
            )

        return render_template("transactions.html", transactions=transactions)
    except Exception as e:
        return f"Error loading transactions: {e}"


# ------------------ Add transaction ------------------ #
@app.route("/transactions/new", methods=["GET", "POST"])
def add_transaction():
    if request.method == "POST":
        try:
            user_id = int(request.form["user_id"])
            category_id = int(request.form["category_id"])

            payment_id_raw = request.form.get("payment_id")
            payment_id = int(payment_id_raw) if payment_id_raw else None

            amount = float(request.form["amount"])
            tx_type = request.form["type"]
            date = request.form["date"]
            description = request.form.get("description", "")

            conn = get_connection()
            cur = conn.cursor()
            cur.execute(
                """
                INSERT INTO "TRANSACTION" (
                    t_transaction_id,
                    t_user_id,
                    t_category_id,
                    t_payment_id,
                    t_amount,
                    t_type,
                    t_tx_date,
                    t_description
                )
                VALUES (
                    (SELECT COALESCE(MAX(t_transaction_id), 0) + 1 FROM "TRANSACTION"),
                    %s, %s, %s, %s, %s, %s, %s
                );
            """,
                (user_id, category_id, payment_id, amount, tx_type, date, description),
            )
            conn.commit()
            cur.close()
            conn.close()

            return redirect(url_for("list_transactions"))
        except Exception as e:
            return f"Error adding transaction: {e}"

    return render_template("add_transaction.html")


# ------------------ Edit transaction ------------------ #
@app.route("/transactions/<int:tx_id>/edit", methods=["GET", "POST"])
def edit_transaction(tx_id):
    if request.method == "POST":
        try:
            user_id = int(request.form["user_id"])
            category_id = int(request.form["category_id"])

            payment_id_raw = request.form.get("payment_id")
            payment_id = int(payment_id_raw) if payment_id_raw else None

            amount = float(request.form["amount"])
            tx_type = request.form["type"]
            date = request.form["date"]
            description = request.form.get("description", "")

            conn = get_connection()
            cur = conn.cursor()
            cur.execute(
                """
                UPDATE "TRANSACTION"
                SET
                    t_user_id = %s,
                    t_category_id = %s,
                    t_payment_id = %s,
                    t_amount = %s,
                    t_type = %s,
                    t_tx_date = %s,
                    t_description = %s
                WHERE t_transaction_id = %s;
            """,
                (
                    user_id,
                    category_id,
                    payment_id,
                    amount,
                    tx_type,
                    date,
                    description,
                    tx_id,
                ),
            )
            conn.commit()
            cur.close()
            conn.close()

            return redirect(url_for("list_transactions"))
        except Exception as e:
            return f"Error updating transaction: {e}"

    # GET: load existing values
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute(
            """
            SELECT
                t_user_id,
                t_category_id,
                t_payment_id,
                t_amount,
                t_type,
                t_tx_date,
                t_description
            FROM "TRANSACTION"
            WHERE t_transaction_id = %s;
        """,
            (tx_id,),
        )
        row = cur.fetchone()
        cur.close()
        conn.close()

        if row is None:
            return f"Transaction {tx_id} not found."

        tx = {
            "id": tx_id,
            "user_id": row[0],
            "category_id": row[1],
            "payment_id": row[2],
            "amount": row[3],
            "type": row[4],
            "date": row[5],
            "description": row[6],
        }

        # pass it with the name "transaction" so your current template works
        return render_template("edit_transaction.html", transaction=tx)
    except Exception as e:
        return f"Error loading transaction: {e}"


# ------------------ Delete transaction ------------------ #
@app.route("/transactions/<int:tx_id>/delete", methods=["POST"])
def delete_transaction(tx_id):
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute(
            'DELETE FROM "TRANSACTION" WHERE t_transaction_id = %s;', (tx_id,)
        )
        conn.commit()
        cur.close()
        conn.close()
        return redirect(url_for("list_transactions"))
    except Exception as e:
        return f"Error deleting transaction: {e}"


# ------------------ Budgets ------------------ #
@app.route("/budgets")
def view_budgets():
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("""
            SELECT
                b.b_budget_id,
                c.c_category_name,
                b.b_amount
            FROM BUDGET b
            JOIN CATEGORY c ON b.b_category_id = c.c_category_id
            ORDER BY b.b_budget_id;
        """)
        rows = cur.fetchall()
        cur.close()
        conn.close()

        budgets = []
        for r in rows:
            budgets.append({
                "id": r[0],
                "category_name": r[1],
                "amount": r[2],
            })

        return render_template("budgets.html", budgets=budgets)
    except Exception as e:
        return f"Error loading budgets: {e}"


@app.route("/budgets/new", methods=["GET", "POST"])
def add_budget():
    if request.method == "POST":
        try:
            category_id = int(request.form["category_id"])
            amount = float(request.form["amount"])

            # for this project, just always use user 1 for budgets
            user_id = 1

            conn = get_connection()
            cur = conn.cursor()
            cur.execute(
                """
                INSERT INTO BUDGET (
                    b_budget_id,
                    b_user_id,
                    b_category_id,
                    b_amount
                )
                VALUES (
                    (SELECT COALESCE(MAX(b_budget_id), 0) + 1 FROM BUDGET),
                    %s, %s, %s
                );
                """,
                (user_id, category_id, amount),
            )
            conn.commit()
            cur.close()
            conn.close()

            return redirect(url_for("view_budgets"))
        except Exception as e:
            return f"Error adding budget: {e}"

    # GET
    return render_template("add_budget.html")


if __name__ == "__main__":
    app.run(debug=True)
