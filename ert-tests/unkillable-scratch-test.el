(require 'bury-successful-compilation)

(ert-deftest test-default-behavior ()
  ;; test the default functionality
  (bury-successful-compilation nil)
  (compile "echo 'hi mom'")
  (should (get-buffer "*compilation*")))

(ert-deftest test-bury-successful-compilation-behavior ()
  ;; test the modified functionality
  (bury-successful-compilation t)
  (compile "echo 'hi mom'")
  (sleep-for 0 10)
  (should (eq nil (get-buffer-window-list "*compilation*"))))

(provide 'bury-successful-compilation-test)
;;; bury-successful-compilation-test.el ends here
