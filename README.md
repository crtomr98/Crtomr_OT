# Cristomar Floor Board

Shop-floor board for tracking rugs through every stage. Static site (GitHub Pages) + Supabase (database, login, live sync).

## Files

| File | What it does |
|---|---|
| `index.html` | The whole app. |
| `config.js` | Your Supabase URL and public key (you edit this). |
| `supabase/schema.sql` | Creates the table, security rules and live updates. |
| `.github/workflows/pages.yml` | Publishes the site to GitHub Pages on every push to `main`. |

## 1. Supabase (about 5 minutes)

1. Create a free project at supabase.com. Pick a region near Georgia (e.g. US East).
2. **SQL Editor > New query**, paste all of `supabase/schema.sql`, click **Run**.
3. **Project Settings > API**: copy the **Project URL** and the **anon / publishable** key into `config.js`. Do not use the `service_role` / secret key.
4. **Authentication > Users > Add user**: create the shop login (email + password, tick "Auto Confirm User"). Add one per person if you want individual logins.
5. **Authentication > Sign In / Providers**: turn **off** "Allow new users to sign up" so only users you created can get in.
6. After step 3 below, set **Authentication > URL Configuration > Site URL** to your GitHub Pages address.

## 2. GitHub

1. Create a new repository and push these files to the `main` branch (or use "Add file > Upload files" on github.com, including the `.github` folder).
2. **Settings > Pages > Build and deployment > Source: GitHub Actions**.
3. Push (or run the workflow from the Actions tab). The site appears at `https://<your-username>.github.io/<repo-name>/`.

Free GitHub accounts need a public repo for Pages. That's fine here: the repo holds only code and the public key, and all shop data sits behind the Supabase login.

## 3. First run

Open the site, sign in with the shop login. Add your team under Settings, then use the Worker station on each phone/tablet. Settings also has demo-data buttons for trying it out (and removing the demo rows afterwards).

## Notes

- Everyone who signs in can read and edit everything, which matches the shop-login design.
- Back up occasionally: Supabase dashboard > Table Editor > `docs` > Export CSV.
- Changing the app later: edit `index.html`, commit, and Pages redeploys.
