;; ----- 表示 -----
;; 背景色・文字色の設定
(if window-system (progn
	 (setq initial-frame-alist '((width . 100)(height . 45)(left . 0)(top . 0)))
	 (set-background-color "black")  ; 背景色
	 (set-foreground-color "white")  ; 文字色
	 (set-cursor-color "orange")     ; カーソル
))
;; ツールバーの非表示
(tool-bar-mode -1)
;; 行番号の表示(linum)
(require 'linum)
(global-linum-mode 1)
  ;; F5キーでON/OFFさせる
;;  (global-set-key [f5] 'linum-mode)
  ;; 5桁とスペースの領域を割り当てる
  (setq linum-format "%5d ")
;; 透明度の設定
(add-to-list 'default-frame-alist'(alpha . 90))
;; 対応するカッコを強調
(show-paren-mode 1)
;; 選択範囲をハイライトする
(setq-default transient-mark-mode t)
;; 編集行のハイライト
(defface hlline-face
	'((((class color)
			(background dark))
		 (:background "gray19"))
		(((class color)
			(background light))
		 (:background "gray19"))
		(t
		 ()))
	"*Face used by hl-line.")
(setq hl-line-face 'hlline-face)
;; (setq hl-line-face 'underline); 下線
(global-hl-line-mode)
;; いつでもカラー強調を使う
(global-font-lock-mode t)
;; 折り返し表示のON/OFF
(defun toggle-truncate-lines()
	"折り返し表示をトグル動作します。"
	(interactive)
	(if truncate-lines
			(setq truncate-lines nil)
		(setq truncate-lines t))
	(recenter))
	(setq truncate-partial-width-windows nil)

(global-set-key "\C-c\C-l" 'toggle-truncate-lines)

;; Color-theme
(load "color-theme")

;====================================
;;全角スペースとかに色を付ける
;====================================
;(defface my-face-b-1 '((t (:background "medium aquamarine"))) nil)
;(defface my-face-b-1 '((t (:background "dark turquoise"))) nil)
;(defface my-face-b-2 '((t (:background "cyan"))) nil)
;(defface my-face-b-2 '((t (:background "SeaGreen"))) nil)
;(defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
;(defvar my-face-b-1 'my-face-b-1)
;(defvar my-face-b-2 'my-face-b-2)
;(defvar my-face-u-1 'my-face-u-1)
;(defadvice font-lock-mode (before my-font-lock-mode ())
;(font-lock-add-keywords
;major-mode
;'(
;("　" 0 my-face-b-1 append)
;("\t" 0 my-face-b-2 append)
;("[ ]+$" 0 my-face-u-1 append)
;)))
;(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
;(ad-activate 'font-lock-mode)
;(add-hook 'find-file-hooks '(lambda ()
;(if font-lock-mode
;nil
;(font-lock-mode t))))


;; ----- 操作 -----
;; Command+c,vを有効にする
(mac-key-mode 1)
;; MetaキーをOption(alt)キーに変更する
(setq mac-option-modifier 'meta)
;; マウスホイールのスクロール量
(defun scroll-down-with-lines ()
  ""
  (interactive)
  (scroll-down 1)
  )
(defun scroll-up-with-lines ()
   ""
   (interactive)
   (scroll-up 1)
)
(global-set-key [wheel-up] 'scroll-down-with-lines)
(global-set-key [wheel-down] 'scroll-up-with-lines)


;; ----- 動作 -----
;; バックアップファイルを作成しない
(setq make-backup-files nil)
;; タブの設定
(setq default-tab-width 2)
(setq indent-line-function 'indent-relative-maybe)
;; スタートアップページを表示しない
(setq inhibit-startup-message t)

;;; 補完時に大文字小文字を区別しない
(setq completion-ignore-case t)

;;; 強力な補完機能を使う
;;; p-bでprint-bufferとか
;;(load "complete")
(partial-completion-mode 1)

;;; 補完可能なものを随時表示
;;; 少しうるさい
(icomplete-mode 1)

;; 行の先頭でC-kを一回押すだけで行全体を消去する
(setq kill-whole-line t)
;;; カーソルの点滅を止める
(blink-cursor-mode 0)
;; タブ幅
(setq default-tab-width 2)


;; ----- Elisp -----
;; php-mode
(load-library "php-mode")
(require 'php-mode)

;(add-hock 'php-mode-user-hook
;'(lambda ()
;(setq tab-width 2) ; タブ幅を2文字
;(setq indent-tabs-mode nil)) ; タブをスペースに変換
;)

;; 関数一覧
(autoload 'se/make-summary-buffer "summarye" nil t)

;; ECB
(setq load-path (cons (expand-file-name "/Applications/Emacs.app/Contents/Resources/lisp/ecb-2.40") load-path))
(load-file "/Applications/Emacs.app/Contents/Resources/lisp/cedet-1.0pre6/common/cedet.el")
(setq semantic-load-turn-useful-things-on t)
(require 'ecb)
(setq ecb-tip-of-the-day nil)
(setq ecb-windows-width 0.25)
(defun ecb-toggle ()
  (interactive)
  (if ecb-minor-mode
      (ecb-deactivate)
    (ecb-activate)))
(global-set-key [f2] 'ecb-toggle)
(global-set-key "\C-x\C-a" 'ecb-goto-window-methods)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40"))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;; python-mode
(setq auto-mode-alist
      (cons '("\\.py$" . python-mode) auto-mode-alist))
(autoload 'python-mode "python-mode" "Python editing mode." t)

;; j2-mode
(setq-default c-basic-offset 2)

(when (load "js2" t)
  (setq js2-cleanup-whitespace nil
        js2-bounce-indent-flag nil)

  (defun indent-and-back-to-indentation ()
    (interactive)
    (indent-for-tab-command)
    (let ((point-of-indentation
           (save-excursion
             (back-to-indentation)
             (point))))
      (skip-chars-forward "\s " point-of-indentation)))
  (define-key js2-mode-map "\C-i" 'indent-and-back-to-indentation)
  (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode)))

;; css-mode
(defun semicolon-ret ()
  (interactive)
  (insert ";")
  (newline-and-indent)
  )
(defun brace-ret-brace ()
  (interactive)
  (insert "{") (newline-and-indent)
  (newline-and-indent)
  (insert "}") (indent-for-tab-command)
  (newline-and-indent) (newline-and-indent)
  (previous-line) (previous-line) (previous-line)
  (indent-for-tab-command)
  )
(add-hook 'css-mode-hook
              (lambda ()
                (setq css-indent-offset 2)
                (define-key css-mode-map "{" 'brace-ret-brace)
                ))
