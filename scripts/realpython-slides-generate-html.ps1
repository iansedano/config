Param($input_source)

$input_source = Convert-Path $input_source
$dest = "C:\dev\rp\rp-slides\slides.md"

Copy-Item $input_source $dest

make -C "C:\dev\rp\rp-slides\" html

Copy-Item `
"C:\dev\rp\rp-slides\slides.html" `
"$((Get-item $input_source).Directory)\slides.html"
