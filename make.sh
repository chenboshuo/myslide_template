# make the build directory
mkdir _build

# make ebook file
echo "\documentclass[ebook]{myslide}" > ebook.tex
awk 'FNR>4' main.tex >> ebook.tex
xelatex ebook.tex
xelatex ebook.tex
mv ebook.pdf _build/ebook.pdf

# make plain book file
echo "\documentclass[plain]{myslide}" > plain.tex
awk 'FNR>4' main.tex >> plain.tex
xelatex plain.tex
xelatex plain.tex
mv plain.pdf _build/plain.pdf

# make silde file
echo "\documentclass[slide]{myslide}" > slide.tex
awk 'FNR>4' main.tex >> slide.tex
xelatex slide.tex
xelatex slide.tex
mv slide.pdf _build/slide.pdf

# make silde file
echo "\documentclass[slide,handout]{myslide}" > handout.tex
awk 'FNR>4' main.tex >> handout.tex
xelatex handout.tex
xelatex handout.tex
mv handout.pdf _build/handout.pdf


rm ./ebook.tex
rm ./plain.tex
rm ./slide.tex
rm ./handout.tex
