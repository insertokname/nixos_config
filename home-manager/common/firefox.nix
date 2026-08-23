# firefox-windows-shortcuts.nix
#
# Makes Linux Firefox use the *Windows* default keybindings for the 7
# shortcuts that actually differ between the two platforms. Verified
# directly against mozilla-central source (Firefox ~147, mid-2026):
#
#   browser/base/content/browser-sets.inc            (the #ifdef XP_GNOME / XP_WIN blocks)
#   browser/locales/en-US/browser/browserSets.ftl     (the real key letters, incl. PLATFORM() selectors)
#   toolkit/locales/en-US/toolkit/global/textActions.ftl (undo/redo key letters)
#
#   | Action                | Windows          | Linux (stock)     |
#   |------------------------|------------------|--------------------|
#   | Downloads Library      | Ctrl+J           | Ctrl+Shift+Y       |
#   | Focus Search (alt)     | Ctrl+E           | Ctrl+J             |
#   | Redo                   | Ctrl+Y           | Ctrl+Shift+Z       |
#   | Back/Forward (extra)   | (none)           | Ctrl+[ / Ctrl+]    |
#   | Toggle Reader Mode     | F9 (bare)        | Ctrl+Alt+R         |
#   | Quit Firefox           | Ctrl+Shift+Q     | Ctrl+Q             |
#   | Switch to tab N        | Ctrl+1..Ctrl+9   | Alt+1..Alt+9       |
#
# MECHANISM: Firefox's AutoConfig system (mozilla.cfg + defaults/pref/autoconfig.js).
# This is the ~20-year-old, well-proven privileged-JS hook Mozilla itself still ships
# support for — it directly rewrites the <key> element attributes on every browser
# window as it opens, so it doesn't depend on Firefox 147's new (and still
# undocumented-schema) about:keyboard storage format.
#
# USAGE (Home Manager):
#   imports = [ (import ./firefox-windows-shortcuts.nix) ];
#
# If you already configure `programs.firefox` elsewhere, don't import this whole
# module — just copy the `firefoxWithWindowsShortcuts` package below and set
# `programs.firefox.package = firefoxWithWindowsShortcuts;` in your existing config.
#
# VERIFY AFTER BUILDING: nixpkgs' firefox output layout has shifted before. The
# postInstall below auto-locates the real `firefox` binary under $out/lib rather
# than hardcoding a path, so it should survive most layout changes. If the build
# fails to find it, run `nix build .#firefoxWithWindowsShortcuts && find result/lib -name firefox`
# and adjust the `find` line's search root accordingly.

{
  config,
  pkgs,
  lib,
  ...
}:

let
  mozillaCfg = pkgs.writeText "mozilla.cfg" ''
    // mozilla.cfg -- Firefox discards this first line, so it must be a comment.
    // Rewrites Linux's <key> shortcut bindings to match stock Windows Firefox.

    (function () {
      function reRegister(el) {
        // <key> elements cache their accelerator at parse time; changing an
        // attribute in place doesn't re-register it. Clone+replace does.
        const clone = el.cloneNode(true);
        el.replaceWith(clone);
        return clone;
      }

      function setKey(doc, id, attrs) {
        const el = doc.getElementById(id);
        if (!el) return;
        ["key", "keycode", "modifiers"].forEach((a) => el.removeAttribute(a));
        for (const name in attrs) el.setAttribute(name, attrs[name]);
        reRegister(el);
      }

      function removeKey(doc, id) {
        const el = doc.getElementById(id);
        if (el) el.remove();
      }

      function patch(doc) {
        // Downloads Library:              Ctrl+Shift+Y -> Ctrl+J
        setKey(doc, "key_openDownloads", { key: "J", modifiers: "accel" });

        // Focus Search Bar (alt binding): Ctrl+J       -> Ctrl+E
        setKey(doc, "key_search2", { key: "E", modifiers: "accel" });

        // Redo:                           Ctrl+Shift+Z -> Ctrl+Y
        setKey(doc, "key_redo", { key: "Y", modifiers: "accel" });

        // Extra back/forward bindings Windows simply doesn't have.
        // Comment these two lines out if you'd rather keep the bonus shortcut.
        removeKey(doc, "goBackKb2");
        removeKey(doc, "goForwardKb2");

        // Toggle Reader Mode:             Ctrl+Alt+R   -> F9 (bare)
        setKey(doc, "key_toggleReaderMode", { keycode: "VK_F9" });

        // Quit Firefox:                   Ctrl+Q       -> Ctrl+Shift+Q
        setKey(doc, "key_quitApplication", { key: "Q", modifiers: "accel,shift" });

        // Switch to tab N:                Alt+1..9     -> Ctrl+1..9
        [
          "key_selectTab1", "key_selectTab2", "key_selectTab3", "key_selectTab4",
          "key_selectTab5", "key_selectTab6", "key_selectTab7", "key_selectTab8",
          "key_selectLastTab",
        ].forEach((id) => {
          const el = doc.getElementById(id);
          if (el) {
            el.setAttribute("modifiers", "accel");
            reRegister(el);
          }
        });
      }

      Services.obs.addObserver(function observer(win) {
        win.addEventListener("load", function onLoad() {
          win.removeEventListener("load", onLoad);
          if (win.location.href === "chrome://browser/content/browser.xhtml") {
            patch(win.document);
          }
        });
      }, "chrome-document-global-created");
    })();
  '';

  autoconfigJs = pkgs.writeText "autoconfig.js" ''
    pref("general.config.filename", "mozilla.cfg");
    pref("general.config.obscure_value", 0);
  '';

  firefoxUnwrappedPatched = pkgs.firefox-unwrapped.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      fxdir="$(dirname "$(find "$out/lib" -maxdepth 2 -name firefox -type f | head -n1)")"
      install -D ${autoconfigJs} "$fxdir/defaults/pref/autoconfig.js"
      install -D ${mozillaCfg}   "$fxdir/mozilla.cfg"
    '';
  });

  firefoxWithWindowsShortcuts = pkgs.wrapFirefox firefoxUnwrappedPatched { };
in
{
  programs.firefox = {
    enable = true;
    package = firefoxWithWindowsShortcuts;
  };
}
