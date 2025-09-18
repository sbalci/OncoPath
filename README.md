# OncoPath

**Specialized Oncological and Pathological Research Tools for jamovi**

[![Project Status: Active](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![GitHub release](https://img.shields.io/github/release/sbalci/OncoPath.svg)](https://github.com/sbalci/OncoPath/releases/)
[![GitHub issues](https://img.shields.io/github/issues/sbalci/OncoPath.svg)](https://github.com/sbalci/OncoPath/issues)

---

## Overview

OncoPath is a specialized [jamovi](https://www.jamovi.org) module designed specifically for oncological and pathological research. It provides comprehensive patient follow-up visualization tools that are essential for clinical research, treatment response analysis, and patient timeline tracking.

## Features

### 🏊‍♂️ **Swimmer Plot Analysis**
- **Patient Timeline Visualization**: Comprehensive swimmer plots using enhanced ggswim package integration
- **Multi-dimensional Data Support**: Clinical events, milestones, treatment responses, and adverse events
- **Enhanced Data Validation**: Robust input validation with comprehensive error handling
- **Flexible Timeline Display**: Customizable patient journey visualization with event overlays
- **Clinical Research Integration**: Designed specifically for oncological clinical trial reporting

### 🌊 **Waterfall Plot Analysis**
- **Treatment Response Visualization**: Comprehensive waterfall and spider plots for tumor response analysis
- **RECIST Criteria Support**: Built-in Response Evaluation Criteria In Solid Tumors (RECIST) guidelines
- **Dual Data Input**: Supports both raw tumor measurements and pre-calculated percentage changes
- **Clinical Metrics**: Automated calculation of ORR (Overall Response Rate), DCR (Disease Control Rate), and person-time metrics
- **Publication Ready**: Professional visualization suitable for clinical publications and presentations

## Installation

### Prerequisites
- [jamovi](https://www.jamovi.org) version 2.7.2 or higher

### Method 1: Via jamovi Library (Recommended)
1. Open jamovi
2. Click on the "Modules" (⊞) button in the top-right
3. Select "jamovi library"
4. Search for "OncoPath"
5. Click "Install"

### Method 2: Sideload Installation
1. Download the latest `.jmo` file from [releases](https://github.com/sbalci/OncoPath/releases/)
2. In jamovi, click "Modules" (⊞) → "Sideload"
3. Select the downloaded `.jmo` file

### Method 3: R Installation
```r
# Install from GitHub
remotes::install_github("sbalci/OncoPath")
```

## Quick Start

### Swimmer Plot Example
1. Load your patient timeline data with columns for:
   - Patient ID
   - Start time
   - End time
   - Events (optional)
   - Response data (optional)

2. Navigate to **OncoPath** → **Patient Follow-Up Plots** → **Swimmer Plot**

3. Configure your variables and customize the visualization

### Waterfall Plot Example
1. Prepare your treatment response data with:
   - Patient ID
   - Response variable (percentage change or raw measurements)
   - Time points (for longitudinal analysis)
   - Group variables (optional)

2. Navigate to **OncoPath** → **Patient Follow-Up Plots** → **Treatment Response Analysis**

3. Select RECIST criteria options and customize your analysis

## Documentation

- **Website**: https://www.serdarbalci.com/OncoPath/
- **Swimmer Plot Guide**: https://www.serdarbalci.com/OncoPath/articles/swimmerplot_documentation.html
- **Waterfall Plot Guide**: https://www.serdarbalci.com/OncoPath/articles/waterfall_documentation.html

## Sample Data

OncoPath includes sample datasets to help you get started:

- **Swimmer Plot Analysis**: `swimmerplot_sample.omv`
- **Waterfall Plot**: `waterfall_percentage_basic.omv`
- **Waterfall and Spider Plot**: `waterfall_raw_longitudinal.omv`

## Requirements

### Core Dependencies
- R (≥ 4.1.0)
- jmvcore (≥ 0.8.5)
- ggplot2
- dplyr
- rlang

### Specialized Dependencies
- **ggswim**: Enhanced swimmer plot functionality
- **recist**: RECIST criteria implementation
- **lubridate**: Date/time handling
- **RColorBrewer**: Professional color schemes
- **gridExtra**: Advanced plot layouts

## Use Cases

### Clinical Research
- **Clinical Trial Reporting**: Patient timelines and treatment responses
- **Longitudinal Studies**: Disease progression and treatment effects over time
- **Oncology Research**: Tumor response evaluation following RECIST guidelines

### Publication Support
- **Manuscript Figures**: Publication-ready visualizations with professional styling
- **Conference Presentations**: Clear, informative plots for academic presentations
- **Regulatory Submissions**: Standardized reporting formats for regulatory agencies

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Areas for Contribution
- Additional visualization options
- Enhanced RECIST criteria support
- New clinical event types
- Documentation improvements
- Bug reports and feature requests

## Support

- **Issues**: Report bugs or request features on [GitHub Issues](https://github.com/sbalci/OncoPath/issues)
- **Discussions**: Join the conversation in [GitHub Discussions](https://github.com/sbalci/OncoPath/discussions)
- **Email**: Contact the maintainer at [serdarbalci@serdarbalci.com](mailto:serdarbalci@serdarbalci.com)

## Citation

If you use OncoPath in your research, please cite the main ClinicoPath project:

```
Serdar Balci (2025). ClinicoPath jamovi Module. doi:10.5281/zenodo.3997188
[R package]. Retrieved from https://github.com/sbalci/ClinicoPathJamoviModule
```

## License

GPL (>= 2) - see [LICENSE](LICENSE) file for details.

## Related Projects

OncoPath is part of the [ClinicoPath](https://github.com/sbalci/ClinicoPathJamoviModule) ecosystem:

- **[ClinicoPathDescriptives](https://github.com/sbalci/ClinicoPathDescriptives)**: Descriptive statistics and data quality tools
- **[jsurvival](https://github.com/sbalci/jsurvival)**: Comprehensive survival analysis
- **[meddecide](https://github.com/sbalci/meddecide)**: Medical decision analysis and ROC curves
- **[jjstatsplot](https://github.com/sbalci/jjstatsplot)**: Statistical visualization with ggstatsplot integration

---

**Developed by [Serdar Balci](https://github.com/sbalci)**

[![Twitter Follow](https://img.shields.io/twitter/follow/serdarbalci?style=social)](https://twitter.com/serdarbalci)
[![GitHub followers](https://img.shields.io/github/followers/sbalci?style=social)](https://github.com/sbalci)
