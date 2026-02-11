# 🎲 University Tycoon – SQLite Database Simulation

This project implements a relational database in **SQLite** to model the gameplay of the board game *University Tycoon*.

The aim was to design a database that fully represents the game state and to use SQL to simulate multiple rounds of play. Rather than handling logic in an external program, many of the game rules are **automated directly inside the database** using triggers, constraints, and structured queries.

---

## 📖 Project Overview

The system stores information about players, tokens, locations, buildings, and special cards. It tracks ownership of buildings, player credit balances, and movement around the board.

### Key Features
* **Game State Management:** Tracks tokens, properties, and cards.
* **Automated Logic:** Uses SQL triggers to enforce rules (e.g., collecting salary).
* **Audit Logging:** Each turn is recorded in a history log for review.
* **Leaderboard View:** A formatted view to present the game state in a client-friendly format.

---

## 📂 Repository Structure

All project files are stored inside the `University_Tycoon_Project/` folder:

* `sql/` – Scripts to create the DB, populate initial state, create views, and model gameplay rounds.
* `erd/` – The final Entity Relationship Diagram used to design the schema.
* `screenshots/` – Images of the leaderboard after each round.
* `report/` – Written report and defence explaining design decisions.

---

## 🚀 Getting Started

### 1. Database Creation
You can create and populate the database using the following commands from the repository root:

```bash
sqlite3 game.db < University_Tycoon_Project/sql/create.sql
sqlite3 game.db < University_Tycoon_Project/sql/populate.sql
sqlite3 game.db < University_Tycoon_Project/sql/view.sql
```

### 2. Simulating Gameplay
Gameplay is simulated by running the query files in order. Each file represents one player turn (G = Green, S = Scarlet, E = Electric, N = Navy):

```bash
# Round 1
sqlite3 game.db < University_Tycoon_Project/sql/q1g.sql
sqlite3 game.db < University_Tycoon_Project/sql/q1s.sql
sqlite3 game.db < University_Tycoon_Project/sql/q1e.sql
sqlite3 game.db < University_Tycoon_Project/sql/q1n.sql

# Round 2
sqlite3 game.db < University_Tycoon_Project/sql/q2g.sql
sqlite3 game.db < University_Tycoon_Project/sql/q2s.sql
sqlite3 game.db < University_Tycoon_Project/sql/q2e.sql
sqlite3 game.db < University_Tycoon_Project/sql/q2n.sql

# Round 3
sqlite3 game.db < University_Tycoon_Project/sql/q3g.sql
sqlite3 game.db < University_Tycoon_Project/sql/q3s.sql
sqlite3 game.db < University_Tycoon_Project/sql/q3e.sql
sqlite3 game.db < University_Tycoon_Project/sql/q3n.sql
```

### 3. Viewing Results
Once all scripts have been executed, view the final game state:

```sql
SELECT * FROM leaderboard;
```

---

## ⚙️ Technical Highlights: Automating Rules

A key part of the project was automating game rules inside SQLite.

For example, the following **trigger** automatically awards **100 credits** whenever a player passes the “Welcome Week” location. This ensures game mechanics are enforced by the database, reducing manual updates.

```sql
CREATE TRIGGER welcome_week_bonus
AFTER UPDATE OF location_id ON players
WHEN NEW.location_id < OLD.location_id
BEGIN
    UPDATE players
    SET credits = credits + 100
    WHERE player_id = NEW.player_id;
END;
```

---

## 🎓 Context

* **Program:** MSc Data Science, University of Manchester
* **Author:** Fen W
* **Focus:** Relational database design, SQL query writing, Views, and Triggers.
