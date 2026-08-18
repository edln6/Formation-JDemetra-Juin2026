# Installation des packages R

install.packages(c(
    "rjd3toolkit",
    "rjd3x13",
    "rjd3tramoseats",
    "rjd3workspace",
    "rjwsacruncher",
    "rjd3qr",
    "rjd3prodcution",
    "dplyr"

), repos = "https://nexus.insee.fr/repository/r-cran")

# Etape JAVA_HOME
Sys.setenv(JAVA_HOME = "Y:\\Logiciels\\JDemetraplus\\jdemetra-3.8.0\\nbdemetra\\jdk-21.0.9+10-jre")
