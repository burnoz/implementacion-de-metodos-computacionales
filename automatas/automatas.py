class Automata:
    alphabet = []         # alfabeto

    start_state = 0       # estado inicial
    end_states = []       # estado final(es)

    n_states = 0          # numero de estados finales

    states = []           # lista de estados
    table_tran = {}       # tabala de transiciones, sera un diccionario con otros dicionarios dentro


    # Este es el constructor de la clase
    # self <--- es una referencia al objeto de la clase
    def __init__(self, alphabeth, n_states, start_state, end_states):
        self.alphabeth =  alphabeth

        self.start_state = start_state
        self.end_states = end_states

        self.n_states = n_states

        self.states = {"q" + str(i):i for i in range(n_states)}
        self.table_tran = {"q" + str(i):{} for i in range(n_states)}



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

        start = self.start_state
        end = self.end_states

        current = start
        print(current)
        i = 0

        while i < n:
            print(input[i])
            next = self.get_transition(current, input[i])
            print(next)

            if next == -1:
                break
            
            else:
                current = next
                i += 1

        if i == n and current == end:
            return True
        
        return False
        
            
        # Por cada caracter de la cadena ...
            # obtener el siguiente estado, dado el estado actual y el simbolo
            # si no hay transicion, rechaza la cadena y rompe el ciclo

        # Revisa si la cadena fue completamente procesada, y si el automata esta en estado de aceptacion
        # si es asi, acepta la cadena

error = -1

#	[0-9]+.[0-9]+
alphabet = ['0','1','2','3','4','5','6','7','8','9','.']
start_state = 0
end_states = [3]

n_estados = 5

auto_float = Automata(alphabet, n_estados, start_state, end_states)

auto_float.add_tran("q0", "0123456789", "q1")
auto_float.add_tran("q0", "+-", "q4")
auto_float.add_tran("q4", "0123456789", "q1")
auto_float.add_tran("q1", "0123456789", "q1")
auto_float.add_tran("q1", ".", "q2")
auto_float.add_tran("q2", "0123456789", "q3")
auto_float.add_tran("q3", "0123456789", "q3")


# for state in auto_float.table_tran:
#     print(state, auto_float.table_tran[state])

ding = auto_float.get_transition("q0", ".")
print(ding)

print(auto_float.validate("123.456"))