# Lesson based on https://datacarpentry.org/R-ecology-lesson/


# need to install packages only once
# install.packages("tidyverse")

# Load the library - needs to be done each R session
library("tidyverse")

# create directory for storing the raw data
dir.create("data_raw")

# download the data
download.file(url = "https://ndownloader.figshare.com/files/2292169",
              destfile = "data_raw/portal_data_joined.csv")

# Data manipulation cheatsheet: https://posit.co/wp-content/uploads/2022/10/data-transformation-1.pdf

# read the data in
surveys <- read_csv("data_raw/portal_data_joined.csv")


# subsetting data

## filter rows
# rows with year greater than 1995
filter(surveys, year > 1995)

# missing data
filter(surveys, is.na(weight))
# remove missing data
filter(surveys, !is.na(weight))

# rows with plot_id is 4 and year less than 1990
filter(surveys, plot_id == 4 & year < 1990)

## select columns

# only columns species and hindfoot_length
select(surveys, species, hindfoot_length)

# remove record_id column
select(surveys, -record_id)

## piping 
# link operations with a pipe (%>% ctrl+shift+m)
surveys %>% 
  filter(plot_type == "Control") %>% 
  select(species, weight)




## mutating (adding or changing columns)
# create new column "weight_kg" based on weight
surveys %>% mutate(weight_kg = weight / 1000)

## summarise
# calculate mean hindfoot_length, ignoring missing values
surveys %>% 
  summarise(mean_hindfoot = mean(hindfoot_length, na.rm =TRUE))

surveys %>% 
  summarise(mean_hindfoot = mean(hindfoot_length, na.rm = TRUE),
            min_hindfoot = min(hindfoot_length, na.rm = TRUE))

## group_by
# calculate summaries for each species_id
surveys %>% 
  group_by(species_id) %>% 
  summarise(mean_hindfoot = mean(hindfoot_length, na.rm =TRUE))

surveys %>% 
  filter(!is.na(hindfoot_length)) %>% 
  group_by(species_id) %>% 
  summarise(mean_hindfoot = mean(hindfoot_length, na.rm =TRUE))


# assign results
hindfoot_summary <- surveys %>% 
  filter(!is.na(hindfoot_length)) %>% 
  group_by(species_id) %>% 
  summarise(mean_hindfoot = mean(hindfoot_length, na.rm =TRUE))

## CHALLENGE
# Using pipes, subset the surveys data to include animals 
# collected before 1995 and retain only the columns year, species_id, sex, 
# and weight and assign result into object called "yearly_weight"
##


## CHALLENGE
# take your "yearly_weight" object and calculate the mean weight in kg
# for each species_id. You will need to deal with NAs
##

#######################
##      PLOTTING     ##
#######################

# Cheatsheet: https://posit.co/wp-content/uploads/2022/10/data-visualization-1.pdf

# general syntax
# ggplot(data = <DATA>, mapping = aes(<MAPPINGS>)) +  <GEOM_FUNCTION>()

# Make a plot
ggplot(data = surveys, mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point()

# Change colour
ggplot(data = surveys, mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point(colour = "tomato")

# Colour based on the data
ggplot(data = surveys, 
       mapping = aes(x = weight,
                     y = hindfoot_length,
                     colour = plot_type)) +
  geom_point()
