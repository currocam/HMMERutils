#' Split a column composed of nested lists into multiple columns.
#'
#' @param data Dataframe whose column is going to be splitted.
#' @param column Column to split.
#'
#' @return A DataFrame with columns `column` splitted into
#' several columns.
#'
#' @examples
#' data(phmmer_2abl)
#' extract_from_hmmer(
#'     data = phmmer_2abl,
#'     column = "hits.domains"
#' )
#' @export
extract_from_hmmer <- function(data, column = "hits.domains") { # nolint
    # Create copy of data
    data2 <- data.frame(data)
    # Save number of rows
    n_rows <- nrow(data2)
    # Initialize list with new column
    new_column <- list()
    for (row in seq_len(n_rows)) {
        new_column[[length(new_column) + 1]] <- list()
    }

    # Iterate over each row of dataframe
    for (row in seq_len(n_rows)) {
        # Calculate number of domains/sequences in actual row
        n_elements <- length(data2[row, column][[1]])

        # If there are more than one domain/sequence, add them at the end of
        # dataframe
        if (n_elements > 1) {
            for (el in c(2:n_elements)) {
                data2[nrow(data2) + 1, ] <- data2[row, ]
                assigned_element <- data2[row, column][[1]][[el]]

                if (is.null(assigned_element)) {
                    assigned_element <- NA
                }
                new_column[[length(new_column) + 1]] <- assigned_element
            }
        }
        # Access to actual row list
        assigned_element <- data2[row, column][[1]][[1]]
        if (is.null(assigned_element)) {
            assigned_element <- NA
        }
        new_column[[row]] <- assigned_element
    }
    # Substitute new.column by column name and unnest column list into
    # multiple columns
    data2 <- data2 %>% bind_and_unnest(column, new_column)
    data2
}


bind_and_unnest <- function(data, old_column, new.column) { # nolint
    data2 <- data.frame(data)
    data2 <- cbind(data2, I(new.column))

    data2 <- data2 %>%
        dplyr::select(-c({
            old_column
        })) %>%
        dplyr::rename({{ old_column }} := new.column)

    if (old_column != "hits.pdbs") {
        data2 <- data2 %>%
            tidyr::unnest_wider({{ old_column }}, names_sep = ".")
    }

    # Remove empty columns
    data2 <- data2 %>%
        dplyr::select_if(~ any(!is.na(.)))

    # Remove 'hits.' prefix from colnames
    colnames(data2) <- colnames(data2) %>%
        stringr::str_replace_all(
            old_column,
            stringr::str_remove(old_column, "hits.")
        )

    # Coerce some columns to numeric
    if (old_column == "hits.domains") {
        to_coerce <- c(
            "domains.ievalue", "domains.bias", "domains.cevalue",
            "domains.oasc"
        )

        data2[to_coerce] <- lapply(data2[to_coerce], as.numeric)
    }

    # Return new dataframe
    data2
}
