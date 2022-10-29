#' Split a column composed of nested lists into multiple columns.
#'
#' @param data Dataframe whose column is going to be splitted.
#' @param column Column to split.
#'
#' @return A DataFrame with columns `column` splitted into
#' several columns.
#' @export
extract_from_hmmer <- function(data, column='hits.domains'){
  
  # Create copy of data
  data2 <- data.frame(data)
  
  # Save number of rows
  n.rows <- nrow(data2)
  
  # Initialize list with new column
  new.column <- list()
  for (row in c(1:n.rows)){
    new.column[[length(new.column)+1]] <- list()
  }
  
  # Iterate over each row of dataframe
  for (row in c(1:n.rows)){
    
    # Calculate number of domains/sequences in actual row
    n.elements <- length(data2[row,column][[1]])
    
    # If there are more than one domain/sequence, add them at the end of 
    # dataframe
    if (n.elements > 1){ 
      
      for (el in c(2:n.elements)){
        data2[nrow(data2)+1,] <- data2[row,]
        new.column[[length(new.column)+1]] <- 
          data2[row,column][[1]][[el]]
      }
    }
    
    # Access to actual row list
    new.column[[row]] <- data2[row,column][[1]][[1]]
  }
  
  # Substitute new.column by column name and unnest column list into
  # multiple columns
  data2 <- cbind(data2,I(new.column))
  data2 <- data2 %>% dplyr::select(-c(hits.domains)) %>% 
    dplyr::rename({{column}} := new.column) %>%
    tidyr::unnest_wider({{column}},names_sep = ".")  
  colnames(data2) <- colnames(data2) %>%
    stringr::str_replace_all(
      column, 
      stringr::str_remove(column, "hits."))
  
  data2
}