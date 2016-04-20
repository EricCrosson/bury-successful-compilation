Bury Successful Compilation (Buffer)
====================================

[![MELPA](http://melpa.org/packages/bury-successful-compilation-badge.svg)](http://melpa.org/#/bury-successful-compilation) [![GNU GPL](http://img.shields.io/:license-gpl3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0.html)

Overview
--------

This package provides [GNU Emacs] hooks to automatically bury the `*compilation*` buffer when compilation succeeds.

Under the Covers
----------------

Like most [Emacs] directives, this package revolves around a largely-consistent but [undocumented] internal feature: the ability to use multi-character register names. This feature was brought to my attention by attention by Magnar Sveen, who you can say provided the [inspiration] that eventually became this project. The ability to create officially-unrecognized register names means the chance of a collision with user data in the same register is almost zero.

`bury-successful-compilation` works by saving the current window configuration to a register before each compilation. If a compilation fails, the saved state is not overwritten until the build succeeds again. This means after an attempted compilation, you can thrash your window configuration to chase down the compile-time issue, because when the build succeeds you will be popped up the stack back to the saved window configuration, right before your unsuccessful compilation attempt.

[Emacs]: https://www.gnu.org/software/emacs/
[GNU Emacs]: https://www.gnu.org/software/emacs/
[undocumented]: https://www.emacswiki.org/emacs/WindowsAndRegisters
[inspiration]: http://whattheemacsd.com/setup-magit.el-01.html
