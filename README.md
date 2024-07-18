
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

result <- with_con(list(duckdb::duckdb()), {
  dbExecute(con, "CREATE TABLE test (x INTEGER)")
  dbExecute(con, "INSERT INTO test VALUES (1), (2), (3)")
  dbReadTable(con, "test")
})

print(result)
```

The above example is equivalent to:

``` r
library(withcon)
library(DBI)
library(duckdb)

con <- dbConnect(duckdb::duckdb())

dbExecute(con, "CREATE TABLE test (x INTEGER)")
dbExecute(con, "INSERT INTO test VALUES (1), (2), (3)")
dbReadTable(con, "test")

dbDisconnect(con)

print(result)
```

#### Parallel Processing with furrr

``` r
library(furrr)
library(DBI)
library(duckdb)
library(withcon)

future::plan(future::multisession, workers = 2)

parallel_function <- function(i) {
  with_con(list(duckdb::duckdb()), {
    dbExecute(con, "CREATE TABLE test (x INTEGER)")
    dbExecute(con, "INSERT INTO test VALUES (1), (2), (3)")
    dbReadTable(con, "test")
  })
}

results <- furrr::future_map(1:4, parallel_function)
print(results)
```
