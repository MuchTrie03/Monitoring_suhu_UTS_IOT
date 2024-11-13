from flask import Flask, jsonify
from flask_cors import CORS
import random
import time
import threading
from datetime import datetime

app = Flask(__name__)
CORS(app)

# Fungsi untuk menghasilkan data acak
def generate_random_data():
    return {
        "suhumax": random.randint(25, 40),  # Suhu max antara 25 - 40
        "suhumin": random.randint(15, 25),  # Suhu min antara 15 - 25
        "suhurata": round(random.uniform(20, 30), 2),  # Suhu rata-rata antara 20 - 30
        "nilai_suhu_max_humid_max": [
            {
                "idx": random.randint(0, 1000),
                "suhu": random.randint(25, 40),
                "humid": random.randint(50, 100),  # Humidity antara 50 - 100
                "kecerahan": random.randint(0, 100),  # Kecerahan antara 0 - 100
                "timestamp": datetime.utcnow().isoformat()
            },
            {
                "idx": random.randint(0, 1000),
                "suhu": random.randint(25, 40),
                "humid": random.randint(50, 100),
                "kecerahan": random.randint(0, 100),
                "timestamp": datetime.utcnow().isoformat()
            }
        ],
        "month_year_max": [
            { "month_year": f"{datetime.utcnow().month}-{datetime.utcnow().year}" },
            { "month_year": f"{random.randint(1, 12)}-{random.randint(2018, 2023)}" }
        ]
    }

# Variable untuk menyimpan data terkini
current_data = generate_random_data()

# Fungsi untuk memperbarui data setiap 2 detik
def update_data():
    global current_data
    while True:
        current_data = generate_random_data()
        print("Data updated:", current_data)
        time.sleep(2)

# Memulai thread untuk memperbarui data
data_thread = threading.Thread(target=update_data)
data_thread.daemon = True
data_thread.start()

# Endpoint untuk mendapatkan data
@app.route('/data', methods=['GET'])
def get_data():
    return jsonify(current_data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000)
