dia = "lunes"

dias_laborales = ["lunes", "martes", "miercoles", "jueves", "viernes"]

if dia == "sabado" or dia == "domingo":
    print("Es fin de semana")
elif dia in dias_laborales:
        print("Es un dia laboral")
else:
    print("No es un dia valido, por favor ingrese un dia de la semana")
