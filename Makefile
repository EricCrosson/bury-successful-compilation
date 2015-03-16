PACKAGE := bury-successful-compilation
PACKAGE_FILE = $(PACKAGE).el

EMACS := emacs

.PHONY: test

package: *.el
	@ver=`grep -o "Version: .*" $(PACKAGE_FILE) | cut -c 10-`; \
	tar cjvf $(PACKAGE)-$$ver.tar.bz2 --mode 644 `git ls-files '*.el' | xargs`

clean:
	rm -rf $(PACKAGE)-*/ $(PACKAGE)-*.tar* *.elc
	rm -rf $(DEPENDENCIES)

test: echo "success"
