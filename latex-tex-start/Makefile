SHELL = /bin/sh

manual: 
	pdflatex TexStart
#	make biblio
	makeindex TexStart
	pdflatex TexStart
#	make biblio
	makeindex TexStart
	pdflatex TexStart

update:
	pdflatex TexStart

bib:
	sh loopchapterbib;

biblio:
	bibtex TexStart/TexStart

chmod:
	chmod -R ug+rw,o= .
	chmod ug=rwx figs

view:
	acroread TexStart.pdf

install:
	mv TexStart.pdf ..

clean:
	/bin/rm -f *~ .*~ *.log *.aux *.bbl *.blg *.toc *.ilg *.idx *.ind *.out
	/bin/rm -f */*~ */.*~ */*.aux */*.bbl */*.blg */*.log */*.db




