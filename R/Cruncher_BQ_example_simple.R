# ---------------------------------------------------------------------------- #
# Description: Cruncher et génération de bilan qualité -----------------------
# ---------------------------------------------------------------------------- #


## Chargement packages ---------------------------------------------------------

library("rjwsacruncher")
library("rjd3qr")
library("rjd3workspace")


# Paramètres --------------------------------------------------------------

path_ws <- normalizePath("V:/Formations-Stats/CVS-CJO/Workspaces/Ipi_1.xml")




## Options et paramètres -------------------------------------------------------

# Mettre votre chemin menant au cruncher
cruncher_bin_path <- normalizePath("Y:/Logiciels/JDemetraplus/jwsacruncher-3.8.0/bin/")
cruncher_bin_path

options(
    cruncher_bin_directory = cruncher_bin_path,
    is_cruncher_v3 = TRUE,
    default_matrix_item = c(
        # FOR JVS:

        "span.start",
        "span.end",
        "log",
        "span.n",
        "regression.nout",
        "regression.ntd",
        "m-statistics.m7",
        "decomposition.seasonal-filters",
        "decomposition.trend-filter",
        "decomposition.d7-trend-filter",
        "quality.summary",
        "regression.lp",
        "regression.leaster",
        "diagnostics.seas-sa-ac1:3",
        "diagnostics.seas-sa-ac1",
        "diagnostics.seas-lin-combined",
        "regression.out(*)",
        "regression.td-ftest:3",
        "residuals.lb:3",
        "diagnostics.td-sa-last:2",
        "diagnostics.seas-sa-f:2",
        "arima.p", "arima.d", "arima.q", "arima.bp", "arima.bd", "arima.bq",
        "m-statistics.q", "m-statistics.q-m2",

        # FOR QR:

        "residuals.lb2:3",
        "residuals.skewness:3",
        "residuals.kurtosis:3",
        "residuals.dh:3",
        "residuals.doornikhansen:3",
        "diagnostics.seas-sa-qs:2",
        "diagnostics.seas-sa-qs",
        "diagnostics.seas-i-qs:2",
        "diagnostics.seas-i-qs",
        "diagnostics.seas-i-f:2",
        "diagnostics.seas-i-f",
        "diagnostics.td-i-last:2",
        "diagnostics.td-i-last",
        "diagnostics.out-of-sample.mean:2",
        "diagnostics.fcast-outsample-mean:2",
        "diagnostics.out-of-sample.mse:2",
        "diagnostics.fcast-outsample-variance:2"

    ),
    default_tsmatrix_series = c("y", "s", "sa", "t")
)

getOption("default_matrix_item")
getOption("default_tsmatrix_series")

# ATTENTION: faire une sauvegarde du WS avant de cruncher (ex: copie to repo cruncher)
# cruncher : mise à jour du workspace
getwd()
cruncher_and_param(
    # Mettre le chemin menant à VOTRE WS
    workspace = "V:/Formations-Stats/CVS-CJO/Workspaces/Ipi_1.xml",
    rename_multi_documents = TRUE,
    delete_existing_file = TRUE,
    policy = "complete",
    csv_layout = "vtable",
    short_column_headers = FALSE,
    log_file = "V:/Formations-Stats/CVS-CJO/Workspaces/Ipi_1.txt")






## Generation BQ ---------------------------------------------------------------

demetra_path <- "V:/Formations-Stats/CVS-CJO/Workspaces/Ipi_1/Output/TD/demetra_m.csv"

BQ_example <-extract_QR("V:/Formations-Stats/CVS-CJO/Workspaces/Ipi_1/Output/TD/demetra_m.csv") |>
    compute_score(n_contrib_score = 3L)

# score_pond= formule

class(BQ_example)
str(BQ_example)


# Si vous avez des pondérations, vous pouvez les ajouter


## Lecture pondérations --------------------------------------------------------

POND_NAF4 <- read.csv(
  "V:/Formations-Stats/CVS-CJO/Donnees/Ponderations_2024.csv",
  encoding = "UTF-8",
  dec = ","
)
colnames(POND_NAF4)
View(POND_NAF4)
colnames(POND_NAF4)[1] <- "series"
colnames(POND_NAF4)


BQ_example <- BQ_example |>
    add_indicator(POND_NAF4) |>
    weighted_score("ponderation")


class(BQ_example)
str(BQ_example)


# Formule score

# score_pond <- c(
#     qs_residual_sa_on_sa = 30L,
#     f_residual_sa_on_sa = 30L,
#     qs_residual_sa_on_i = 20L,
#     f_residual_sa_on_i = 20L,
#     f_residual_td_on_sa = 30L,
#     f_residual_td_on_i = 20L,
#     oos_mean = 15L,
#     residuals_homoskedasticity = 5L,
#     residuals_skewness = 5L,
#     m7 = 5L,
#     q_m2 = 5L
# )

head(BQ_example$values)

## Extraction score ------------------------------------------------------------

scores_example <- extract_score(BQ_example, weighted_score = TRUE)


## Export ----------------------------------------------------------------------

# Ne pas enregistrer sous V:/Formations-Stats
write(
    x = BQ_example,
    file = "V:/Formations-Stats/CVS-CJO/BQ/BQ_Ipi1_TD.xlsx"
)
