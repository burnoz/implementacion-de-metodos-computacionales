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
        addError(errors, ")", token, tokens.pos)

    # O si es un 'id'...
    elif token == "id":
        # Avanza al siguiente token
        tokens.avanza()

    # Si no es ninguna de las anteriores...
    else:
        # guarda el error
        addError(errors, "id / expresion", token, tokens.pos)



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

    # Si no, nada... se asume que es <vacio>



# E -> T E'
# <expresion> ::= <termino> <expresion_prime>
def expr(tokens, errors):
    # Llama a termino
    termino(tokens, errors)

    # Luego, llama a expresion...
    expr_prime(tokens, errors)



#    Cada linea tiene un EOL al final, para evitar desbordar
#    El tokenizer deberia producir esta lista, y los id deberian tener valores numericos asociados...
lineas = [  ["id","id", "+",  "(", "id", "*", "*", "id", ")", "EOL"] ,
            ["id", "+", "+", "id", "EOL"] ,
            ["id", "*", "*", "id", "EOL"],
            ["id", "*", "id" , "EOL"],
            ["(","id",")", "+", "(", "id", "*", "id",")", "EOL" ],
            ["id", "+", "id", "*", "id", "EOL"],
            ["(", "+", "id", "*", "id", "EOL"],
            ["id", "*", "id", "+", "id", "EOL"],        #    nope
            ["id", "*", "id", "id", "EOL"],             #    nope
            ["id", "id", "EOL"],                        #    nope
            ["(", "id", ")", "+", "(", "id", ")", "EOL"]    # oks
        ]

for linea in lineas:
    print("\n",linea)

    tokens = Tokens(linea)
    errors = []

    expr(tokens, errors)   #    Revisa si la linea es una expresion valida


    if tokens.pos < len(tokens.tokens) - 1:       #   Si no se consumio toda la linea, hubo algun token inesperado
        addError(errors, "operador", tokens.current() , tokens.pos)

    if len(errors) == 0 :
        print("OKS\n")

    else:
        for e in errors:
            print(e)

        print("NOPE\n" )