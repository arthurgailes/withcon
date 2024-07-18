library(testthat)
# library(withcon)  # Replace with your actual package name

test_that("with_con works with duckdb", {
  skip_if_not_installed("duckdb")
  result <- with_con(duckdb::duckdb(), {
    DBI::dbExecute(con, "CREATE TABLE test (x INTEGER)")
    DBI::dbExecute(con, "INSERT INTO test VALUES (1), (2), (3)")
    DBI::dbReadTable(con, "test")
  })

  expect_equal(nrow(result), 3)
  expect_equal(result$x, c(1, 2, 3))
})

test_that("with_con disconnects after use", {
  skip_if_not_installed("duckdb")
  # Use a variable to capture the connection
  conn <- NULL
  expect_error(
    conn <- with_con(duckdb::duckdb(), {
      con  # This will ensure `con` is assigned to `conn`
    }), NA
  )
  expect_false(is.null(conn))
  expect_false(DBI::dbIsValid(conn))
})
