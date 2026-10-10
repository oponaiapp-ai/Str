# STR character models

Place production-quality character assets here when available:

- `ronin.glb` — male anime-inspired historical character
- `aya.glb` — female anime-inspired historical character

The current page can also load a direct HTTPS URL to a GLB/GLTF model from **Settings → Load 3D model**. A remote host must permit browser CORS access. Prefer optimized GLB files and verify redistribution rights before committing third-party assets.

## Asset requirements

- Full-body model standing upright, feet near the origin, facing +Z.
- Approximate height 2–3 units; the viewer normalizes model height automatically.
- Meshes should have sensible materials and textures.
- A rigged/skinned model is preferred for future clothing attachments and animation.
- Clothing, armor, hair, and weapon attachments should use documented bones/attachment points if they need to follow body motion.

The bundled procedural model remains the fallback. External model loading currently replaces the procedural body, but generic equipment is not yet retargeted to an arbitrary skeleton.
