library(tidyverse)

setwd('~/Desktop/virtual-pipelines')
lng_exports <- read_csv("lng_exports.csv")
view(lng_exports)

lng_exports <- ggplot(lng_exports, aes(x = Date, y = Exports)) +
  geom_line(color = "gray70", linewidth = .9) +
  geom_point(color = "gray30", size = 1.8) +
  labs(
    x = "Date",
    y = "Exports"
  ) +
  theme_minimal() +
  theme(
    panel.background = element_rect(fill = "transparent", color = NA),
    plot.background = element_rect(fill = "transparent", color = NA),
    legend.background = element_rect(fill = "transparent"),
    legend.box.background = element_rect(fill = "transparent")
    
  )

ggsave("lng_exports.pdf")
