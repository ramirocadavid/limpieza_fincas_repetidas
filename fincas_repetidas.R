
# IDENTIFICAR PRODUCTORES CON MÁS DE UNA FINCA ----------------------------


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



# DATOS FARM BASELINE -----------------------------------------------------

# Descargar datos farm baseline
farmBl.desc <- rforcecom.getObjectDescription(session, "gfmAg__farmBaseline__c")
farmBl.campos <- farmBl.desc$name

farmBl <- rforcecom.retrieve(session, "gfmAg__farmBaseline__c", farmBl.campos)
farmBl <- farmBl[farmBl$gfmAg__Baseline_Name__c == "Línea Base 2016", ]
farmBl <- farmBl[!is.na(farmBl$Submission__c), ]

# Verificar si hay submissions repetidos
subm.mult <- data.frame((table(farmBl$Submission__c)))
table(subm.mult$Freq)
# Revisar esto (un submission repetido 35 veces, 4 dos veces):
#    0    1    2   35 
#    6  2013   4   1 

# Agregar datos farm baseline a prod.mult.fincas
datos <- left_join(prod.mult.fincas, farmBl, 
                   by = c("Submission__c", "Submission__c"))

write.csv(datos, "productores con multiples fincas.csv")




