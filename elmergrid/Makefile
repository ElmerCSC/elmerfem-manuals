SHELL = /bin/sh

manual: 
	pdflatex manual
	makeindex manual
	pdflatex manual
	pdflatex manual

update:
	pdflatex manual

chmod:
	chmod -R ug+rw,o= .
	chmod ug=rwx figs

view:
	acroread manual.pdf

install:
	mv manual.pdf ../ElmerGridManual.pdf

clean:
	/bin/rm -f *~ .*~ *.log *.aux *.bbl *.blg *.toc *.ilg *.idx *.ind
	/bin/rm -f */*~ */.*~ */*.aux */*.bbl */*.blg */*.log 




