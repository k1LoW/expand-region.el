(Given "^mark is inactive by default$"
       (lambda ()
         (setq set-mark-default-inactive t)))

(Given "^er/try-expand-list by default$"
       (lambda ()
         (setq er/try-expand-list '(er/mark-word
                                    er/mark-symbol
                                    er/mark-symbol-with-prefix
                                    er/mark-next-accessor
                                    er/mark-method-call
                                    er/mark-comment
                                    er/mark-comment-block
                                    er/mark-inside-quotes
                                    er/mark-outside-quotes
                                    er/mark-inside-pairs
                                    er/mark-outside-pairs))))

(When "^I expand the region$"
      (lambda ()
        (flet ((message (&rest args) nil))
          (er/expand-region 1))))

(When "^I quit$"
      (lambda ()
        (flet ((signal (&rest args) nil))
          (keyboard-quit))))

(When "^I expand the region \\([0-9]+\\) times$"
      (lambda (arg)
        (flet ((message (&rest args) nil))
          (er/expand-region (string-to-number arg)))))

(And "^I contract the region$"
     (lambda ()
       (er/contract-region 1)))

(When "^I pop the mark$"
      (lambda ()
        (set-mark-command 4)))

(When "^I deactivate the mark$"
      (lambda ()
        (deactivate-mark)))

(When "^I activate the mark$"
      (lambda ()
        (activate-mark)))

(Then "^the region should not be active$"
      (lambda ()
        (should
         (not (region-active-p)))))

(Then "^cursor should be at point \"\\(.+\\)\"$"
      (lambda (arg)
        (should
         (=
          (string-to-number arg)
          (point)))))

(When "^I add \\(.+\\) to er/try-expand-list"
      (lambda (arg)
        (add-to-list 'er/try-expand-list (intern-soft arg))))

(Then "^the region length \"\\(.+\\)\"$"
      (lambda (arg)
        (should
         (=
          (string-to-number arg)
          (- (region-end) (region-beginning))))))
