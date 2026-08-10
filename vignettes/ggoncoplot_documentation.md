# Oncoplot Analysis Documentation

> **Not yet released.** The `ggoncoplot` analysis is not part of OncoPath 1.0.4. It is on a
> development or test menu route in the umbrella ClinicoPath module and does not appear
> in any jamovi menu yet. It is documented here ahead of a future release, so its
> options, defaults and output may still change. For the analyses OncoPath ships today
> - `waterfall`, `swimmerplot`, `ihcheterogeneity` and `diagnosticmeta` - see the
> [OncoPath articles index](https://www.serdarbalci.com/OncoPath/articles/).


This document provides a comprehensive overview of the Oncoplot Analysis module (ggoncoplot), detailing its features, user interface elements, and the underlying R functions.

## Feature Summary

The ggoncoplot module is a specialized tool for visualizing genomic alterations across a cohort of samples, typically used in cancer genomics. It provides a concise and informative way to display mutation profiles, copy number variations, and other genomic events for a set of genes and samples.

The module's features can be broadly categorized as follows:

*   **Core Oncoplot Generation:** Visualize genomic alterations across samples and genes.
*   **Gene and Sample Grouping:** Group genes and samples based on various criteria (e.g., pathways, clinical subgroups).
*   **Alteration Type Customization:** Define and color different types of genomic alterations (e.g., missense, frameshift, deletion).
*   **Annotation Tracks:** Add clinical or genomic annotations to samples and genes for integrated visualization.
*   **Export Options:** Capabilities to save the generated oncoplots in various high-quality formats.

## Feature Details

The following table provides a detailed mapping of the module's features, from the user interface to the underlying R functions.

| Feature                          | YAML Argument (`.a.yaml`)      | UI Label                               | Results Section (`.r.yaml`)         | R Function (`.b.R`)                  |
| -------------------------------- | ------------------------------ | -------------------------------------- | ----------------------------------- | ------------------------------------ |
| **Core Analysis**                |                                |                                        |                                     |                                      |
| Genomic Data                     | `genomicData`                  | Genomic Data                           | `oncoplotOverview`                  | `.prepareOncoplotData`               |
| Sample ID                        | `sampleID`                     | Sample ID Variable                     | `oncoplotOverview`                  | `.prepareOncoplotData`               |
| Gene ID                          | `geneID`                       | Gene ID Variable                       | `oncoplotOverview`                  | `.prepareOncoplotData`               |
| Alteration Type                  | `alterationType`               | Alteration Type Variable               | `oncoplotOverview`                  | `.prepareOncoplotData`               |
| **Visualization Options**        |                                |                                        |                                     |                                      |
| Show Oncoplot                    | `showOncoplot`                 | Show Oncoplot                          | `oncoplot`                          | `.plotOncoplot`                      |
| Gene Order                       | `geneOrder`                    | Gene Order                             | `oncoplot`                          | `.plotOncoplot`                      |
| Sample Order                     | `sampleOrder`                  | Sample Order                           | `oncoplot`                          | `.plotOncoplot`                      |
| Alteration Colors                | `alterationColors`             | Alteration Colors                      | `oncoplot`                          | `.plotOncoplot`                      |
| **Annotation Tracks**            |                                |                                        |                                     |                                      |
| Add Sample Annotation            | `addSampleAnnotation`          | Add Sample Annotation                  | `oncoplot`                          | `.addSampleAnnotation`               |
| Add Gene Annotation              | `addGeneAnnotation`            | Add Gene Annotation                    | `oncoplot`                          | `.addGeneAnnotation`                 |
| **Advanced Features**            |                                |                                        |                                     |                                      |
| Minimum Gene Frequency           | `minGeneFrequency`             | Minimum Gene Frequency                 | `oncoplot`                          | `.filterGenes`                       |
| Export Plot                      | `exportPlot`                   | Export Plot                            | `exportOptions`                     | `.exportOncoplot`                    |