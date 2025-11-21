import psycopg2
from flask import Flask, render_template

app = Flask(__name__)

DB_NAME = # Inset DB Name
DB_USER = # Insert User
DB_PASSWORD = # Insert Password
DB_HOST = "localhost"
DB_PORT = "5432"


def get_connection():
    return psycopg2.connect(
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
        host=DB_HOST,
        port=DB_PORT,
    )


@app.route("/")
def index():
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute('SELECT COUNT(*) FROM "USER";')
        count = cur.fetchone()[0]
        cur.close()
        conn.close()
        # you can use {{ user_count }} in index.html later if you want
        return render_template("index.html", user_count=count)
    except Exception as e:
        return f"Database connection error: {e}"


@app.route("/transactions")
def list_transactions():
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("""
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
        """)
        rows = cur.fetchall()
        cur.close()
        conn.close()

        transactions = []
        for r in rows:
            transactions.append({
                "id": r[0],
                "user_name": r[1],
                "category_name": r[2],
                "payment_type": r[3],
                "amount": r[4],
                "type": r[5],
                "date": r[6],
                "description": r[7],
            })

        return render_template("transactions.html", transactions=transactions)
    except Exception as e:
        return f"Error loading transactions: {e}"


if __name__ == "__main__":
    app.run(debug=True)
