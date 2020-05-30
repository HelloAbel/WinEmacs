(add-to-list 'load-path (expand-file-name "~\\.emacs.d\\lisp"))
;;; Always do syntax highlighting  
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)
;; 将包管理器的源换成清华大学的镜像
(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/marmalade/") t)
(add-to-list 'package-archives '("elpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/") t)
(add-to-list 'package-archives '("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/") t)

(require 'cl)

;; 每次启动都检查是否安装默认软件
(defvar xzh/packages '(
                       company
                       company-c-headers
                       company-irony
                       company-irony-c-headers
                       cuda-mode
                       rust-mode
                       all-the-icons
                       badwolf-theme
                       dash
                       doom-modeline
                       doom-themes
                       irony
                       grip-mode
                       treemacs
                       markdown-mode
                       ) "Default Packages")
(setq package-selected-packages xzh/packages)

(defun xzh/packages-installed-p ()
    (loop for pkg in xzh/packages
          when (not (package-installed-p pkg)) do (return nil)
          finally (return t)))

(unless (xzh/packages-installed-p)
    (message "%s" "Refreshing package database...")
    (package-refresh-contents)
    (dolist (pkg xzh/packages)
      (when (not (package-installed-p pkg))
        (package-install pkg))))

;; 使用C-x C-r打开最近打开文件列表
(require 'recentf)
(recentf-mode 1)			
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; 使用F2打开配置文件
(defun open-my-init-file()
  (interactive)
  (find-file "~/.emacs.d/lisp/init.el"))
(global-set-key (kbd "<f2>") 'open-my-init-file)

;; 设置在emacs打开scheme解释器为chezscheme
(global-font-lock-mode 1)  
;;; Also highlight parens  
(setq show-paren-delay 0 
show-paren-style 'parenthesis)  
(show-paren-mode 1)  
;;; This is the binary name of my scheme implementation  
(setq scheme-program-name "chezscheme")

;; 设置显示行号
(global-linum-mode t)
(setq linum-format "%d ")

;; 不显示欢迎屏幕
(setq inhibit-startup-message t) 
(setq gnus-inhibit-startup-message t) 

;; 设置缩进
(add-hook 'c-mode-common-hook
          '(lambda()
             (c-set-style "cc-mode")))
(setq-default tab-width 4)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (wombat)))
 '(initial-frame-alist (quote ((fullscreen . maximized))))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
;;设置英文字体
(set-face-attribute
 'default nil :font "Consolas bold 14")
;;设置中文字体
(dolist (charset '(kana han symbol cjk-misc bopomofo))
  (set-fontset-font (frame-parameter nil 'font)
            charset
            (font-spec :family "Microsoft Yahei UI" :size 16)))

(package-initialize)

;;(setenv "GTAGSLIBPATH" (concat "/usr/include"
;;                               ":"))
;;(setenv "MAKEOBJDIRPREFIX" (file-truename "~/obj/"))
;;(setq company-backends '((company-dabbrev-code company-gtags)))
;;(setq tab-always-indent t)
;;(add-hook 'c++-mode-hook 'global-company-mode)
(setq-default indent-tabs-mode  nil)

;;设置默认全屏


;; 显示括号匹配
(show-paren-mode t)
(setq show-paren-style 'parentheses)
;; 语法高亮
(global-font-lock-mode t)
;; 以 y/n代表 yes/no
(fset 'yes-or-no-p 'y-or-n-p)
;; 支持emacs和外部程序的粘贴
(setq x-select-enable-clipboard t)
;; 在标题栏提示打开文件的绝对路径
(setq frame-title-format '("xzh@" (buffer-file-name "%f" (dired-directory dired-directory "%b"))))
;; 设置假期，在日历中可以看到
(setq calendar-holidays '((holiday-chinese 1 1 "春节")
                          (holiday-chinese 1 15 "元宵节")
                          (holiday-fixed 3 8 "妇女节")
                          (holiday-fixed 4 5 "清明节")
                          (holiday-fixed 5 1 "劳动节")
                          (holiday-fixed 6 1 "儿童节")
                          (holiday-chinese 5 5 "端午节")
                          (holiday-chinese 7 7 "七夕节")
                          (holiday-chinese 7 15 "鬼节")
                          (holiday-chinese 8 15 "中秋节")
                          (holiday-chinese 9 9 "重阳节")
                          (holiday-fixed 10 1 "国庆节")
                          (holiday-chinese 9 16 "我的生日")))
;; 显示光标所在的函数名
(which-function-mode 1)
;; 当找不到函数时显示undefined
(setq which-func-unknown "undefined")

;; 自动补全，使用irony后端
;; (require 'init-auto-complete)
(add-hook 'after-init-hook'global-company-mode)
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
;; Windows performance tweaks
;;
(when (boundp 'w32-pipe-read-delay)
  (setq w32-pipe-read-delay 0))
;; Set the buffer size to 64K on Windows (from the original 4K)
(when (boundp 'w32-pipe-buffer-size)
  (setq irony-server-w32-pipe-buffer-size (* 64 1024)))
  

;; 使用doom-modeine显示底边栏
(require 'doom-modeline)
(doom-modeline-mode 1)
  
(provide 'init)
