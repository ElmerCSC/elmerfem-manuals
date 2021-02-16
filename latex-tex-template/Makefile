SHELL = /bin/sh

manual: 
	pdflatex TexTemplate
#	make biblio
	makeindex TexTemplate
	pdflatex TexTemplate
#	make biblio
	makeindex TexTemplate
	pdflatex TexTemplate

update:
	pdflatex TexTemplate

bib:
	sh loopchapterbib;

biblio:
	bibtex TexTemplate/TexTemplate

chmod:
	chmod -R ug+rw,o= .
	chmod ug=rwx figs

view:
	acroread TexTemplate.pdf

install:
	mv TexTemplate.pdf ..

clean:
	/bin/rm -f *~ .*~ *.log *.aux *.bbl *.blg *.toc *.ilg *.idx *.ind *.out
	/bin/rm -f */*~ */.*~ */*.aux */*.bbl */*.blg */*.log */*.db




