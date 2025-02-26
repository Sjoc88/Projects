Entrada = False
Edad = 19

if Entrada and Edad >= 18:
    print("Puedes entrar")
else:
    print("No puedes entrar")

    if Edad < 18:
        print("Eres menor de edad")
    if not Entrada:
        print("No tienes entrada")