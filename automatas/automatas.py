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

        start = "q" + str(self.start_state)
        end = "q" + str(self.end_states[0])

        current = start
        i = 0

        while i < n:
            next = self.get_transition(current, input[i])

            if next == error:
                break
            
            else:
                current = next
                i += 1

        if i == n and current == end:
            return True
        
        return False

error = -1


# Float numbers
alphabet_float = ['0','1','2','3','4','5','6','7','8','9','.']
start_float = 0
end_float = [3]

num_states_float = 5

auto_float = Automata(alphabet_float, num_states_float, start_float, end_float)

auto_float.add_tran("q0", "0123456789", "q1")
auto_float.add_tran("q0", "+-", "q4")
auto_float.add_tran("q4", "0123456789", "q1")
auto_float.add_tran("q1", "0123456789", "q1")
auto_float.add_tran("q1", ".", "q2")
auto_float.add_tran("q2", "0123456789", "q3")
auto_float.add_tran("q3", "0123456789", "q3")

print(auto_float.validate("125.20"))

# Int numbers
alphabet_int = ['0','1','2','3','4','5','6','7','8','9']
start_int = 0
end_int = [1]

num_states_int = 2

auto_int = Automata(alphabet_int, num_states_int, start_int, end_int)

auto_int.add_tran("q0", "0123456789", "q1")
auto_int.add_tran("q0", "+-", "q1")
auto_int.add_tran("q1", "0123456789", "q1")

print(auto_int.validate("125"))