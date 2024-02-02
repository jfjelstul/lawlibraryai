# lawlibraryai

An R interface to the LawLibrary.AI API. This package provides easy-to-use tools for downloading legal data from LawLibrary.AI LLC via the LawLibrary.AI API. Please note that this package requires an API key to use. 

## Installation

You can install the latest development version of the `lawlibraryai` package from GitHub:

```r
# install.packages("devtools")
devtools::install_github("jfjelstul/lawlibraryai")
```

## Citation

If you use data from the `lawlibraryai` package in a project or paper, please cite the package:

> Joshua C. Fjelstul (2024). lawlibraryai: An R Interface to the LawLibrary.AI API. R package version 0.1.0.
> 
The `BibTeX` entry for the package is:

```
@Manual{,
  title = {lawlibraryai: An R Interface to the LawLibrary.AI API},
  author = {Joshua C. Fjelstul},
  year = {2024},
  note = {R package version 0.1.0},
}
```

## Problems

If you notice an error in the data or a bug in the `R` package, please report it [here](https://github.com/jfjelstul/lawlibraryai/issues).

## Tutorial

The `lawlibraryai` package allows you to download data via the LawLibrary.AI API. The package's main function is `download_data()`. This function has three required arguments: `database_id`, `dataset_id`, and `api_key`, which is your LawLibrary.AI API key. There's also one optional argument: `parameters`, which allows you to specify search parameters. 

You can use the function `get_databases()` to get a table that summarizes all of the databases that are currently available and all of the datasets that are currently available in each database. The table includes an ID for each database and dataset, which you'll need to provide to `download_data()`. 

The `parameters` argument should be a named list that specifies values for API parameters. API parameters correspond to variables in each dataset and let you filter the data. If you want to specify more than one value for a parameter, you can use a vector. The `download_data()` function will ignore invalid API parameters. Please consult the documentation for the database and dataset you're working with to see which variables have corresponding API parameters. 

Here's an example. In this example, we're downloading all state aid cases from the `cases` dataset in the European Union State Aid (EUSA) Database for France, Germany, and Italy between January 1, 2000 and December 31, 2019. 

```r
data <- download_data(
  database_id = "state_aid",
  dataset_id = "cases",
  filters = list(
    min_date = "2000-01-01",
    max_date = "2019-12-31",
    member_state = c("France", "Germany", "Italy")
  ),
  api_key = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"
)

# Requesting data via the LawLibrary.AI API...
# Response received.
# Observations requested: 11521.
# Downloading 10000 observations every 5 seconds.
# Number of batches: 2.
# Total estimated time: 0.08 minutes (5 seconds).
# Batch 1 of 2 complete (observations 1 to 10000 of 11521).
# Batch 2 of 2 complete (observations 10001 to 11521 of 11521).
# Your download is complete!                        
#
# Please cite the European Union State Aid (EUSA) Database:
#
# Fjelstul, Joshua C. 2024. European Union State Aid (EUSA) Database. Version 1.01.00. Published by LawLibrary.AI LLC. https://www.lawlibrary.ai.
#
# Please also cite the lawlibraryai R package:
#
# Joshua C. Fjelstul (2024). lawlibraryai: An R Interface to the LawLibrary.AI API. R package version 0.1.0. https://github.com/jfjelstul/lawlibraryai.
```

The `download_data()` function downloads the data in batches of `10000` observations. The LawLibrary.AI API has a rate limit, and this function automatically manages the rate limit for us. It will download `1` batch approximately every `5` seconds. 

The function prints some useful information to the `console` while the data downloads. It tells us how many observations we have requested, how many batches it will take to download the data, and approximately how long it will take. It provides an update every time a batch is downloaded and counts down to the next batch. It also povides a suggested citations for the data. The function returns a `tibble` that we can manipulate with `dplyr` and `tidyr`.
