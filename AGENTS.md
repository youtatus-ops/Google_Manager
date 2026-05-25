# Repository Guidelines

## Project Structure & Module Organization
This repository combines a Flask API with a Vite/React frontend. Backend source lives in `app/`: `models/` defines SQLAlchemy entities, `routes/` exposes blueprints, `services/` contains account and auth logic, and `utils/` holds helpers such as TOTP generation. `run.py` starts Flask and creates `instance/accounts.db` when needed. Frontend source is under `frontend/src/`, with UI in `components/`, hooks in `hooks/`, and API wrappers in `services/`. Built assets are emitted to `static/`; do not edit hashed files there directly.

## Build, Test, and Development Commands
- `pip install -r requirements.txt`: install Python backend dependencies.
- `python run.py`: run the Flask app on `http://localhost:8002`.
- `cd frontend && npm install`: install frontend dependencies from `package-lock.json`.
- `cd frontend && npm run dev`: start Vite on port `3000`; API calls proxy to `http://localhost:5000` per `frontend/vite.config.js`.
- `cd frontend && npm run build`: build React assets into `static/` for Flask serving.
- `python migrate_history.py`: apply the history-table migration when updating existing SQLite data.

## Coding Style & Naming Conventions
Use 4-space indentation for Python and keep Flask routes thin by delegating business rules to `app/services/`. Python files and functions use `snake_case`; SQLAlchemy models use `PascalCase`. React components use `PascalCase` filenames such as `AccountListView.jsx`; hooks use `useX.js`; API helpers should stay in `frontend/src/services/api.js`. Keep Tailwind classes readable and avoid editing generated files or dependencies.

## Testing Guidelines
No dedicated test suite is currently checked in. For backend changes, add focused tests under `tests/` and prefer Flask's test client with `create_app('testing')`, which uses in-memory SQLite. For frontend changes, add component or behavior tests if a test framework is introduced. Until tests exist, manually verify login, account CRUD, batch import, 2FA generation, status toggles, and history display.

## Commit & Pull Request Guidelines
Recent commits use short imperative summaries such as `Update README.md`. Keep commit subjects concise and action-oriented, for example `Add account history tests` or `Fix batch import validation`. Pull requests should describe the change, list manual or automated checks performed, note database or configuration impacts, and include screenshots for visible UI changes.

## Security & Configuration Tips
Do not commit real account data, `instance/accounts.db`, secrets, or production passwords. Override `SECRET_KEY` and `DATABASE_URL` through environment variables for non-local deployments. Review `app/services/auth_service.py` before changing admin-password or IP-ban behavior, and keep exported account data out of logs and screenshots.
