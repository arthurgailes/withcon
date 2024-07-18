library(testthat)
library(withcon)

test_that("with_con works in parallel with furrr", {
  lapply(c("furrr", "carrier", "future"), skip_if_not_installed)
  # Set up parallel plan
  future::plan(future::multisession, workers = 2)

  # Define a function to use with with_con
  parallel_function <- carrier::crate(
    with_con = with_con,
    function(i) {
      with_con(duckdb::duckdb(), {
        DBI::dbExecute(con, "CREATE TABLE test (x INTEGER)")
        DBI::dbExecute(con, "INSERT INTO test VALUES (1), (2), (3)")
        DBI::dbReadTable(con, "test")
      })
    }
  )


  # Run the function in parallel using future_map
  opts <- furrr::furrr_options(globals = FALSE)
  results <- furrr::future_map(1:4, parallel_function, .options = opts)

  # Check the results
  for (result in results) {
    expect_equal(nrow(result), 3)
    expect_equal(result$x, c(1, 2, 3))
  }
})
