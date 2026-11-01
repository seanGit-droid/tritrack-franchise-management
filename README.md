# TriTrack

Responsive franchise management dashboard prototype based on the supplied TriTrack Figma prototype. The UI covers the BPLO dashboard, renewal and transfer management, drivers, reports, settings, a responsive navigation drawer, animated metrics/chart, and a simulated payment flow.

## Run locally

```bash
npm start
```

Then open `http://localhost:3000`.

## Database

`database/tritrack_db_prc.sql` is the supplied MariaDB schema with a safe database bootstrap (`CREATE DATABASE IF NOT EXISTS` and `USE`) added so it can be imported directly through MariaDB/phpMyAdmin. The browser demo currently uses sample data so it can run without credentials. Connect the API routes to the schema when the production database and payment provider are finalized.

## Payment

The payment modal is intentionally simulation-only. It records a demo confirmation in the UI and does not send money or call a payment API.

## Use case diagram

`docs/use-case.svg` is derived from the supplied `Blank-board.pdf` workflow board and is available from the Reports view.
