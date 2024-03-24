# install.packages("data.table")
# install.packages("tidyverse")
# install.packages("readxl")
library("tidyverse")
library("data.table")
library("dplyr")
library("readxl")
library("ggplot2")

# dane pobrane ze strony https://data.sciencespo.fr/dataset.xhtml?persistentId=doi:10.21410/7E4/RDAG3O
# artykuł oraz metadane: https://www.nature.com/articles/s41597-022-01369-4#code-availability

database = fread(file = "cross-verified-database.csv", header = TRUE)
database_filtred = top_n(database, 50000, )

# dane pobrane ze strony https://www.kaggle.com/datasets/arwind25/40-birthdays-of-famous-people-for-every-date?resource=download

dane2_filtred = read_xlsx("famousBirthday50.xlsx")

colnames(dane2_filtred) = c("name",	"BIRTHDAY",	"ZODIAC SIGN",	"PROFESSION",	"POPULARITY",	"Year",	"day",	"month",	"month day")


database_filtred$name = str_replace_all(database_filtred$name, "_", " ")

# w pierwszych danych nie ma informacji o dacie urodzenia, dlatego łącze je z drugą bazą
# danych, aby uzyskać te informacje

result = merge(database_filtred, dane2_filtred, by = "name", all.x = TRUE)
result1 = result[complete.cases(result$BIRTHDAY),]            

# usuwam niepotrzebne kolumny
result1 = subset(result1, select = c(-28 ))

# zapisuje naszą bazę danych do pliku csv
write.csv(result1, file = "dane_projekt.csv")
dane = read.csv("dane_projekt.csv")
world_coordinates = map_data("world")

dane$data_urodzin = as.Date(paste(dane$Year, dane$month_2, dane$day, sep = "-"), format = "%Y-%m-%d")
dane$month_2 = match(dane$month, month.name)

write.csv(dane, file = "dane_projekt.csv")

data2 = read.csv("dane_projekt.csv")

# usuwam znak "#" z kolumny POPULARITY
data_ordered$POPULARITY = substr(data_ordered$POPULARITY, 2, length(data_ordered$POPULARITY))

# sortuje dane według miesiąca, dnia urodzenia i popularności
data_ordered = data2[order(data$month_2, data$day, data$POPULARITY),]
data_ordered = subset(data_ordered, select = c(-1, -2, -11, -14, -15, -16, -20, -22, -23 ))

write.csv(data_ordered, "dane_projekt2.csv")
selected_date = as.Date(2024-03-24, )


przyklad = as.Date("2024-03-24", format = "%Y-%m-%d")
dzien = as.numeric(format(przyklad, format = "%d"))
miesiac = as.numeric(format(przyklad, format = "%m"))
moja_data = subset(data_ordered, month_2 == miesiac & day == dzien)
