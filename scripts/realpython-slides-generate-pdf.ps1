Param($input_source)

$input_source = Convert-Path $input_source
$dest = "C:\dev\rp\rp-slides\slides.md"

Copy-Item $input_source $dest

make -C "C:\dev\rp\rp-slides\" pdf

Copy-Item `
"C:\dev\rp\rp-slides\slides.pdf" `
"$((Get-item $input_source).Directory)\slides.pdf"
