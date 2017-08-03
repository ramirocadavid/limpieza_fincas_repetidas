# Login a Salesforce
library(RForcecom)
username <- "admin@andes.org"
password <- "admgf2017#XQWRiDpPU6NzJC9Cmm185FF2"
session <- rforcecom.login(username, password)

# Descargar datos de fincas
farm.desc <- rforcecom.getObjectDescription(session, "gfmAg__Farm__c")
farm.campos <- farm.desc$name

campos.finca <- c("gfmAg__farmer__r.Farmer_ID_18__c", "farmerName__c", "gfmAg__farmName__c")
fincas <- rforcecom.retrieve(session, "gfmAg__Farm__c", farm.campos)

# Identificar productores con más de una finca
tab.fincas <- data.frame(table(fincas$gfmAg__farmer__c))

library(dplyr)
prod.mult.fincas <- left_join(fincas, tab.fincas, 
                              by = c("gfmAg__farmer__c" = "Var1"))

prod.mult.fincas <- prod.mult.fincas[prod.mult.fincas$Freq > 1, ]

# Exportar datos
prod.mult.fincas <- prod.mult.fincas[order(prod.mult.fincas$farmerName__c),]
write.csv(prod.mult.fincas, "Productores con mas de 1 finca.csv")
