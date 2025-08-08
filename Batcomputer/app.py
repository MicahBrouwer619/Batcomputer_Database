from flask import Flask, jsonify, request
import mysql.connector
import os

app = Flask(__name__)

# --- Database Configuration ---
DB_HOST = os.getenv('DB_HOST', '')
DB_USER = os.getenv('DB_USER', '')
DB_PASSWORD = os.getenv('DB_PASSWORD', '')
DB_NAME = os.getenv('DB_NAME', 'batcomputer')

def get_db_connection():
    """Establishes a connection to the MySQL database."""
    try:
        connection = mysql.connector.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME
        )
        return connection
    except mysql.connector.Error as err:
        print(f"Error connecting to MySQL: {err}")
        return None

# --- API Endpoints ---

@app.route('/')
def home():
    """Simple health check endpoint."""
    return jsonify({"message": "Welcome to the batcave database..."})



## Get All characters

#This endpoint will fetch a list of all characters in the data base


@app.route('/batcomputer_data', methods=['GET'])
def get_superheroes():
    """Fetches all personel from the database."""
    conn = get_db_connection()
    if conn is None:
        return jsonify({"error": "Database connection failed"}), 500

    cursor = conn.cursor(dictionary=True) # dictionary=True makes rows accessible by column name
    try:
        # Select key columns for a list view. Adjust as needed.
        cursor.execute("""
            SELECT
                id, name, intelligence, strength, speed, durability, power, combat,
                `full-name` AS full_name, 'alter-egos' AS alter_egos, 'place-of-birth' AS birthplace, alignment, gender, race, height, weight,
                `eye-color` AS eye_color, `hair-color` AS hair_color, occupation, base, 'group-affiliation' AS affiliation, relatives, url
            FROM batcomputer_data
        """)
        batcomputer_data = cursor.fetchall()

        # Clean up column names to be more Python/Swift friendly (e.g., 'full-name' to 'full_name')
        # This is already handled by `AS` in the SQL query for some, but good to be explicit
        # if you have many columns or need more complex transformations.
        cleaned_superheroes = []
        for person in batcomputer_data:
            cleaned_hero = {k.replace('-', '_'): v for k, v in person.items()}
            cleaned_superheroes.append(cleaned_hero)

        return jsonify(cleaned_superheroes)
    except mysql.connector.Error as err:
        print(f"Error executing query: {err}")
        return jsonify({"error": "Failed to retrieve superheroes"}), 500
    finally:
        cursor.close()
        conn.close()

@app.route('/batcomputer_data/<int:hero_id>', methods=['GET'])
def get_superhero(hero_id):
    """Fetches a single superhero by ID."""
    conn = get_db_connection()
    if conn is None:
        return jsonify({"error": "Database connection failed"}), 500

    cursor = conn.cursor(dictionary=True)
    try:
        # Select all columns for a detailed view
        cursor.execute("""
            SELECT
                id, name, intelligence, strength, speed, durability, power, combat,
                `full-name` AS full_name, `alter-egos` AS alter_egos, aliases,
                `place-of-birth` AS place_of_birth, `first-appearance` AS first_appearance,
                publisher, alignment, gender, race, height, weight,
                `eye-color` AS eye_color, `hair-color` AS hair_color,
                occupation, base, `group-affiliation` AS affiliation,
                relatives, url
            FROM batcomputer_data
            WHERE id = %s
        """, (hero_id,))
        superhero = cursor.fetchone()

        if superhero:
            # Clean up column names for the single hero
            cleaned_superhero = {k.replace('-', '_'): v for k, v in superhero.items()}
            return jsonify(cleaned_superhero)
        else:
            return jsonify({"message": "personel not found"}), 404
    except mysql.connector.Error as err:
        print(f"Error executing query: {err}")
        return jsonify({"error": "Failed to retrieve intel"}), 500
    finally:
        cursor.close()
        conn.close()

@app.route('/batcomputer_data/add', methods=['POST'])
def add_superhero():
    """Adds a new superhero to the database."""
    new_hero_data = request.get_json()

    # Basic validation for mandatory fields. Expand as needed.
    required_fields = ['name', 'publisher', 'full-name', 'intelligence', 'strength', 'speed', 'durability', 'power', 'combat']
    for field in required_fields:
        if field not in new_hero_data:
            return jsonify({"error": f"Missing required field: '{field}'"}), 400

    # Extracting data, providing defaults for optional fields if not provided
    name = new_hero_data['name']
    intelligence = new_hero_data['intelligence']
    strength = new_hero_data['strength']
    speed = new_hero_data['speed']
    durability = new_hero_data['durability']
    power = new_hero_data['power']
    combat = new_hero_data['combat']
    full_name = new_hero_data['full-name']

    # Optional fields, defaulting to empty string or None if not provided
    alter_egos = new_hero_data.get('alter-egos', 'No alter egos found.')
    aliases = new_hero_data.get('aliases', '[]') # Store as JSON string or handle as list if more complex
    place_of_birth = new_hero_data.get('place-of-birth', '-')
    first_appearance = new_hero_data.get('first-appearance', '-')
    publisher = new_hero_data['publisher']
    alignment = new_hero_data.get('alignment', '-')
    gender = new_hero_data.get('gender', '-')
    race = new_hero_data.get('race', '-')
    height = new_hero_data.get('height', '[]') # Store as JSON string or handle as list
    weight = new_hero_data.get('weight', '[]') # Store as JSON string or handle as list
    eye_color = new_hero_data.get('eye-color', '-')
    hair_color = new_hero_data.get('hair-color', '-')
    occupation = new_hero_data.get('occupation', '-')
    base = new_hero_data.get('base', '-')
    group_affiliation = new_hero_data.get('group-affiliation', '-')
    relatives = new_hero_data.get('relatives', '-')
    url = new_hero_data.get('url', '-')


    conn = get_db_connection()
    if conn is None:
        return jsonify({"error": "Database connection failed"}), 500

    cursor = conn.cursor()
    try:
        # Prepare the INSERT statement with all columns
        insert_query = """
            INSERT INTO batcomputer_data (
                name, intelligence, strength, speed, durability, power, combat,
                `full-name`, `alter-egos`, aliases, `place-of-birth`, `first-appearance`,
                publisher, alignment, gender, race, height, weight,
                `eye-color`, `hair-color`, occupation, base, `group-affiliation`,
                relatives, url
            ) VALUES (
                %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
                %s, %s, %s, %s, %s, %s, %s
            )
        """
        insert_data = (
            name, intelligence, strength, speed, durability, power, combat,
            full_name, alter_egos, aliases, place_of_birth, first_appearance,
            publisher, alignment, gender, race, height, weight,
            eye_color, hair_color, occupation, base, group_affiliation,
            relatives, url
        )

        cursor.execute(insert_query, insert_data)
        conn.commit()
        new_id = cursor.lastrowid
        return jsonify({"message": "Superhero added successfully", "id": new_id, "name": name, "publisher": publisher}), 201
    except mysql.connector.Error as err:
        print(f"Error adding superhero: {err}")
        # Consider specific error handling for duplicate names or other constraints
        if err.errno == 1062: # MySQL error code for duplicate entry
            return jsonify({"error": "character with this name already exists"}), 409
        return jsonify({"error": "Failed to add character"}), 500
    finally:
        cursor.close()
        conn.close()





# --- Run the Flask App (for development only) ---
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)