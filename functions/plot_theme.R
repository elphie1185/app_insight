# plot theme
my_theme <- function() {
  theme_minimal() +
    theme(
      title = element_text(face = "bold", size = 16), 
      axis.title = element_text(face = "bold", size = 13), 
      panel.grid.major = element_line(colour = "grey82"), 
      axis.text = element_text(size = 10, face = "bold"), 
      axis.line = element_line(colour = "black", size = 0.5)
    )
}