import mysql.connector

def run_test(test):
    error = None
    try:
        conn = mysql.connector.connect(host='my5.7', user='root', database='test')

        c = conn.cursor()
        for sql in test['sql']:
            c.execute(sql)

        conn.close()
    except mysql.connector.Error as e:
        error = e

    return error
