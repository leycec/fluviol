fluviol
===========

_Fluviol_ :: minimalist theme framework for FVWM[-Crystal]

## Installation

### Gentoo

Gentoo effectively supports Fluviol out of the box. (Probably due to Fluviol's implementation by a Gentoo contributor. _Probably_.)

#### Install `layman`, the Gentoo overlay manager.

    emerge layman
    echo 'source /var/lib/layman/make.conf' >> /etc/make.conf

#### Add the `raiagent` overlay.

    layman -a raiagent
    layman -S

#### Unmask `fluviol`.

    echo ">=dev-zsh/fluviol-0.01" >> /etc/portage/package.accept_keywords

#### Install `fluviol`.

    emerge -av fluviol

### Non-Gentoo

For all other distributions, please consult your distribution's package manager. If your distribution mournfully fails to package Fluviol, consider a manual installation. As a framework of runtime FVWM and shell scripts, Fluviol requires no compile-time preparations. Manual installation should be a cinch.

#### FVWM-Crystal

If installing under FVWM-Crystal:

    # Create a new path (if not already created) named
    # "~/.fvwm-crystal/recipes/" and move this file there.
    mkdir -p ~/.fvwm-crystal/recipes/
    mv Fluviol ~/.fvwm-crystal/recipes/

    # Open the root menu by right-clicking on the root wallpaper and select:
    #   "Preferences" -> "Used Recipe" -> "User" -> "Fluvio"
    #
    # This change should now be persisted through the next FVWM-Crystal session.
    # But, don't panic! If uncomfortable, understandably, with the over-
    # minimalism of Fluviol, just open the root menu and select another (less
    # minimal) recipe.

If installing directly under FVWM:

    # Create a new path (if not already created) named "~/.fvwm/" and move this
    # this file there as a file named "~/.fvwm/config".
    mkdir -p ~/.fvwm/
    mv Fluviol ~/.fvwm/config

    # Restart FVWM. Blam-oh!

## Synopsis

Fluviol, a minimalist theme framework for FVWM[-Crystal] emphasizing ascetic aesthetics, plaintext configurability, keyboard- and console-centric usability, and `zsh`-driven extensibility (e.g., wallpaper rotation, Kuake consoles).

## Dependencies

Fluviol requires the following mandatory dependencies:

* FVWM2.
* `zsh`.

Fluviol recommends the following optional dependencies:

* FVWM-Crystal.
* Rxvt-unicode (URvxt).
* Esetroot.

### FVWM-Crystal

FVWM-Crystal was a theme framework emphasizing pseudo-transparency, pre-bundled icons, and a GUI-based configuration. (Recommended despite being unmaintained as of early 2008.)

Fluviol plays nicely with FVWM-Crystal. Fluviol detects whether it's running under FVWM-Crystal at runtime and, if so, leverages FVWM-Crystal to auto-populate its root menu, decorate window frames, and so on.

### Shell

#### `zsh`

Fluviol is `zsh`-dependent, for which we mildly apologize. Supporting other shells is somewhat beyond the immediate scope of both the project and our interests. In particular, this means that `bash`, `csh`-ish, and `ksh`-ish shells (e.g., `tcsh`, `mksh`) are not supported. Please continue to use these shells, if you like; but understand that Fluviol may or may not play nicely with them. Why? Because...

`zsh` is, arguably, the most powerful shell. `zsh` is certainly the most configurable, programmable, and expressive shell. `zsh` is, in a word, "useful."

#### Zeshy

Zeshy is a high-level shell scripting language standardizing `zsh` functions, aliases, and variables into components for use from third-party `zsh` applications, homebrew `zsh` scripts, and interactive `zsh` shells.

Zeshy provides dynamic facilities typically associated with more popular platform portable, dynamically typed, interpreted scripting languages (Perl, Python, Ruby, et al.). Ideally, Zeshy reflects the emerging ecologies of:

* Applicability. `zsh` *is* applicable to a mainstream audience.
* Extensibility. `zsh` *is* extensible in a standardized fashion.
* Usability. `zsh` *is* usable for practical, professional, and industrial needs.

`zsh` is blossoming into the mainstream. Join us, and Zeshy, as we zest this stream of software use with zestiness!

### Console

Fluviol is console-centric and thus requires you install a graphical console. Any will do... but some do better. Some, like the Rxvt-forked family of consoles, arguably "do best." Rxvt-forked consoles tend to implement more aesthetically pleasing, efficient, and intuitive interfaces than their better-known alternatives. Stand-out examples include:

* Rxvt-unicode (URxvt). A 2003 fork of Rxvt emphasizing stability, internationalization, and uniform configurability. (Recommended!)
* Aterm. A 1999 fork of Rxvt emphasizing "pleasing visual effects."

Like Aterm, URxvt supports pseudo-transparency. Unlike Aterm, URxvt supports GTK+ and Perl extensions (for runtime customization), Xft-aware fonthandling (for antialiased fonts), and a client/server-style daemon mode (for system resource sharing and re-use). As such - though you can't go wrong with either - the remainder of this document assumes you install URxvt.

### Wallpaper

Fluviol is wallpaper-capable and thus recommends you install a wallpaper switcher. Any will do... but, again, some do better. Examples include:

* Esetroot. A tool dependently bundled with the Eterm graphical terminal. (Recommended, despite having to install Eterm to obtain it.)
* `feh`. A terminal-based image viewer, also serving as wallpaper switcher.
* `habak`. A wallpaper switcher.
* `hsetroot`. Another wallpaper switcher.

First-person evidence indicates that, of the four, Esetroot behaves the most efficiently: that is, the least CPU and memory consumptive. This is important.  Fluviol forks the wallpaper switching process for each desktop page switch.  Low-end machines (e.g., the iBook G3 500Mhz under which Fluviol was first developed) performed poorly with non-Esetroot wallpaper switchers. In particular, they added more than 500ms to the desktop page switch time. So, the remainder of this document assumes you install Esetroot. Unfortunately, this also requires you install Eterm. Fluviol does not recommend you actually use Eterm as your graphical console, however. You're only installing Eterm to obtain Esetroot. (Eterm is fairly outdated as far as modern consoles go.)

# Features

## Virtual Desktops

In FVWM-Crystal and FVWM, the desktop page is a "virtual desktop" having its own set of application windows, window manager settings, and other configurable settings. Desktop pages, like the application windows on a desktop page, can be navigated between with keyboard, mouse, or program request; and, like application windows, can serve to structure information: "I launch my dictionary applet in the upper-right-hand desktop page, Emacs in the center-right-hand desktop page, Mozilla Firefox in the lower-center-hand desktop page, and so on."

Fluviol is created around a 3x3 matrix of desktop pages, where each such page has its own (randomly rotated) wallpaper; its own kuake (Quake) console; and, of course, its own set of application windows.

## Keyboard-centricity

Fluviol is keyboard-centric. That is, it emphasizes keyboard manipulation over mouse usage for most window manager operations, including:

* Application starting, killing, and switching.
* Window movement, minimization, and maximization.
* Desktop page navigation.

The initial author of Fluviol suffers from maladroit carpal tunnel syndrome. Hence, the emphasis on (hopefully ergonomic!) keyboard-driven shortcuts.

## Console-centricity

Fluviol is console-centric. That is, it emphasizes command-line activity over graphical user interface activity by:

* Associating each desktop page with one kuake (Quake) console. This is a full-screen, psuedo-transparent command-line window, mimicing that "window" from iD's Quake.
* Associating the window manager, as a whole, with one bang (!) console. This is a single-line, psuedo-transparent command-line window with which applications may be keyboard-launched, -killed, and otherwise -controlled.

Console-driven manipulation of application windows and window manager artifacts has several inherent "advantages" over the customary, mouse-driven approach. Consoles, themselves, are driven by shells; thus, the consoles above innately, already leverage such command-based mnemonics and shortcuts as: command completion (allowing applications to be launched with only one to several keystrokes), history completion (allowing applications to be re-launched with even fewer), spelling correction, and so on.

## Wallpaper-centricity

Fluviol is wallpaper-centric. That is, it emphasizes the root background over foregrounded windows by:

* Stripping application windows of all thematic decoration. This includes the window frame-attached buttons for killing, minimizing, and maximizing those application windows. (Rather, in this recipe, you must use keyboard shortcuts to kill, minimize, and maximize windows.)
* Stripping the window manager of all thematic decoration. This includes the customary, so-called "Start" menu, quickbar, taskbar, and icon dock.  (Rather, in this recipe, you must use keyboard shortcuts to start and switch between applications, and tail logfiles to obtain the text-equivalent
of the icon dock.)
* Randomly rotating one wallpaper across each desktop page, on some fixed, routine schedule.

While, admittedly, wallpapers are of less pragmatic use than foregrounded windows, wallpapers are typically pleasanter than those windows; and, that being the typical case, are better displayed than such. Which is what Fluviol strives to balance: to paint as much of the painted wallpaper as may be painted while still painting foreground windows, without too severely hiding that wallpaper or those foreground windows. It's a rough balance...but we'll walk it.

## Etymology

The Fluvios are violently cold winds scouring the Mediterranean north of several European nations (especially, France). Fluviol was formerly named "Arlun," from the Welsh word for "painting." The English word "Fluvio" was thought, however, to convey a deeper sense of minimalist aesthetic and, perhaps more importantly, phonetically coincide with the word "Crystal."

The Fluvios bid you, in any case, paint and play on, ye hubris-feed speed painters! Sijun, this idle one's for you; see:

    http://forums.sijun.com/viewtopic.php?t=29807
