# bury-successful-compilation [![Build Status](https://travis-ci.org/EricCrosson/bury-successful-compilation.svg?branch=master)](https://travis-ci.org/EricCrosson/bury-successful-compilation) [![MELPA](http://melpa.org/packages/bury-successful-compilation-badge.svg)](http://melpa.org/#/bury-successful-compilation)

> Automatically bury the \*compilation\* buffer when compilation succeeds

## Install

From [MELPA](https://melpa.org/)

``` {.sourceCode .lisp}
(use-package bury-successful-compilation
  :ensure t
  :bind ("C-c C-m" . recompile))
```

Or manually, after downloading into your `load-path`

``` {.sourceCode .lisp}
(require 'bury-successful-compilation)
```

## Under the Covers

Like most [Emacs](https://www.gnu.org/software/emacs/) directives,
this package revolves around a largely-consistent but
[undocumented](https://www.emacswiki.org/emacs/WindowsAndRegisters)
internal feature: the ability to use multi-character register
names. This feature was brought to my attention by attention by Magnar
Sveen, who you can say provided the
[inspiration](http://whattheemacsd.com/setup-magit.el-01.html) that
eventually became this project. The ability to create
officially-unrecognized register names means the chance of a collision
with user data in the same register is almost zero.

`bury-successful-compilation` works by saving the current window
configuration to a register before each compilation. If a compilation
fails, the saved state is not restored until the build succeeds
again. This means after an attempted compilation, you can thrash your
window configuration to chase down the compile-time issue, because
when the build succeeds you will be popped up the stack back to the
saved window configuration, right before your unsuccessful compilation
attempt.

<!-- ## Example -->

<!-- TODO -->

## License

GPL 2 (or higher) © [Free Software Foundation, Inc](http://www.fsf.org/about).
