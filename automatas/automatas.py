class Automata:
    alphabet = []         # alfabeto

    start_state = 0       # estado inicial
    end_states = []       # estado final(es)

    n_states = 0          # numero de estados finales

    states = []           # lista de estados
    table_tran = {}       # tabala de transiciones, sera un diccionario con otros dicionarios dentro

    tipo = ""             # tipo de automata

    # Este es el constructor de la clase
    # self <--- es una referencia al objeto de la clase
    def __init__(self, alphabeth, n_states, start_state, end_states, tipo):
        self.alphabeth =  alphabeth

        self.start_state = start_state
        self.end_states = end_states

        self.n_states = n_states

        self.states = {"q" + str(i):i for i in range(n_states)}
        self.table_tran = {"q" + str(i):{} for i in range(n_states)}

        self.tipo = tipo


    # Esta funcion agregara transiciones, una por una
    def add_tran(self, origin_state, symbols, end_state):
        for symbol in symbols:
            self.table_tran[origin_state][symbol] = end_state


    # Esta funcion debe consultar la tabala de trancisiones
    # dado un estado y un simbolo
    def get_transition(self, state, symbol):
        if symbol in self.table_tran[state]:
            return self.table_tran[state][symbol]
        
        return -1


    # Valida la cadena
    def validate(self, input):
        n = len(input)

        start = "q" + str(self.start_state)
        ends = ["q" + str(i) for i in self.end_states]

        current = start
        i = 0

        while i < n:
            next = self.get_transition(current, input[i])
            # print(current, input[i], next)

            if next == error:
                break
            
            else:
                current = next
                i += 1

        if i == n and current in ends:
            return True
        
        return False

error = -1

# Identificar la cadena
def identify(automatons, test):
    for auto in automatons:
        if auto.validate(test):
            print(f"La cadena {test} es un {auto.tipo}")
            return

    print(f"No se pudo identificar la cadena: {test}")


# Floats
alphabet_float = ['0','1','2','3','4','5','6','7','8','9','.']
start_float = 0
end_float = [3]

num_states_float = 5

auto_float = Automata(alphabet_float, num_states_float, start_float, end_float, "float")

auto_float.add_tran("q0", "0123456789", "q1")
auto_float.add_tran("q0", "+-", "q4")
auto_float.add_tran("q4", "0123456789", "q1")
auto_float.add_tran("q1", "0123456789", "q1")
auto_float.add_tran("q1", ".", "q2")
auto_float.add_tran("q2", "0123456789", "q3")
auto_float.add_tran("q3", "0123456789", "q3")

# print(auto_float.validate("125.20"))

# Ints
alphabet_int = ['0','1','2','3','4','5','6','7','8','9']
start_int = 0
end_int = [1]

num_states_int = 2

auto_int = Automata(alphabet_int, num_states_int, start_int, end_int, "int")

auto_int.add_tran("q0", "0123456789", "q1")
auto_int.add_tran("q0", "+-", "q1")
auto_int.add_tran("q1", "0123456789", "q1")

# print(auto_int.validate("125"))

# Identificadores, inician con a, y, x, les sigue un _ y terminan en numero
alphabet_id = ['a', 'y', 'x', '_', '0','1','2','3','4','5','6','7','8','9']
start_id = 0
end_id = [3]

num_states_id = 4

auto_id = Automata(alphabet_id, num_states_id, start_id, end_id, "identificador")

auto_id.add_tran("q0", "ayx", "q1")
auto_id.add_tran("q1", "ayx", "q1")
auto_id.add_tran("q1", "_", "q2")
auto_id.add_tran("q2", "0123456789", "q3")
auto_id.add_tran("q3", "0123456789", "q3")

# print(auto_id.validate("identificador123"))

# Comentarios
alphabet_comment = ['/','*', 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
               'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
               '0','1','2','3','4','5','6','7','8','9','_',' ']

start_comment = 0
end_comment = [2, 5]

num_states_comment = 6

auto_comment = Automata(alphabet_comment, num_states_comment, start_comment, end_comment, "comentario")

auto_comment.add_tran("q0", "/", "q1")
auto_comment.add_tran("q1", "/", "q2")
auto_comment.add_tran("q1", "*", "q3")
auto_comment.add_tran("q2", "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789 ", "q2")
auto_comment.add_tran("q3", "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789 ", "q3")
auto_comment.add_tran("q3", "*", "q4")
auto_comment.add_tran("q4", "/", "q5")

# print(auto_comment.validate("/* Comentario */"))
# print(auto_comment.validate("// Otro comentario"))

# Notacion cientifica
alphabet_sci = ['0','1','2','3','4','5','6','7','8','9','E','e','+','-','.']
start_sci = 0
end_sci = [3, 6]

num_states_sci = 7

auto_sci = Automata(alphabet_sci, num_states_sci, start_sci, end_sci, "numero en notacion cientifica")

auto_sci.add_tran("q0", "0123456789", "q1")
auto_sci.add_tran("q0", "+-", "q1")
auto_sci.add_tran("q1", "0123456789", "q1")
auto_sci.add_tran("q1", ".", "q2")
auto_sci.add_tran("q2", "0123456789", "q3")
auto_sci.add_tran("q3", "0123456789", "q3")
auto_sci.add_tran("q3", "Ee", "q4")
auto_sci.add_tran("q4", "+-", "q5")
auto_sci.add_tran("q4", "0123456789", "q6")
auto_sci.add_tran("q5", "0123456789", "q6")
auto_sci.add_tran("q6", "0123456789", "q6")

# print(auto_sci.validate("125.20E-10"))
# print(auto_sci.validate("125.20e-10"))

# Lista de automatas
automatons = [auto_float, auto_int, auto_id, auto_comment, auto_sci]

# Casos de prueba
test_cases = ["125.20", "125", "yayayx_25", "/* Comentario */", "// Otro comentario", "125.20E-10", "125.20e10"]
invalid_cases = ["125.", "125.20E-10.2", "125.20e-10.2", "identificador123", "/* Comentario *", "/ Otro comentario"]

for test in test_cases:
    identify(automatons, test)

for test in invalid_cases:
    identify(automatons, test)