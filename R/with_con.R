#' Manage DBI Connections with a 'with' like construct
#'
#' The `with_con` function creates a database connection using the provided specifications,
#' passes the connection to the provided code block, and ensures the connection is closed
#' after the code block is executed.
#'
#' @param db_spec A list containing the database connection specifications.
#' @param code_block A code block to be executed with the created connection.
#'
#' @return The result of the evaluated code block.
#' @export
#'
#' @examples
#' \dontrun{
#' library(duckdb)
#' result <- with_con(list(duckdb::duckdb(), "my_database.duckdb"), {
#'   dbReadTable(con, "table")
#' })
#' print(result)
#' }

with_con <- function(db_spec, code_block) {
  # Create the connection
  con <- do.call(DBI::dbConnect, db_spec)
  
  # Ensure the connection is disconnected at the end
  on.exit(DBI::dbDisconnect(con))
  
  # Evaluate the code block with the connection
  result <- eval(substitute(code_block), envir = list(con = con))
  
  # Return the result
  return(result)
}
