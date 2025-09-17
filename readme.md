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
docker build GODOT_BUILDER/ --tag garyritchie/godot-builder:4.5-stable

docker push -a garyritchie/godot-builder
```

## Container Usage

Example, building export templates, with encryption:

```bash
source .makerc && \
docker run --env-file .env --rm --workdir /godot \
  -v "/$(pwd)/$GODOT_PROJECT/icon.ico:/godot/platform/windows/godot.ico" \
  -v "/$(pwd)/export_templates:/godot/bin" \
  garyritchie/godot-builder:4.5-stable \
  sh -c "update-alternatives --set x86_64-w64-mingw32-g++ /usr/bin/x86_64-w64-mingw32-g++-posix && scons use_lto=yes platform=windows target=template_release optimize=size arch=x86_64"
```

and the _.gitignored_ `.env` contains:

```ini
SCRIPT_AES256_ENCRYPTION_KEY=<your key>
```

- [Compiling with PCK encryption key](https://docs.godotengine.org/en/stable/engine_details/development/compiling/compiling_with_script_encryption_key.html)
- https://docs.godotengine.org/en/stable/tutorials/export/changing_application_icon_for_windows.html#doc-changing-application-icon-for-windows