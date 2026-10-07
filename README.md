# Classboard

A live whiteboard for online classes. Students open one link, type their name, and work together on the same board: sticky notes, text, shapes, arrows, freehand drawing, activity layouts (Brainstorm, K-W-L chart, Exit ticket, Group project) and a shared class timer. Everyone sees each other's cursors and changes in real time.

It runs as a static website on GitHub Pages. Supabase (free tier) stores the boards and sends live updates.

## Set up (about 10 minutes, once)

### 1. Create the database
1. Sign in at [supabase.com](https://supabase.com) and create a new project (the free plan is enough).
2. Open **SQL Editor → New query**, paste the contents of [`supabase/setup.sql`](supabase/setup.sql), and press **Run**.

### 2. Connect the website to it
1. In Supabase, open **Project Settings → API**.
2. Copy the **Project URL** and the **anon public** key.
3. Paste them into [`config.js`](config.js) and commit the change.

The anon key is meant to be public. The rules in `setup.sql` decide what it can do.

### 3. Publish with GitHub Pages
1. In the repository, open **Settings → Pages**.
2. Under **Build and deployment**, choose **Deploy from a branch**, branch `main`, folder `/ (root)`, and save.
3. After a minute the board is live at `https://<your-username>.github.io/<repo-name>/`.

## Using it in class

- Share the main link, or use the **Copy link** button on the board.
- **One board per class or lesson:** add `?board=` with any name, for example
  `https://<your-username>.github.io/<repo-name>/?board=biology-7a`.
  Each name is a separate board with its own notes and timer.
- Students don't need accounts. They type a name the first time they join.

### Shortcuts
| Key | Action |
| --- | --- |
| V / H | Select / pan |
| N, T, R, O, A, P, E | Sticky, text, rectangle, circle, arrow, pen, eraser |
| Double-click | Write on an item, or add a sticky on empty space |
| Space + drag | Pan |
| Ctrl + scroll, pinch | Zoom |
| Ctrl + D / Ctrl + Z | Duplicate / undo |
| Delete | Remove the selected item |
| 0 | Fit the whole board on screen |

## Good to know

- Anyone who has a board's link can edit it, including clearing it. Use a less guessable board name (`?board=bio7a-k3x9`) for each class, and only share it with your students.
- The Supabase free plan pauses a project after a week with no activity. Opening the Supabase dashboard wakes it up.
- If `config.js` is empty, the board still opens in single-person mode and nothing is saved.

## Files

| File | What it is |
| --- | --- |
| `index.html` | The whole app |
| `config.js` | Your Supabase project URL and anon key |
| `supabase/setup.sql` | Creates the tables, access rules and live updates |
