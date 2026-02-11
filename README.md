# university-tycoon-sqlite
SQLite database project modelling the University Tycoon boardgame with triggers, audit trail, and leaderboard view.
# University Tycoon – SQLite Database Simulation

This project models the gameplay of the boardgame "University Tycoon" using a relational database implemented in SQLite.

## Features

- Normalized relational schema based on ERD design
- Gameplay automation using SQLite triggers
- Audit trail recording each player turn
- External-facing `leaderboard` view
- SQL scripts that simulate 3 full rounds of gameplay

## Structure

- `sql/` – database creation, population, and gameplay queries  
- `erd/` – entity relationship diagram  
- `screenshots/` – leaderboard outputs after each round  
- `report/` – project report and design defence  

## How to Run

```bash
sqlite3 game.db < sql/create.sql
sqlite3 game.db < sql/populate.sql
sqlite3 game.db < sql/view.sql
