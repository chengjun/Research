---

## Using Pandoc to make simple slides

### weibo.com/frankwang


![](http://www.onefunnyjoke.com/wp-content/uploads/2013/07/%E8%B6%85%E7%BE%8E%EF%BC%81%E5%8E%9F%E4%BE%86%E9%AB%98%E7%88%BE%E5%A4%AB%E7%90%83%E8%A3%A1%E9%9D%A2%E9%95%B7%E9%80%99%E6%A8%A31-600x480.jpg)

---

## What is pandoc?

+ [Pandoc](http://johnmacfarlane.net/pandoc/README.html) is a Haskell library for converting from one markup format to another, and a command-line tool that uses this library.

+ It can read markdown and (subsets of) Textile, reStructuredText, HTML, LaTeX, MediaWiki markup, and DocBook XML

+ It can write plain text, markdown, reStructuredText, XHTML, HTML 5, LaTeX (including beamer slide shows), ConTeXt, RTF, DocBook XML, OpenDocument XML, ODT, Word docx, GNU Texinfo, MediaWiki markup, EPUB (v2 or v3), FictionBook2, Textile, groff man pages, Emacs Org-Mode, AsciiDoc, and Slidy, Slideous, DZSlides, or S5 HTML slide shows. 

+ It can also produce PDF output on systems where LaTeX is installed.

---

## Step 1: Install pandoc

+ First, install pandoc, following [the instructions for your platform.](http://johnmacfarlane.net/pandoc/installing.html)

+ You may need to restart you computer.

---

## Step 2: Prepare markdown files

something like [this one](https://dl.dropboxusercontent.com/u/404516/dzslides/markdown.md).

---

## Step 3. Convert the markdown file to slides

+ On windows, open powershell, cd to the directory of the markdown file
+ use this pandoc code:


    pandoc -s -S -i -t dzslides --mathjax intro.md -o slides.html

+ Put the generated html file into your **public folder** of your dropbox, or your github, or your website.

---

![](http://www.wall321.com/thumbnails/detail/20120813/green%20red%20eyes%20frogs%20redeyed%20tree%20frog%20amphibians%205381x3583%20wallpaper_www.wall321.com_57.jpg)

---

## Reference

+ Tutorial <http://yihui.name/slides/knitr-slides.html#1.0>

+ R markdown <http://dl.dropboxusercontent.com/u/15335397/slides/BioC-2013-Yihui-Xie.Rpres>

+ Pandoc <http://johnmacfarlane.net/pandoc/getting-started.html>

