# My Collectapedia

A Bulbapedia-style tracker for a Pokémon TCG collection: every English expansion with its full card list, where each card is stored (binder / bulk / other), binder planning and a page-by-page binder view.

## Files
- `index.html` – the whole site
- `data.js` – set and card lists (from the open PokemonTCG/pokemon-tcg-data project)
- `supabase-config.js` – your Supabase Project URL and publishable key (fill these in)
- `setup.sql` – run once in Supabase's SQL Editor (put your email in it first)

## How it works
- With `supabase-config.js` filled in, the collection is stored online in Supabase.
  Anyone with the link can browse it read-only; only the owner's email can sign in and edit (Options → sign-in link).
- Without it, the site saves to the browser only.

## Setup summary
1. Create a free Supabase project.
2. Put your email into `setup.sql`, paste it into SQL Editor and Run.
3. Authentication → URL Configuration: set Site URL (and a Redirect URL) to your GitHub Pages address.
4. Copy the Project URL and publishable key into `supabase-config.js`.
5. Upload all files to the GitHub repository.
6. Open the site, Options → email yourself a sign-in link, click it, then press "Move them online".
