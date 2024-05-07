library(readxl)
library(dplyr)
library(tidyr)
library(reshape2)
library(anytime)

file_path <- "data_raw/240507_HCC.xlsx"

sheet_names <- excel_sheets(file_path)

# Read all sheets into a list of data frames
dfs <- lapply(sheet_names, function(sheet) read_xlsx(file_path, sheet = sheet))

########loop durch jdes df + pseudonymisierung
for (i in 1:length(dfs)) {
  dfs[[i]] <- dfs[[i]] %>%
    mutate(
      Pseudonym = paste0(
        substr(Name, 1, 2), 
        substr(Vorname, 1, 2),
        substr(Geburtsdatum, 9, 10),
        substr(Geburtsdatum, 6, 7),
        substr(Geburtsdatum, 3, 4),
        substr(OPDatum, 9, 10),
        substr(OPDatum, 6, 7),
        substr(OPDatum, 3, 4)
      )
    )
}

#######checkdf2 for duplicates in pseudonym
duplicated_pseudonyms <- duplicated(dfs[[3]]$Pseudonym)
duplicated_rows <- dfs[[3]][duplicated_pseudonyms, ]

if (nrow(duplicated_rows) > 0) {
  print("Duplicated pseudonyms found:")
  print(duplicated_rows)
} else {
  print("No duplicated pseudonyms found.")
}




