#lang racket

; Lista de expresiones regulares para detectar los tokens del autómata
(define regList
    '(
        ("espacio"          #rx"^[ \t\r\n]+")
        ("automaton"        #rx"^automaton")
        ("start_state"      #rx"^start_state")
        ("states"           #rx"^states")
        ("end_states"       #rx"^end_states")
        ("alphabet"         #rx"^alphabet")
        ("estado"           #rx"^Q[0-9]+")
        ("identificador"    #rx"^[a-zA-Z][a-zA-Z0-9_]*") 
        ("addTran"          #rx"^\\.addTran")
        ("test"             #rx"^\\.test")             
        ("llave-abierta"    #rx"^\\{")
        ("llave-cierre"     #rx"^\\}")
        ("asignacion"       #rx"^->")
        ("corchete-abierto" #rx"^\\[")
        ("corchete-cierre"  #rx"^\\]")
        ("coma"             #rx"^,")
        ("par-abierto"      #rx"^\\(")
        ("par-cierre"       #rx"^\\)")
        ("comentario"       #rx"^//[^\r\n]*")
        ("char"             #rx"^'(\\\\.|[^'])'")
        ("string"           #rx"^\"([^\"\\]|\\\\.)*\"")
        ("digito"           #rx"^[0-9]+")
    )
)

; Funcion para obtener el codigo de acuerdo al tipo de token detectado
(define (obtener-color tipo-token)
    (case tipo-token
        [("automaton") "#f5c2e7"]
        [("llave-abierta" "llave-cierre") "#f9e2af"]
        [("identificador") "#eebebe"]
        [("start_state" "states" "end_states") "#89b4fa"]
        [("estado") "#94e2d5"]
        [("alphabet") "#cba6f7"]
        [("asignacion") "#f38ba8"]
        [("corchete-abierto" "corchete-cierre") "#fab387"]
        [("char") "#eba0ac"]
        [("string") "#f5c2e7"]
        [("addTran") "#b4befe"]
        [("test") "#b4befe"]
        [("coma") "#9399b2"]
        [("par-abierto" "par-cierre") "#f9e2af"]
        [("comentario") "#6c7086"]
        [("digito") "#a6adc8"]
        [("error") "#f38ba8"]
        [else "#cdd6f4"]
    )
)


; Lee un archivo de texto con un automata y guarda su contenido en una cadena
(define (leer-archivo ruta)
    (define contenido (file->string ruta))
    (string-trim contenido)
)


(define cadena_automata (leer-archivo "evidencia/idk.txt"))


; Función recursiva para tokenizar
(define (tokenizar texto)
    (define (encontrar-mejor-match patrones texto mejor-actual)
        (cond
            [(null? patrones) mejor-actual]
            [else
                (define actual (car patrones))
                (define etiqueta (car actual))
                (define regex (cadr actual))
                (define match (regexp-match regex texto))

                ; (displayln match)
                
                (if (and match
                        (or (not mejor-actual)
                            (> (string-length (car match)) (string-length (cdr mejor-actual)))
                        )
                    )
                
                    (encontrar-mejor-match (cdr patrones) texto (cons etiqueta (car match)))
                    (encontrar-mejor-match (cdr patrones) texto mejor-actual)
                )
            ]
        )   
    )

    (define (tokenizar-recursivo texto-restante tokens)
        (cond
            [(string=? texto-restante "") (reverse tokens)]
            
            [else
                (define match (encontrar-mejor-match regList texto-restante #f))
                
                (if match
                    (if (equal? (car match) "espacio")
                        (tokenizar-recursivo
                            (substring texto-restante (string-length (cdr match)))
                            (cons match tokens)
                        )
                        
                        (tokenizar-recursivo
                            (substring texto-restante (string-length (cdr match)))
                            (cons match tokens)
                        )
                    )
                
                    ; Identificar lexemas no validas caracter por carácter
                    (begin
                        (substring texto-restante 0 1)
                        (tokenizar-recursivo
                            (substring texto-restante 1)
                            (cons (list "error" (substring texto-restante 0 1)) tokens)
                        )
                    )
                )
            ]             
        )
    )

    (tokenizar-recursivo texto '())
)

; Formatea las cadenas de tokens en HTML con colores
(define (formatear-automata cadena)
    (define tokens (tokenizar cadena))

    
    (apply string-append
        (map (lambda (token)
            (define tipo (car token))
            (define contenido (cdr token))
            
            (if (equal? tipo "espacio")
                ; Para espacios, los preservamos tal cual sin colorear
                contenido
                ; Para tokens normales, aplicamos el color
                (format "<span style='color: ~a'>~a</span>" 
                    (obtener-color tipo) 
                    contenido)
                )
            )
              
            tokens
        )
    )
)

(define html-automata (formatear-automata cadena_automata))

; Función para guardar el contenido HTML en un archivo
(define (guardar-html contenido ruta)
    (call-with-output-file ruta
        (lambda (out)
            (fprintf out "<!DOCTYPE html>\n<html style='background-color: #1e1e2e; color: #cdd6f4'>\nAutomata\n<head>\n<title>Automata</title>\n</head>\n<body>\n")
            (display "<pre>" out)
            (display contenido out)
            (display "</pre>\n" out)
            (fprintf out "</body>\n</html>")
        )
        
        #:exists 'replace
    )
)

(guardar-html html-automata "evidencia/automata.html")


; Verificación de sintaxis
(define (verificar-sintaxis cadena)
    (define tokens (tokenizar cadena))
    
    ; Función para verificar recursivamente
    (define (verificar-tokens tokens estado errores)
        (if (null? tokens)
            (reverse errores)
            (verificar-token (car tokens) (cdr tokens) estado errores)))
    
    ; Verifica un token individual
    (define (verificar-token token tokens-restantes estado errores)
        (define tipo (car token))
        (define contenido (cdr token))
        
        (cond
            ; Ignorar espacios y continuar con el mismo estado
            [(equal? tipo "espacio")
                (verificar-tokens tokens-restantes estado errores)]
            
            ; Estado inicial
            [(equal? estado "inicio")
                (if (equal? tipo "automaton")
                    (verificar-tokens tokens-restantes "nombre-automata" errores)
                    
                    (verificar-tokens 
                        tokens-restantes 
                        "error" 
                        (cons (format "Error: Se esperaba 'automaton', pero se encontró '~a'" contenido) errores)
                    )
                )
            ]
            

            [(equal? estado "nombre-automata")
                (if (equal? tipo "identificador")
                    (verificar-tokens tokens-restantes "llave-abierta" errores)
                    
                    (verificar-tokens 
                        tokens-restantes 
                        "error" 
                        (cons (format "Error: Se esperaba un identificador, pero se encontró '~a'" contenido) errores)
                    )
                )
            ]
            
            [(equal? estado "llave-abierta")
                (if (equal? tipo "llave-abierta")
                    (verificar-tokens tokens-restantes "contenido-automata" errores)
                    
                    (verificar-tokens 
                        tokens-restantes 
                        "error" 
                        (cons (format "Error: Se esperaba '{', pero se encontró '~a'" contenido) errores)
                    )
                )
            ]
            
            [(equal? estado "contenido-automata")
                (cond
                    [(equal? tipo "states")
                        (verificar-tokens tokens-restantes "states-flecha" errores)
                    ]
                    
                    [(equal? tipo "start_state")
                        (verificar-tokens tokens-restantes "start-state-flecha" errores)]
                
                    [(equal? tipo "end_states")
                        (verificar-tokens tokens-restantes "end-states-flecha" errores)]
                
                    [(equal? tipo "alphabet")
                        (verificar-tokens tokens-restantes "alphabet-flecha" errores)]
                
                    [else
                        (verificar-tokens 
                            tokens-restantes 
                            "contenido-automata" 
                            (cons (format "Error: Token inesperado '~a' en contenido del autómata" contenido) errores)
                        )
                    ]
                )
            ]

            [(equal? estado "states-flecha")
                (if (equal? tipo "asignacion")
                    (verificar-tokens tokens-restantes "states-corchete" errores)
                    
                    (verificar-tokens 
                        tokens-restantes 
                        "error" 
                        (cons "Error: Se esperaba -> después de 'states'" errores)
                    )
                )
            ]
            
            [(equal? estado "start-state-flecha")
                (if (equal? tipo "asignacion")
                    (verificar-tokens tokens-restantes "start-state-estado" errores)
                    
                    (verificar-tokens 
                        tokens-restantes 
                        "error" 
                        (cons "Error: Se esperaba -> después de 'start_state'" errores)
                    )
                )
            ]

            [(equal? estado "start-state-estado")
                (if (equal? tipo "estado")
                    (verificar-tokens tokens-restantes "contenido-automata" errores)
                    
                    (verificar-tokens 
                        tokens-restantes 
                        "error" 
                        (cons (format "Error: Se esperaba un estado después de 'start_state ->', pero se encontró '~a'" contenido) errores)
                    )
                )
            ]
            
            [(equal? estado "end-states-flecha")
                (if (equal? tipo "asignacion")
                    (verificar-tokens tokens-restantes "end-states-corchete" errores)
                    
                    (verificar-tokens 
                        tokens-restantes 
                        "error" 
                        (cons "Error: Se esperaba -> después de 'end_states'" errores)
                    )
                )
            ]

            [(equal? estado "alphabet-flecha")
                (if (equal? tipo "asignacion")
                    (verificar-tokens tokens-restantes "alphabet-corchete" errores)
                    
                    (verificar-tokens 
                        tokens-restantes 
                        "error" 
                        (cons "Error: Se esperaba -> después de 'alphabet'" errores)
                    )
                )
            ]
            
            [(equal? estado "end-states-corchete")
                (if (equal? tipo "corchete-abierto")
                    (verificar-tokens tokens-restantes "end-states-lista" errores)
                    
                    (verificar-tokens 
                        tokens-restantes 
                        "error" 
                        (cons "Error: Se esperaba [ después de 'end_states ->'" errores)
                    )
                )
            ]

            [(equal? estado "end-states-lista")
                (cond
                    [(equal? tipo "estado")
                        (verificar-tokens tokens-restantes "end-states-separador" errores)]
                    
                    [(equal? tipo "corchete-cierre")
                        (verificar-tokens tokens-restantes "contenido-automata" errores)]
                    
                    [else
                        (verificar-tokens 
                            tokens-restantes 
                            "error" 
                            (cons (format "Error: Se esperaba un estado o ], pero se encontró '~a'" contenido) errores)
                        )
                    ]
                )
            ]

            [(equal? estado "end-states-separador")
                (cond
                    [(equal? tipo "coma")
                        (verificar-tokens tokens-restantes "end-states-lista" errores)]
                    [(equal? tipo "corchete-cierre")
                        (verificar-tokens tokens-restantes "contenido-automata" errores)]
                    [else
                        (verificar-tokens 
                            tokens-restantes 
                            "error" 
                            (cons (format "Error: Se esperaba una coma o ], pero se encontró '~a'" contenido) errores)
                        )
                    ]
                )
            ]
            
            [(equal? estado "states-corchete")
                (if (equal? tipo "corchete-abierto")
                    (verificar-tokens tokens-restantes "states-lista" errores)
                    (verificar-tokens 
                        tokens-restantes 
                        "error" 
                        (cons "Error: Se esperaba [ después de 'states ->'" errores)
                    )
                )
            ]

            [(equal? estado "alphabet-corchete")
                (if (equal? tipo "corchete-abierto")
                    (verificar-tokens tokens-restantes "alphabet-lista" errores)
                    (verificar-tokens 
                        tokens-restantes 
                        "error" 
                        (cons "Error: Se esperaba [ después de 'alphabet ->'" errores)
                    )
                )
            ]
            
            [(equal? estado "states-lista")
                (cond
                    [(equal? tipo "estado")
                        (verificar-tokens tokens-restantes "states-separador" errores)]
                    [(equal? tipo "corchete-cierre")
                        (verificar-tokens tokens-restantes "contenido-automata" errores)]
                    [else
                        (verificar-tokens 
                            tokens-restantes 
                            "error" 
                            (cons (format "Error: Se esperaba un estado o ], pero se encontró '~a'" contenido) errores)
                        )
                    ]
                )
            ]
            
            [(equal? estado "states-separador")
                (cond
                    [(equal? tipo "coma")
                        (verificar-tokens tokens-restantes "states-lista" errores)]
                    [(equal? tipo "corchete-cierre")
                        (verificar-tokens tokens-restantes "contenido-automata" errores)]
                    [else
                        (verificar-tokens 
                            tokens-restantes 
                            "error" 
                            (cons (format "Error: Se esperaba una coma o ], pero se encontró '~a'" contenido) errores)
                        )
                    ]
                )
            ]

            [(equal? estado "alphabet-lista")
                (cond
                    [(or (equal? tipo "char") (equal? tipo "digito"))
                        (verificar-tokens tokens-restantes "alphabet-separador" errores)]
                    
                    [else
                        (verificar-tokens 
                            tokens-restantes 
                            "error" 
                            (cons (format "Error: Se esperaba un char o digito, pero se encontró '~a'" contenido) errores)
                        )
                    ]
                )
            ]

            [(equal? estado "alphabet-separador")
                (cond
                    [(equal? tipo "coma")
                        (verificar-tokens tokens-restantes "alphabet-lista" errores)]
                    
                    [(equal? tipo "corchete-cierre")
                        (verificar-tokens tokens-restantes "fin-automata" errores)]

                    [else
                        (verificar-tokens 
                            tokens-restantes 
                            "error" 
                            (cons (format "Error: Se esperaba una coma, pero se encontró '~a'" contenido) errores)
                        )
                    ]
                )
            ]

            [(equal? estado "fin-automata")
                (cond
                    [(equal? tipo "llave-cierre")
                        (verificar-tokens tokens-restantes "fuera-automata" errores)]

                    [else
                        (verificar-tokens 
                            tokens-restantes 
                            "error" 
                            (cons (format "Error: Token inesperado '~a' en instrucciones del autómata" contenido) errores)
                        )
                    ]
                )
            ]
            
            [(equal? estado "test-par")
                (if (equal? tipo "par-abierto")
                    (verificar-tokens tokens-restantes "test-cadena" errores)
                    (verificar-tokens 
                        tokens-restantes 
                        "error" 
                        (cons "Error: Se esperaba ( después de .test" errores)
                    )
                )
            ]

            [(equal? estado "test-cadena")
                (if (equal? tipo "string")
                    (verificar-tokens tokens-restantes "test-par-cierre" errores)
                    (verificar-tokens 
                        tokens-restantes 
                        "error" 
                        (cons (format "Error: Se esperaba una cadena después de .test(, pero se encontró '~a'" contenido) errores)
                    )
                )
            ]

            [(equal? estado "test-par-cierre")
                (if (equal? tipo "par-cierre")
                    (verificar-tokens tokens-restantes "fuera-automata" errores)
                    (verificar-tokens 
                        tokens-restantes 
                        "error" 
                        (cons (format "Error: Se esperaba ) después de .test(cadena), pero se encontró '~a'" contenido) errores)
                    )
                )
            ]
            
            [(equal? estado "addtran-par")
                (if (equal? tipo "par-abierto")
                    (verificar-tokens tokens-restantes "addtran-estado1" errores)
                    (verificar-tokens 
                        tokens-restantes 
                        "error" 
                        (cons "Error: Se esperaba ( después de .addTran" errores)
                    )
                )
            ]

            [(equal? estado "addtran-estado1")
                (if (equal? tipo "estado")
                    (verificar-tokens tokens-restantes "addtran-coma" errores)
                    (verificar-tokens 
                        tokens-restantes 
                        "error" 
                        (cons (format "Error: Se esperaba un estado después de .addTran(, pero se encontró '~a'" contenido) errores)
                    )
                )
            ]

            [(equal? estado "addtran-coma")
                (if (equal? tipo "coma")
                    (verificar-tokens tokens-restantes "addtran-estado2" errores)
                    (verificar-tokens 
                        tokens-restantes 
                        "error" 
                        (cons (format "Error: Se esperaba una coma después de estado1, pero se encontró '~a'" contenido) errores)
                    )
                )
            ]

            [(equal? estado "addtran-estado2")
                (if (equal? tipo "estado")
                    (verificar-tokens tokens-restantes "addTran-coma2" errores)
                    (verificar-tokens 
                        tokens-restantes 
                        "error" 
                        (cons (format "Error: Se esperaba un estado después de la coma, pero se encontró '~a'" contenido) errores)
                    )
                )
            ]

            [(equal? estado "addTran-coma2")
                (if (equal? tipo "coma")
                    (verificar-tokens tokens-restantes "addtran-lista" errores)
                    (verificar-tokens 
                        tokens-restantes 
                        "error" 
                        (cons (format "Error: Se esperaba una coma después de estado2, pero se encontró '~a'" contenido) errores)
                    )
                )
            ]
                    
            [(equal? estado "addtran-lista")
                (cond
                    [(equal? tipo "corchete-abierto")
                        (verificar-tokens tokens-restantes "addtran-simbolos" errores)]
                    
                    [(equal? tipo "identificador")
                        (verificar-tokens tokens-restantes "addtran-par-cierre" errores)]
                    
                    [else
                        (verificar-tokens 
                            tokens-restantes 
                            "error" 
                            (cons (format "Error: Se esperaba una lista de símbolos o un identificador, pero se encontró '~a'" contenido) errores)
                        )
                    ]
                )
            ]

            [(equal? estado "addtran-simbolos")
                (cond
                    [(or (equal? tipo "char") (equal? tipo "digito"))
                        (verificar-tokens tokens-restantes "addtran-separador" errores)]
                    [(equal? tipo "corchete-cierre")
                        (verificar-tokens tokens-restantes "fuera-automata" errores)]
                    [else
                        (verificar-tokens 
                            tokens-restantes 
                            "error" 
                            (cons (format "Error: Se esperaba un char, digito o ], pero se encontró '~a'" contenido) errores)
                        )
                    ]
                )
            ]

            [(equal? estado "addtran-separador")
                (cond
                    [(equal? tipo "coma")
                        (verificar-tokens tokens-restantes "addtran-simbolos" errores)]
                    [(equal? tipo "corchete-cierre")
                        (verificar-tokens tokens-restantes "fuera-automata" errores)]
                    [else
                        (verificar-tokens 
                            tokens-restantes 
                            "error" 
                            (cons (format "Error: Se esperaba una coma o ], pero se encontró '~a'" contenido) errores)
                        )
                    ]
                )
            ]

            [(equal? estado "addtran-identificador")
                (if (equal? tipo "identificador")
                    (verificar-tokens tokens-restantes "addtran-par-cierre" errores)
                    (verificar-tokens 
                        tokens-restantes 
                        "error" 
                        (cons (format "Error: Se esperaba un identificador después de .addTran(, pero se encontró '~a'" contenido) errores)
                    )
                )
            ]

            [(equal? estado "addtran-par-cierre")
                (if (equal? tipo "par-cierre")
                    (verificar-tokens tokens-restantes "fuera-automata" errores)
                    (verificar-tokens 
                        tokens-restantes 
                        "error" 
                        (cons (format "Error: Se esperaba ) después de .addTran(estado1, estado2, lista), pero se encontró '~a'" contenido) errores)
                    )
                )
            ]
            
            [(equal? estado "lista-simbolos")
                (cond
                    [(equal? tipo "corchete-abierto")
                        (verificar-tokens tokens-restantes "lista-simbolos-contenido" errores)]
                    

                    [else
                        (verificar-tokens 
                            tokens-restantes 
                            "error" 
                            (cons (format "Error: Se esperaba una lista de símbolos, pero se encontró '~a'" contenido) errores)
                        )
                    ]
                )
            ]

            [(equal? estado "lista-simbolos-contenido")
                (cond
                    [(or (equal? tipo "char") (equal? tipo "digito"))
                        (verificar-tokens tokens-restantes "lista-simbolos-separador" errores)]
                    [(equal? tipo "corchete-cierre")
                        (verificar-tokens tokens-restantes "fuera-automata" errores)]
                    [else
                        (verificar-tokens 
                            tokens-restantes 
                            "error" 
                            (cons (format "Error: Se esperaba un char, digito o ], pero se encontró '~a'" contenido) errores)
                        )
                    ]
                )
            ]

            [(equal? estado "lista-simbolos-separador")
                (cond
                    [(equal? tipo "coma")
                        (verificar-tokens tokens-restantes "lista-simbolos-contenido" errores)]
                    [(equal? tipo "corchete-cierre")
                        (verificar-tokens tokens-restantes "fuera-automata" errores)]
                    [else
                        (verificar-tokens 
                            tokens-restantes 
                            "error" 
                            (cons (format "Error: Se esperaba una coma o ], pero se encontró '~a'" contenido) errores)
                        )
                    ]
                )
            ]
            
            [(equal? estado "identificador-fuera")
                (cond
                    [(equal? tipo "asignacion")
                        (verificar-tokens tokens-restantes "lista-simbolos" errores)]
                    
                    [(equal? tipo "addTran")
                        (verificar-tokens tokens-restantes "addtran-par" errores)]
                    
                    [(equal? tipo "test")
                        (verificar-tokens tokens-restantes "test-par" errores)]
                    
                    [else
                        (verificar-tokens 
                            tokens-restantes 
                            "error" 
                            (cons (format "Error: Se esperaba -> o .addTran, pero se encontró '~a'" contenido) errores)
                        )
                    ]
                )
            ]
    
            [(equal? estado "fuera-automata")
                (cond
                    [(equal? tipo "comentario")
                        (verificar-tokens tokens-restantes "fuera-automata" errores)]
                    
                    [(equal? tipo "identificador")
                        (verificar-tokens tokens-restantes "identificador-fuera" errores)]
                    
                    [(equal? tipo "par-cierre")
                        (verificar-tokens tokens-restantes "fuera-automata" errores)]

                    [else
                        (verificar-tokens 
                            tokens-restantes 
                            "fuera-automata" 
                            (cons (format "Error: Token inesperado '~a' fuera del autómata" contenido) errores)
                        )
                    ]
                )
            ]
            
            [(equal? estado "error")
                (cond
                    [(equal? tipo "addTran") (verificar-tokens tokens-restantes "addtran-par" errores)]
                    [(equal? tipo "test") (verificar-tokens tokens-restantes "test-par" errores)]
                    [(equal? tipo "identificador") (verificar-tokens tokens-restantes "identificador-fuera" errores)]
                    [else (verificar-tokens tokens-restantes "error" errores)]
                )
            ]
            
            ; Cualquier otro caso
            [else
                (verificar-tokens 
                    tokens-restantes 
                    "error" 
                    (cons (format "Error de sintaxis inesperado en estado '~a'" estado) errores)
                )
            ]
        )
    )
                
    (verificar-tokens tokens "inicio" '()))


; Generar HTML con el código coloreado y errores
(define (formatear-automata-con-errores cadena)
    (define tokens (tokenizar cadena))
    (define errores-sintaxis (verificar-sintaxis cadena))
    
    (define html-code
        (apply string-append
            (map (lambda (token)
                (define tipo (car token))
                (define contenido (cdr token))
                
                (if (equal? tipo "espacio")
                    ; Para espacios, los preservamos tal cual sin colorear
                    contenido
                    ; Para tokens normales, aplicamos el color
                    (format "<span style='color: ~a'>~a</span>" 
                        (obtener-color tipo) 
                        contenido)))
                tokens)))
    
    (define html-errores
        (if (null? errores-sintaxis)
            "<div style='color: #a6e3a1; margin-top: 20px;'><h3>Análisis completado:</h3><p>El código es sintácticamente correcto.</p></div>"
            (string-append
                "<div style='color: #f38ba8; margin-top: 20px;'><h3>Errores de sintaxis:</h3><ul>"
                (apply string-append
                    (map (lambda (error)
                            (format "<li>~a</li>" error))
                        errores-sintaxis
                    )
                )
                "</ul></div>")))
    
    (string-append html-code html-errores))

(define html-completo (formatear-automata-con-errores cadena_automata))

(guardar-html html-completo "evidencia/automata_con_errores.html")
