library(tidyverse)
library(tidyr)
library(dplyr)
library(ggplot2)

setwd("~/Desktop/virtual-pipelines")

res_ng <- read.csv("residential_ng.csv")

res_ng_long <- res_ng %>%
  pivot_longer(
    cols = c(`X2020`, `X2021`, `X2022`, `X2023`, `X2024`, `X2025`),
    names_to = "year",
    values_to = "gas_use"
  )

res_ng_long$gas_use <- as.numeric(gsub(",", "", df$gas_use))
res_ng_long$year <- as.numeric(gsub("X", "", df$year))

res_ng_long %>%
  filter(Show.Data.By. != "U.S.") %>%
  ggplot(aes(year, gas_use, group = Show.Data.By.)) +
  geom_line(alpha = 0.3) +
  theme_minimal()

res_ng_long$gas_use <- as.numeric(gsub(",", "", res_ng_long$gas_use))
res_ng_long$year <- as.numeric(gsub("X", "", res_ng_long$year))

res_ng_2025 <- res_ng_long %>%
  filter(year == 2025, Show.Data.By. != "U.S.")

ggplot(res_ng_2025, aes(
  xmin = 0,
  xmax = gas_use,
  ymin = as.numeric(factor(Show.Data.By.)),
  ymax = as.numeric(factor(Show.Data.By.)) + 1,
  fill = Show.Data.By.
)) +
  geom_rect() +
  theme_void()


##

library(sf)
library(ggplot2)

setwd("~/Desktop/virtual-pipelines")

url <- "https://services2.arcgis.com/FiaPA4ga0iQKduv3/arcgis/rest/services/Natural_Gas_Interstate_and_Intrastate_Pipelines_1/FeatureServer/0/query?where=1=1&outFields=*&f=geojson"

pipelines <- st_read(url, quiet = TRUE)

pipelines <- st_make_valid(pipelines)
pipelines <- st_transform(pipelines, 4326)
pipelines <- st_simplify(pipelines, dTolerance = 5000)

pipelines_local <- pipelines

st_write(pipelines_local, "pipelines.gpkg", delete_dsn = TRUE)

print(pipelines_local)

pipelines <- st_read("pipelines.gpkg")

states_url <- "https://services.arcgis.com/P3ePLMYs2RVChkJx/ArcGIS/rest/services/USA_Boundaries_2023/FeatureServer/2/query?where=1=1&outFields=*&f=geojson"

states <- st_read(states_url, quiet = TRUE)

states <- st_transform(states, st_crs(pipelines))

ggplot() +
  geom_sf(data = states, fill = "white", color = "grey70", linewidth = 0.3) +
  geom_sf(data = pipelines, color = "steelblue", linewidth = 0.2, alpha = 0.6) +
  theme_void()


library(sf)
library(ggplot2)

setwd("~/Desktop/virtual-pipelines")

pipelines <- st_read("pipelines.gpkg")

states_url <- "https://services.arcgis.com/P3ePLMYs2RVChkJx/ArcGIS/rest/services/USA_Boundaries_2023/FeatureServer/2"

states <- st_read(states_url, quiet = TRUE)

states <- st_transform(states, st_crs(pipelines))

# critical performance fix
pipelines <- st_simplify(pipelines, dTolerance = 5000)

ggplot() +
  geom_sf(data = states, fill = "white", color = "grey70") +
  geom_sf(data = pipelines, color = "steelblue", alpha = 0.5, linewidth = 0.2) +
  theme_void()
