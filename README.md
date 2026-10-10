# STR — Character Forge

STR is a standalone anime-style character customization project. It is separate from Kakasta and any other projects.

## Current prototype

The first screen is a mobile-friendly character studio built as a static web page with Three.js:
- switch between male and female anime-inspired characters;
- rotate the 3D character by dragging;
- browse historical Japanese-inspired clothing, armor, and weapons;
- change outfit colors and see equipment changes immediately;
- save the current appearance to local storage on the current device.

The current character is a procedural 3D prototype assembled from basic geometry. It is not yet a production-quality rigged character model.

## Run

Install dependencies with `npm install`, run `npm run dev` for local development, and use `npm run build` to create the production bundle in `dist/`. Vercel is configured to build STR with Vite. Three.js and GLTFLoader are bundled by Vite.

## Planned architecture

1. **Character viewer** — replace prototype geometry with optimized rigged GLB/GLTF anime characters, with male/female base models and compatible clothing/armor attachments.
2. **Equipment data** — stable item IDs, slots, compatibility rules, inventory ownership, and equipped-item state kept separately.
3. **Persistence** — authenticated user profiles and saved loadouts in Supabase; local storage remains only a prototype fallback.
4. **City chat** — real-time messages, city/room membership, moderation, rate limits, and small character portraits next to messages. This comes after the character and identity model are stable.

## Engineering rules

- Equipment state must drive the visible model, not just the inventory labels.
- Inventory UI must not hide the character on small screens.
- Keep STR isolated from all other repositories and projects.
- Do not claim real-time chat or cloud persistence until implemented and tested.
