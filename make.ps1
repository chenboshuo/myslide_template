function build {
  param (
    $fileName
  )

  xelatex -output-directory="./build" $fileName".tex"
  bibtex ./build/$fileName
  xelatex -output-directory="./build" $fileName".tex"
  xelatex -output-directory="./build" $fileName".tex"
}

function add_extra {
  param (
    $fileName
  )

  Get-Content main.tex |
  Select-Object -Skip 6 |
  Out-File $fileName -Append
}

# encoding
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

# make build directory
mkdir -p build


# make slide
echo "\documentclass[slide]{myslide}" |
  Out-File slide.tex
add_extra slide.tex
build slide
rm slide.tex

# make ebook
echo "\documentclass[ebook]{myslide}" |
  Out-File ebook.tex
add_extra ebook.tex
build ebook
rm ebook.tex

# make print version
echo "\documentclass[plain]{myslide}" |
  Out-File print.tex
add_extra print.tex
build print
rm print.tex

# make handout version
echo "\documentclass[plain]{myslide}" |
  Out-File handout.tex
add_extra handout.tex
build handout
rm handout.tex

Read-Host
