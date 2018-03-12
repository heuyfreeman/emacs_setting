(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; You may delete these explanatory comments.
;; just comment it out by adding a semicolon to the start of the line.
(require 'package)
(setq package-archives
     '(("gnu" . "http://elpa.gnu.org/packages/")
       ("melpa" . "http://melpa.org/packages/")
       ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")
        ("marmalade" . "https://marmalade-repo.org/packages/")))
(package-initialize)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 個人用設定                                  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; 右から左に読む言語に対応させないことで描画高速化
(setq-default bidi-display-reordering nil)

;;; splash screenを無効にする
(setq inhibit-splash-screen t)

;;; 同じ内容を履歴に記録しないようにする
(setq history-delete-duplicates t)

;; C-u C-SPC C-SPC ...でどんどん過去のマークを遡る
(setq set-mark-command-repeat-pop t)

;;; 複数のディレクトリで同じファイル名のファイルを開いたときのバッファ名を調整する
(require 'uniquify)
;; filename<dir> 形式のバッファ名にする
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "[^*]+")

;;; ファイルを開いた位置を保存する
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (concat user-emacs-directory "places"))

;;; 釣合う括弧をハイライトする
(show-paren-mode 1)

;;; 現在行に色をつける
(global-hl-line-mode 1)

;;; ミニバッファ履歴を次回Emacs起動時にも保存する
(savehist-mode 1)

;;; シェルに合わせるため、C-hは後退に割り当てる
(global-set-key (kbd "C-h") 'delete-backward-char)

;;; モードラインに時刻を表示する
(display-time)

;;; 行番号・桁番号を表示する
(line-number-mode 1)
(column-number-mode 1)

;;; GCを減らして軽くする
(setq gc-cons-threshold (* 10 gc-cons-threshold))

;;; ログの記録行数を増やす
(setq message-log-max 10000)

;;; 履歴をたくさん保存する
(setq history-length 1000)

;;; メニューバーとツールバーとスクロールバーを消す
;;(menu-bar-mode -1)
;;(tool-bar-mode -1)

;;個人用マクロ
(fset 'e1
   "\C-[xeww\C-memacs.rubikitch.com/;\C-?category/books/sd-emacs-rensai")


;; P60-61 Elisp配置用のディレクトリを作成
;; Emacs 23より前のバージョンを利用している方は
;; user-emacs-directory変数が未定義のため次の設定を追加
(when (< emacs-major-version 23)
  (defvar user-emacs-directory "~/.emacs.d/"))

;; load-path を追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "conf" "public_repos")

;;M-x custom-optionでpackage-archives
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes nil)
 '(markdown-command "pandoc")
 '(package-selected-packages
   (quote
    (smarty-mode markdown-preview-mode markdown-mode markdown-mode+ pandoc yasnippet-snippets yasnippet web-mode package-utils auto-complete php-mode yaml-mode pcre2el helm browse-kill-ring visual-regexp bm goto-chg recentf-ext wgrep dired-toggle dired-details ace-jump-mode migemo ddskk dict-tree))))


