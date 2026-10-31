# Christmas Brunch

Sonntagsbrunch, Christmas Edition: Potluck, jede bringt etwas mit.
Birmensdorferstrasse 377, Zürich (Heuried), Sonntag 11:00, einer der vier
Adventssonntage.

Statische Seite auf GitHub Pages, Daten in Supabase (gleiches Projekt wie
Tassen-Dienstag, Tabelle `brunch_people`).

## Dateien

- `index.html`: die ganze Seite
- `config.js`: Supabase-URL und öffentlicher Schlüssel
- `supabase/schema.sql`: Tabelle, Zugriffsregeln, die vier Namen

## Supabase

Einmal `supabase/schema.sql` im SQL Editor ausführen. Mit dem öffentlichen
Schlüssel kann man lesen, Namen hinzufügen und Sonntage, Personenzahl und
Mitbringsel ändern. Löschen und Umbenennen geht nur im Dashboard.
