library(purrr)
library(kableExtra)
db <- mtcars[, 1:7]
db2 <- cbind(rownames(db), db)
colnames(db2) <- c("Methods", rep(c("Bias", "RMSE"), 3), "")
if (knitr::is_latex_output()) {
  kable(db2,
        format = "latex", booktabs = TRUE, escape = T, row.names = F,
        longtable = FALSE, caption = "第1种类型的统计表格样式",
        linesep = c("", "", "", "", "", "\\midrule")
  ) %>%
    kable_styling(
      latex_options = c("hold_position", "repeat_header"),
      full_width = F, position = "center", repeat_header_method = "replace",
      repeat_header_text = "续表@ref(tab:kable)"
    ) %>%
    add_header_above(c(" ",
                       "$\\\\sigma^2$" = 2, "$\\\\phi$" = 2,
                       "$\\\\tau^2$" = 2, "$r=\\\\delta/\\\\phi$" = 1
    ), escape = F) %>%
    footnote(
      general_title = "注：", title_format = "italic", threeparttable = T,
      general = "* 星号表示的内容很长"
    )
} else {
  kable(db2,
        format = "html", booktabs = TRUE, escape = T, row.names = F,
        caption = "第1种类型的统计表格样式"
  ) %>%
    kable_styling(
      bootstrap_options = c("basic"),
      full_width = F, position = "center"
    ) %>%
    add_header_above(c("",
                       "$\\sigma^2$" = 2, "$\\phi$" = 2,
                       "$\\tau^2$" = 2, "$r=\\delta/\\phi$" = 1
    ), escape = F) %>%
    footnote(
      general_title = "注：", title_format = "italic", threeparttable = T,
      general = "* 星号表示的内容很长"
    )
}
