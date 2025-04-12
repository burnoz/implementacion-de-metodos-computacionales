import re

# Una clase tokens basica...
class Tokens:
    # Atributos
    tokens = []       # una lista de tokens
    pos = 0           # un indice para el token actual

    # Constructor de la clase...
    def __init__(self, lista):
        self.tokens = lista
        self.pos = 0

    # Devuelve el token actual
    def current(self):
        return self.tokens[self.pos]

    # Consume un token, avanzando al siguiente
    def avanza(self):
        self.pos += 1
        return self.tokens[self.pos]

# Guarda errores en una lista
def addError(errors, expected, token, index):
    #print(  f"ERROR index {index}: esperaba {expected}, recibio {token}"  )
    errors.append( f"ERROR en index {index}: esperaba {expected}, recibio {token}"  )

# F ->  ( E ) | id
def factor(tokens, errors):
    # Obten el token actual
    token = tokens.current()

    # Si es un  '('
    if token == "(":
        # Avanza al siguiente token
        tokens.avanza()

        # Llama a expr
        expr(tokens, errors)

        # Cuando expr termine, actualiza el token actual
        token = tokens.current()

        # Si el token actual es ahora un ')'....
        if token == ")":
            # Avanza al siguiente
            tokens.avanza()

        
        # Si no, guarda el error
        else:
            addError(errors, ")", token, tokens.pos)

    # O si es un 'entero'...
    elif re.match(reg_int, token):
        # Avanza al siguiente token
        tokens.avanza()

        # print(tokens.tokens[tokens.pos])

    # Si no es ninguna de las anteriores...
    else:
        # guarda el error
        addError(errors, "numero entero", token, tokens.pos)

# T' -> * F T' | epsilon
def termino_prime(tokens, errors):
    # Obten el token actual
    token = tokens.current()

    # Si el token actual es un '*'
    if token == "*":
        # Avanza al siguiente token
        tokens.avanza()

        # Llama a factor
        factor(tokens, errors)

        # Llama a termino_prime
        termino_prime(tokens, errors)

    elif token == "/":
        # Avanza al siguiente token
        tokens.avanza()

        # Llama a factor
        factor(tokens, errors)

        # Llama a termino_prime
        termino_prime(tokens, errors)

    # Caso alternativo, el token actual es epsilon


# T -> F T'
def termino(tokens, errors):
    # Llama a factor
    factor(tokens, errors)

    # Luego llama a termino_prime
    termino_prime(tokens, errors)


# E' -> + T E' | epsilon
# <expresion_prime> ::= + <termino> <expresion_prime> | <vacio>
def expr_prime(tokens, errors):
    # Obten el token actual
    token = tokens.current()

    # Si el token actual es un '+'
    if token == "+":
        # Avanza al siguiente token
        tokens.avanza()

        # Llama a termino
        termino(tokens, errors)

        # Luego llama a expr_prime
        expr_prime(tokens, errors)


    elif token == "-":
        # Avanza al siguiente token
        tokens.avanza()

        # Llama a termino
        termino(tokens, errors)

        # Luego llama a expr_prime
        expr_prime(tokens, errors)

    # Si no, nada... se asume que es <vacio>


# E -> T E'
# <expresion> ::= <termino> <expresion_prime>
def expr(tokens, errors):
    # Llama a termino
    termino(tokens, errors)

    # Luego, llama a expresion...
    expr_prime(tokens, errors)


def evalua(tokens):
    # Intenta evaluar la expresion
    try:
        result = eval_expr(tokens, 0)[0]
        # result, _ = eval_expr(tokens, 0)
        # return result
    
    # Si hay una division entre 0 no devuelve resultado
    except ZeroDivisionError:
        # print("woops")
        return "division sobre cero :p"

    # Devuelve el resultado si no hay division sobre cero
    return result

# Evalua multiplicaciones y divisiones
def eval_term(tokens, index):
    # Llama a la funcion para evaluar expresiones entre parentesis
    value, index = eval_factor(tokens, index)

    # Revisa que aun haya tokens y que sea un operador de multiplicacion o division
    while index < len(tokens) and tokens[index] in ("*", "/"):
        # Guarda el operador
        op = tokens[index]
        # Avanza en la lista de tokens
        index += 1

        # Verifica si hay alguna expresion entre parentesis al frente
        next_value, index = eval_factor(tokens, index)

        # Realiza la operacion correspondiente
        if op == "*":
            value *= next_value

        elif op == "/":
            value /= next_value
    
    return value, index

# Evalua expresiones entre parentesis
def eval_factor(tokens, index):
    if tokens[index] == "(":
        index += 1
        value, index = eval_expr(tokens, index)
        
        if tokens[index] == ")":
            index += 1
        return value, index
    
    else:
        value = int(tokens[index])
        return value, index + 1

# Evalua sumas y restas
def eval_expr(tokens, index):
    # Llama a la funcion para evaluar multiplicaciones/divisiones
    value, index = eval_term(tokens, index)
    
    # Revisa que aun haya tokens y que sea un operador de suma o resta
    while index < len(tokens) and tokens[index] in ("+", "-"):
        # Guarda el operador
        op = tokens[index]
        # Avanza en la lista de tokens
        index += 1

        # Revisa si hay alguna operacion de mayor jerarquia al frente
        next_value, index = eval_term(tokens, index)
        
        # Realiza la operacion correspondiente
        if op == "+":
            value += next_value
        
        elif op == "-":
            value -= next_value
    
    return value, index

# Expresion regular para identificar numeros enteros
reg_int = r"^-?[0-9]+\b"

#    Cada linea tiene un EOL al final, para evitar desbordar
#    El tokenizer deberia producir esta lista, y los id deberian tener valores numericos asociados...
lineas = [  ["1","2", "+",  "(", "3", "*", "*", "4", ")", "EOL"] ,
            ["5", "+", "+", "6", "EOL"] ,
            ["7", "*", "*", "8", "EOL"],
            ["9", "/", "10" , "EOL"],
            ["(","11",")", "+", "(", "12", "*", "13",")", "EOL" ],
            ["14", "+", "15", "*", "16", "EOL"],
            ["(", "+", "17", "*", "18", "EOL"],
            ["19", "*", "20", "+", "21", "EOL"],
            ["22", "*", "23", "24", "EOL"],
            ["25", "26", "EOL"],
            ["(", "27", ")", "+", "(", "28", ")", "EOL"],
            ["20", "/", "(", "1", "-", "1", ")", "EOL"],
            ["20", "*", "+", "2", "EOL"],
            ["30", "+", "40", "*", "50", "EOL"],
            ["(", "60", "-", "70", ")", "*", "80", "EOL"],
            ["210", "/", "(", "100", "+", "110", ")", "EOL"]
        ]

for linea in lineas:
    print("\n",linea)

    tokens = Tokens(linea)
    errors = []

    expr(tokens, errors)   #    Revisa si la linea es una expresion valida

    if tokens.pos < len(tokens.tokens) - 1:       #   Si no se consumio toda la linea, hubo algun token inesperado
        addError(errors, "operador", tokens.current() , tokens.pos)

    if len(errors) == 0 :
        print("OKS")

        # Si no hubo errores, evalua la expresion
        print(f"Resultado de la expresion: {evalua(linea)} \n")

    else:
        for e in errors:
            print(e)

        print("NOPE\n" )