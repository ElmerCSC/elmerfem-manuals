SHELL = /bin/sh

manual: 
	pdflatex ElmerTutorials-nonGUI
	make biblio
	makeindex ElmerTutorials-nonGUI
	pdflatex ElmerTutorials-nonGUI
	make biblio
	makeindex ElmerTutorials-nonGUI
	pdflatex ElmerTutorials-nonGUI

update:
	pdflatex ElmerTutorials-nonGUI

biblio:
#	bibtex ElmerTutorials-nonGUI

chmod:
	chmod -R ug+rw,o= .
	chmod ug=rwx figs

view:
	acroread ElmerTutorials-nonGUI.pdf

install:
	mv ElmerTutorials-nonGUI.pdf ..

clean:
	/bin/rm -f *~ .*~ *.log *.aux *.bbl *.blg *.toc *.ilg *.idx *.ind *.out
	/bin/rm -f */*~ */.*~ */*.aux */*.bbl */*.blg */*.log */*.db */*.out




