# Godot Build Environment

Meant to be a submodule to Godot projects for building export templates with PCK encryption and custom icon.

```bash
git submodule add <repo-location> GODOT_BUILDER/
```

Example layout:

```tree
.
├── GODOT_BUILDER
│   ├── Dockerfile
│   └── readme.md
├── .env
├── SCENE_GODOT
│   ├── icon.ico
.   .
```

## Creating The Image

```bash
docker build GODOT_BUILDER/ --tag garyritchie/godot-builder:4.2.1-stable

docker push -a garyritchie/godot-builder
```

## Container Usage

Example, building export templates, with encryption:

```bash
docker run --env-file .env --rm --workdir /godot \
  -v "/$(pwd)/SCENE_GODOT/icon.ico:/godot/platform/windows/godot.ico" \
  -v "/$(pwd)/export_templates:/godot/bin" \
  garyritchie/godot-builder:4.2.1-stable \
  sh -c "update-alternatives --set x86_64-w64-mingw32-g++ /usr/bin/x86_64-w64-mingw32-g++-posix && scons use_lto=yes platform=windows target=template_release optimize=size arch=x86_64"
```

and the _.gitignored_ `.env` contains:

```ini
SCRIPT_AES256_ENCRYPTION_KEY=<your key>
```