
<!-- README.md is generated from README.qmd. Please edit that file -->

# Beautiful, Reproducible Tables in `R`

> Last updated 2024-01-22 at 14:40 EST.

This is a workshop I led at UGA’s Infectious Disease Interest Group
seminar meeting on 2024-01-24. If you just want to see the presentation,
you should jump straight to the [tables.pptx](tables.pptx) file. The
code examples are all in the [R](./R/) directory.

<!-- badges: start -->
<!-- badges: end -->

## Contents Summary

- `R`: contains `R` scripts and quarto documents which run code.
  - `data-loading.R`: loads in the raw csv data, makes some small
    changes, and exports to Rds format.
  - `tables.R`: makes the table examples.
  - `idig-tables.qmd`: an example of including the tables in a quarto
    document.
- `results`: contains any figures and table figures made by the code.
- `static`: contains any other media that doesn’t get edited by code.
  - data files, in (raw) CSV and (processed) Rds formats.
  - images of three sample butterflies for demonstration (see licensing
    section for more information).
  - the demo paper (in Word and PDF formats) that I needed to make to
    take a screenshot for the presentation.
- `tables.pptx`: the final powerpoint for my seminar presentation.
- Everything else is a housekeeping or documentation file.

## Useful Links

- [`gt` website](https://gt.rstudio.com/)
- [`gtsummary` website](https://www.danieldsjoberg.com/gtsummary/)
- [`gtextras` website](https://jthomasmock.github.io/gtExtras/)
- [`modelsummary` website](https://modelsummary.com/)
- [`R` graph gallery tables
  section](https://r-graph-gallery.com/table.html)
- [Posit Community Table
  Gallery](https://community.rstudio.com/c/table-gallery/64)

## Reproducibility

To run the code in this repository you should do the following steps.

1.  Install `R`, `Quarto`, and (optionally) `RStudio`.
    - `R` version at time of writing: R version 4.3.2 (2023-10-31 ucrt).
    - `Rstudio` version at time of writing: 2023.12.0.369.
    - `Quarto` version at time of writing: 1.3.340.
    - Complete `R` session information can be found in
      [`session-info.txt`](session-info.txt).
2.  Install `renv` (version 1.0.3 at time of writing).
3.  Open `idig-tables.Rproj` in RStudio. The `renv` package should give
    you instructions for continuing. Run `renv::restore()` to download
    and install the package versions I used for making this
    presentation.
4.  You should then be able to run/render any `R` code or quarto
    documents in this repository.

## Licensing

**Text and figures:** all text and images I create in this repository
are licensed under the Creative Commons
Attribution-NonCommercial-ShareAlike 4.0 International License, [CC
BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).

**Code:** all code created by me is licensed under the GNU Affero
General Public License, [AGPL 3.0](LICENSE.md).

**Images not created by me:** all images in the powerpoint have their
source reported and are used under Fair Use for educational purposes.

The following files are also used in this tutorial from Wikipedia under
various Creative Commons licenses, which are applicable for this work.
\* `longwing1`:
<https://commons.wikimedia.org/wiki/File:Papilio_ulysses_gabrielus_0zz.jpg>
\* `longwing2`:
<https://commons.wikimedia.org/wiki/File:Papilio_ulysses_autolycus_0zz.jpg>
\* `longwing3`:
<https://commons.wikimedia.org/wiki/File:Papilio_ulysses_joesa.jpg>

## Contact Info

Please see my website for contact information: <https://wzbillings.com>.
