SHELL = /bin/sh

manual: 
	pdflatex GetStartedElmer
#	make biblio
	makeindex GetStartedElmer
	pdflatex GetStartedElmer
#	make biblio
	makeindex GetStartedElmer
	pdflatex GetStartedElmer

update:
	pdflatex GetStartedElmer

bib:
	sh loopchapterbib;

biblio:
	bibtex GetStartedElmer/GetStartedElmer

chmod:
	chmod -R ug+rw,o= .
	chmod ug=rwx figs

view:
	acroread GetStartedElmer.pdf

install:
	mv GetStartedElmer.pdf ..

clean:
	/bin/rm -f *~ .*~ *.log *.aux *.bbl *.blg *.toc *.ilg *.idx *.ind *.out
	/bin/rm -f */*~ */.*~ */*.aux */*.bbl */*.blg */*.log */*.db




