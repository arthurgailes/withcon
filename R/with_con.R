#' Manage DBI Connections with a 'with' like construct
#'
#' The `with_con` function creates a database connection using the provided specifications,
#' passes the connection to the provided code block, and ensures the connection is closed
#' after the code block is executed.
#'
#' @param driver A DBI driver object, e.g., `duckdb::duckdb()`.
#' @param ... Named arguments to be passed to `dbConnect` along with the driver.
#' @param code_block A code block to be executed with the created connection.
#'
#' @return The result of the evaluated code block.
#' @export
#'
#' @examples
#' if (requireNamespace("duckdb", quietly = TRUE)) {
#'   library(DBI)
#'   result <- with_con(duckdb::duckdb(), dbname = ":memory:", {
#'     dbWriteTable(con, "mtcars", mtcars)
#'     dbReadTable(con, "mtcars")
#'   })
#'   print(result)
#' }
with_con <- function(driver, code_block, ...) {
  # Create the connection
  con <- DBI::dbConnect(driver, ...)

  # Ensure the connection is disconnected at the end
  on.exit(DBI::dbDisconnect(con))

  # Evaluate the code block with the connection
  result <- eval(substitute(code_block), envir = list(con = con))

  # Return the result
  return(result)
}
