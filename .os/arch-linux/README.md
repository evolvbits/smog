# Smog

AUR packaging for **Smog**

---

## 🔧 Maintainer workflow (AUR)

### First time setup

```sh
git clone ssh://aur@aur.archlinux.org/smog-bin.git
cd smog-bin
```

Copy the packaging files into this repo:

* PKGBUILD
* smog.install
* README.md

---

## 🧪 Local build test (mandatory before push)

```sh
rm -rf src pkg *.pkg.tar.zst(N) *.tar.gz(N) *.log(N)
makepkg -si
namcap PKGBUILD
```

---

## 📝 Generate .SRCINFO

Every time you change PKGBUILD:

```sh
makepkg --printsrcinfo > .SRCINFO
```

---

## 🚀 Initial publish to AUR

```sh
git init
git add PKGBUILD .SRCINFO smog.install README.md
git commit -m "initial release"
git remote add origin ssh://aur@aur.archlinux.org/smog-bin.git
git push -u origin master
```

## Clean all build

```sh
rm -rf src pkg *.pkg.tar.zst(N) *.tar.gz(N) *.log(N)
```

---

## 🔁 Updating package when a new GitHub tag is released

Example: new tag `v0.3.2`

1. Update version in `PKGBUILD`:

```sh
# edit PKGBUILD
pkgver=0.3.2
```

2. Recalculate checksums:

```sh
updpkgsums
```

3. Regenerate `.SRCINFO`:

```sh
makepkg --printsrcinfo > .SRCINFO
```

4. Commit and push:

```sh
git add PKGBUILD .SRCINFO
git commit -m "bump to 0.3.2"
git push
```

Done.

---

## 📂 Files in this repository

* `PKGBUILD` — AUR build recipe
* `.SRCINFO` — metadata required by AUR
* `smog.install` — post-install message

---

## 🧠 Notes

* This repository does **not** contain the source code.
* The PKGBUILD downloads the source directly from GitHub releases.
* Always test with `makepkg -si` before pushing.

---

## ✅ Maintainer best practices

Never edit `.SRCINFO` manually.
Never update `sha256sums` by hand.
Always use:

```sh
updpkgsums
makepkg --printsrcinfo > .SRCINFO
```

This avoids most common AUR packaging mistakes.
