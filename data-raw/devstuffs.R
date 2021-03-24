library(devtools)
library(usethis)
library(desc)

# Remove default DESC
unlink("DESCRIPTION")
# Create and clean desc
my_desc <- description$new("!new")

# Set your package name
my_desc$set("Package", "datagovin")

#Set your name
my_desc$set("Authors@R", c("person('Abhishek', 'Arora', email = 'abhishek.arora1996@gmail.com', role = c('cre', 'aut'))",
            "person('Aditya', 'Chhabra', email = 'aditya0chhabra@gmail.com', role = c('cre', 'aut'))"))

# Remove some author fields
my_desc$del("Maintainer")

# Set the version
my_desc$set_version("0.0.0.9000")

# The title of your package
my_desc$set(Title = "Data.gov.in API Wrapper")
# The description of your package
my_desc$set(Description = "This wrapper allows the user to communicate with more than 80,000
            APIs posted on the open data portal data.gov.in - open data platform of the government of India.
            The pacakge allows you to search for the API required through the universe of
            the APIs with a better interface than the one website provides. Once a user has
            the ID by using the API discovery functionalities, the wrapper allows one to converse
            with the API using a consistent template")
# The urls
my_desc$set("URL", "https://github.com/econabhishek/datagovindia")
my_desc$set("BugReports", "https://github.com/econabhishek/datagovindia/issues")
# Save everyting
my_desc$write(file = "DESCRIPTION")

# If you want to use the MIT licence, code of conduct, and lifecycle badge
use_mit_license(name = "Abhishek Arora")
use_code_of_conduct()
use_lifecycle_badge("Experimental")
use_news_md()

# Get the dependencies
use_package("httr")
use_package("dplyr")
use_package("stringr")
use_package("plyr")
use_package("curl")


# Clean your description
use_tidy_description()
