SHELL = /bin/sh

manual: 
	pdflatex ElmerGUIManual
	make biblio
	makeindex ElmerGUIManual
	pdflatex ElmerGUIManual
	make biblio
	makeindex ElmerGUIManual
	pdflatex ElmerGUIManual

update:
	pdflatex ElmerGUIManual

biblio:
	bibtex ElmerGUIManual

chmod:
	chmod -R ug+rw,o= .
	chmod ug=rwx figs

view:
	acroread ElmerGUIManual.pdf

install:
	mv ElmerGUIManual.pdf ..

clean:
	/bin/rm -f *~ .*~ *.log *.aux *.bbl *.blg *.toc *.ilg *.idx *.ind *.out
	/bin/rm -f */*~ */.*~ */*.aux */*.bbl */*.blg */*.log */*.db 




