#import "invoice-maker.typ": *

#show: invoice.with(
  //banner-image: image("banner.png"),
  data: toml("invoice.toml"),
  styling: ( font: none ), // Explicitly use Typst's default font
)
