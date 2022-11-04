SHELL = /bin/sh

manual: 
	pdflatex ElmerTutorials
	make biblio
	makeindex ElmerTutorials
	pdflatex ElmerTutorials
	make biblio
	makeindex ElmerTutorials
	pdflatex ElmerTutorials

update:
	pdflatex ElmerTutorials

bib:
	sh loopchapterbib;

biblio:
#	bibtex CapacitanceOfTwoBalls/CapacitanceOfTwoBalls

chmod:
	chmod -R ug+rw,o= .
	chmod ug=rwx figs

view:
	acroread ElmerTutorials.pdf

install:
	mv ElmerTutorials.pdf ..

clean:
	/bin/rm -f *~ .*~ *.log *.aux *.bbl *.blg *.toc *.ilg *.idx *.ind *.out
	/bin/rm -f */*~ */.*~ */*.aux */*.bbl */*.blg */*.log */*.db




