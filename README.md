
<!-- README.md is generated from README.Rmd. Please edit that file -->

# withcon

`withcon` simplifies managing DBI connections in R, ensuring connections
are properly opened and closed within a code block.

## Installation

``` r
install.packages("withcon")

# Install withcon from GitHub
# devtools::install_github("arthurgailes/withcon")
```

## Usage

#### Basic Example

``` r
library(withcon)
library(DBI)
library(duckdb)
```

``` r
result <- with_con(duckdb::duckdb(), {
  dbExecute(con, "CREATE TABLE test (x INTEGER)")
  dbExecute(con, "INSERT INTO test VALUES (1), (2), (3)")
  dbReadTable(con, "test")
})

print(result)
#>   x
#> 1 1
#> 2 2
#> 3 3
```

The above example is equivalent to:

``` r
con <- dbConnect(duckdb::duckdb())

dbExecute(con, "CREATE TABLE test (x INTEGER)")
#> [1] 0
dbExecute(con, "INSERT INTO test VALUES (1), (2), (3)")
#> [1] 3
dbReadTable(con, "test")
#>   x
#> 1 1
#> 2 2
#> 3 3

dbDisconnect(con)

print(result)
#>   x
#> 1 1
#> 2 2
#> 3 3
```

#### Parallel Processing with furrr

``` r
library(furrr)
library(DBI)
library(duckdb)
library(withcon)

future::plan(future::multisession, workers = 2)

parallel_function <- function(i) {
  with_con(duckdb::duckdb(), {
    dbExecute(con, "CREATE TABLE test (x INTEGER)")
    dbExecute(con, "INSERT INTO test VALUES (1), (2), (3)")
    dbReadTable(con, "test")
  })
}

results <- furrr::future_map(1:4, parallel_function)
print(results)
#> [[1]]
#>   x
#> 1 1
#> 2 2
#> 3 3
#> 
#> [[2]]
#>   x
#> 1 1
#> 2 2
#> 3 3
#> 
#> [[3]]
#>   x
#> 1 1
#> 2 2
#> 3 3
#> 
#> [[4]]
#>   x
#> 1 1
#> 2 2
#> 3 3
```
