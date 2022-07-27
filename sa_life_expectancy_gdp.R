#install.packages("gganimate")
install.packages("ggthemes")


library(rio)
library(tidyverse)
library(gganimate)
library(ggplot2)
library(dplyr)
library(ggthemes)
library(gifski)
library(av)

data <- as_tibble(import("life-expectancy-vs-gdp-per-capita.csv"))
view(data)

data
data <- mutate_if(data, is.character, as.factor)
data

#create animated graph
graph1 = data%>%
  ggplot(aes(x=pop, y=lifeExp, color=country, size=pop)) +
  geom_point(alpha = 0.7, stroke = 0) +
  theme_fivethirtyeight() +
  scale_size(range=c(2,12), guide="none") +
  scale_x_continuous(breaks = seq(0, 220, by = 20)) +
  scale_y_continuous(breaks = seq(0, 70, by = 10)) +
  labs(title = "Life Expectancy vs Population Growth \nfor South Africa, Nigeria and Kenya",
       x = "Population (in millions)",
       y = "Life expectancy (years)",
       color = "country",
       caption = "dataset: https://ourworldindata.org") +
  theme(axis.title = element_text(),
        text = element_text(family = "Rubik"),
        legend.text=element_text(size=10)) +
  theme(plot.title=element_text(hjust=0.5)) +
  guides(color = guide_legend(override.aes = list(size = 5)))+
  scale_color_brewer(palette = "Set2")

graph1.animation = graph1 +
  transition_time(year) +
  labs(subtitle = "Year: {frame_time}") +
  shadow_wake(wake_length = 0.1)

animate(graph1.animation, height = 500, width = 800, fps = 30, duration = 30,
        end_pause = 60, res = 100)
anim_save("life_expectancy_Population.gif")