;; M-x skk-tutorialでNo file found as ?とエラーが出たときにskk-tut-fileを設定
;; make what-whereでSKK tutorialsで表示されるディレクトリ上のSKK.tutを指定
;Qnap用(setq skk-tut-file "/share/CACHEDEV1_DATA/homes/admin/.emacs.d/elpa/ddskk-20170;709.839/SKK.tut")
(require 'skk)
(global-set-key "\C-x\C-j" 'skk-mode)
;;見出し語入力中入力候補がでる。変換したい時はM-SPC
(setq skk-dcomp-activate t)

;; migemo.elからcmigemoを使う初期設定
(when (locate-library "migemo")
  (setq migemo-command "/usr/local/bin/cmigemo") ; HERE cmigemoバイナリ
  (setq migemo-options '("-q" "--emacs"))
  (setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict") ; HERE Migemo辞書
  (setq migemo-user-dictionary nil)
  (setq migemo-regex-dictionary nil)
  (setq migemo-coding-system 'utf-8-unix)
  (load-library "migemo")
  (migemo-init))

;; ace-jump-mode設定 "C-o"に割当て
(require 'ace-jump-mode)
(setq ace-jump-word-mode-gray-background nil)
(setq ace-jump-word-mode-use-query-char nil)
(setq ace-jump-mode-move-keys(append "asdfghjkl;:]qwertyuiop@zxcbnm,." nil))
(global-set-key (kbd "C-o") 'ace-jump-word-mode)

;;dabbrev-expand(略語展開）
(global-set-key (kbd "C-@") 'dabbrev-expand)
;; dired-details/dired-toggleを使うための設定
(require 'dired)
(require 'dired-details)
(dired-details-install)
(setq dired-details-hidden-string "")
(setq dired-details-hide-link-targets nil)

;;グローバルセットキー
(global-set-key (kbd "C-t") 'other-window);C-x o
(global-set-key (kbd "C-x C-b") 'bs-show)

;; wgrepの設定
(require 'wgrep)
(setq wgrep-change-readonly-file t)
(setq wgrep-enable-key "e")

;;idoの初期設定
(ido-mode 1)
(ido-everywhere 1)

;;ffap初期設定
(ffap-bindings)

;; 最近のファイル500個を保存する
(setq recentf-max-saved-items 500)
;; 最近使ったファイルに加えないファイルを
;; 正規表現で指定する
(setq recentf-exclude
      '("/TAGS$" "/var/tmp/"))
(require 'recentf-ext)

;;point-undoの初期設定
;; (require 'point-undo)
;; (global-set-key [f7] 'point-undo)
;; (global-set-key [f1 f7] 'point-redo)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	    	;Helm                                                         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'helm-config)
(helm-mode 1)

;;goto-chg初期設定
(require 'goto-chg)
(global-set-key [f8] 'goto-last-change)
(global-set-key [f1 f8] 'goto-last-change-reverse)

;;正規表現で置換（visual-regexp-steroidsはUPDATEでなくなった2018.3.4)
(require 'visual-regexp)
;; (require 'visual-regexp-steroids)	
(setq vr/engine 'pcre2el)
(global-set-key (kbd "M-%") 'vr/query-replace)
(define-key vr/minibuffer-keymap (kbd "C-j") 'skk-insert)

;; browse-kill-ring初期設定
(global-set-key (kbd "M-y") 'browse-kill-ring)

;; toggle-truncate
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)

;;asciiフォントをRicty Diminishedに
(set-face-attribute 'default nil
		    :family "Ricty Diminished"
		    :height 120)


;; 日本語フォントをNoto Serif CJK JPに
(set-fontset-font
 nil 'japanese-jisx0208
 (font-spec :family "Noto Serif CJK JP"))

;; ひらがなとカタカナをNoto Sans CJK JPに
;; U+3000-303F  CJKの記号および句読点
;; U+3040-309F  ひらがな
;; U+30A0-30FF  カタカナ
(set-fontset-font
 nil '(#x3040 . #x30ff)
 (font-spec :family "Noto Sans CJK JP"))

;; Notoフォントの横幅を調整
;; (add-to-list 'face-font-rescale-alist '(".*Noto.*" . 1.2))


;;空白を可視化する
(require 'whitespace)
(setq whitespace-style '(face           ; faceで可視化
                         trailing       ; 行末
                         tabs           ; タブ
                         spaces         ; スペース
                         empty          ; 先頭/末尾の空行
                         space-mark     ; 表示のマッピング
                         tab-mark
                         newline
			 newline-mark
                         ))

(setq whitespace-display-mappings
      '((space-mark ?\u3000 [?\u25a1])	;空白をどう表示するか
        ;; WARNING: the mapping below has a problem.
        ;; When a TAB occupies exactly one column, it will display the
        ;; character ?\xBB at that column followed by a TAB which goes to
        ;; the next TAB column.
        ;; If this is a problem for you, please, comment the line below.
	(tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t]) ;タブ
	(newline-mark ?\n   [?$ ?\n])  ; 改行記号をドルマーク
     ))
;;スペースは全角のみを可視化（White-space を正規表現で定義
(setq whitespace-space-regexp "\\(\u3000+\\)")

;; 保存前に自動でクリーンアップ
;;(setq whitespace-action '(auto-cleanup))

;white-space-modeを有効化
(global-whitespace-mode 1)

;;custom-set-faces
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((t (:foreground "indian red"))))
 '(font-lock-constant-face ((t (:foreground "deep sky blue"))))
 '(font-lock-string-face ((t (:foreground "green4"))))
 '(web-mode-doctype-face ((t (:foreground "light salmon"))))
 '(web-mode-html-attr-name-face ((t (:foreground "DeepPink4"))))
 '(web-mode-html-tag-bracket-face ((t (:foreground "dim gray"))))
 '(web-mode-html-tag-face ((t (:foreground "blue")))))


;; auto-completeの設定。言語系のメジャーモードで入力候補を表示
(when (require 'auto-complete-config nil t)
  (ac-config-default)
  (setq ac-use-menu-map t)
  (setq ac-ignore-case nil))


;;テンプレートを自動で挿入
(auto-insert-mode)
;; 最後の/は必須
(setq auto-insert-directory "~/.emacs.d/insert/")
(define-auto-insert "\\.html$" "html-template.html")

;; yasnippet略語からスニペットを展開する
;;20180201現在,下記設定を有効にすると、Gtk-CRITICALエラーが発生する。
(yas-global-mode 1)
;; ;; スニペット名をidoで選択する
(setq yas-prompt-functions '(yas-ido-prompt))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 各種言語の開発環境                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; web-mode
(when (require 'web-mode nil t)
  ;; 自動的にweb-modeを起動したい拡張子を追加する
  (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
  ;; (add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.ctp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))

  (setq web-mode-engines-alist
      '(("php"    . "\\.phtml\\'")
        ("blade"  . "\\.blade\\."))
  )
 ;; web-modeのインデント設定用フック
   (defun web-mode-hook ()
  ;; "Hooks for Web mode."
     (setq web-mode-markup-indent-offset 2) ; HTMLのインデイント
     (setq web-mode-css-indent-offset 2) ; CSSのインデント
     (setq web-mode-code-indent-offset 2) ; JS, PHP, Rubyなどのインデント
  ;;   (setq web-mode-comment-style 2) ; web-mode内のコメントのインデント
  ;;   (setq web-mode-style-padding 1) ; <style>内のインデント開始レベル
  ;;   (setq web-mode-script-padding 1) ; <script>内のインデント開始レベル
     )
   (add-hook 'web-mode-hook  'web-mode-hook)
)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;               MarkDown Mode          ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
