# Load the package for data manipulation and transformation
library(dplyr)
# Load the package containing sample clinical trial datasets in
# SDTM format
library(pharmaversesdtm)

# ---- DM domain (Demographics) ----

# Load the SDTM Demographics (dm) dataset from the pharmaversesdtm package
dm <- pharmaversesdtm::dm

# Inspect the structure, variable, types and first values of the dataset
dplyr::glimpse(dm)
# Check the total number of rows (records)
nrow(dm)
# Count the number of unique subject
dplyr::n_distinct(dm$USUBJID)
# Count the number of subjects per planned treatment arm
dplyr::count(dm, ARM)

# Check the data class of the Reference Start Date/Time variable
class(dm$RFSTDTC)
# --DTC variables are stored as character strings following ISO 8601
# so they can accommodate partial or incomplete dates

# ---- AE domain (Adverse Events) ----

# Load the SDTM Adverse Events (ae) dataset from the pharmaversesdtm package
ae <- pharmaversesdtm::ae

dplyr::glimpse(ae)
nrow(ae)
dplyr::n_distinct(ae$USUBJID)

# Number of AE records per subject
ae |> dplyr::count(USUBJID, sort = TRUE)
# Most frequent adverse events
ae |> dplyr::count(AEDECOD, sort = TRUE)
# Body systems
ae |> dplyr::count(AEBODSYS, sort = TRUE)

# Comparing AETERM and AEDECOD
ae |> dplyr::select(AETERM, AEDECOD) |> head(20)
# We see exactly the same values because data is simulated. On a real study
# they are hardly ever the same

# DM subjects that have no adverse events
subjects_no_ae <- dplyr::anti_join(dm, ae, by = "USUBJID")
subjects_no_ae
# Count the number of rows (subjects) that have no adverse events
nrow(subjects_no_ae)

# Type of treatment arm of the people that have no adverse events
dplyr::count(subjects_no_ae, ARM)
# All of the Screen Failures are on the people with no AE.
# There are more patients with AE among the people with treatment,
# than among the people with placebo