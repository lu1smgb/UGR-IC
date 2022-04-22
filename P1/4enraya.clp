;;;;;;; JUGADOR DE 4 en RAYA ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;;;;;;;;;; Version de 4 en raya clásico: Tablero de 6x7, donde se introducen fichas por arriba
;;;;;;;;;;;;;;;;;;;;;;; y caen hasta la posicion libre mas abajo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;; Hechos para representar un estado del juego

;;;;;;; (Turno M|J)   representa a quien corresponde el turno (M maquina, J jugador)
;;;;;;; (Tablero Juego ?i ?j _|M|J) representa que la posicion i,j del tablero esta vacia (_), o tiene una ficha propia (M) o tiene una ficha del jugador humano (J)

;;;;;;;;;;;;;;;; Hechos para representar estado del analisis
;;;;;;; (Tablero Analisis Posicion ?i ?j _|M|J) representa que en el analisis actual la posicion i,j del tablero esta vacia (_), o tiene una ficha propia (M) o tiene una ficha del jugador humano (J)
;;;;;;; (Sondeando ?n ?i ?c M|J)  ; representa que estamos analizando suponiendo que la ?n jugada h sido ?i ?c M|J
;;;

;;;;;;;;;;;;; Hechos para representar una jugadas

;;;;;;; (Juega M|J ?columna) representa que la jugada consiste en introducir la ficha en la columna ?columna 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; INICIALIZAR ESTADO

(deffacts Estado_inicial
    (Tablero Juego 1 1 _) (Tablero Juego 1 2 _) (Tablero Juego 1 3 _) (Tablero Juego  1 4 _) (Tablero Juego  1 5 _) (Tablero Juego  1 6 _) (Tablero Juego  1 7 _)
    (Tablero Juego 2 1 _) (Tablero Juego 2 2 _) (Tablero Juego 2 3 _) (Tablero Juego 2 4 _) (Tablero Juego 2 5 _) (Tablero Juego 2 6 _) (Tablero Juego 2 7 _)
    (Tablero Juego 3 1 _) (Tablero Juego 3 2 _) (Tablero Juego 3 3 _) (Tablero Juego 3 4 _) (Tablero Juego 3 5 _) (Tablero Juego 3 6 _) (Tablero Juego 3 7 _)
    (Tablero Juego 4 1 _) (Tablero Juego 4 2 _) (Tablero Juego 4 3 _) (Tablero Juego 4 4 _) (Tablero Juego 4 5 _) (Tablero Juego 4 6 _) (Tablero Juego 4 7 _)
    (Tablero Juego 5 1 _) (Tablero Juego 5 2 _) (Tablero Juego 5 3 _) (Tablero Juego 5 4 _) (Tablero Juego 5 5 _) (Tablero Juego 5 6 _) (Tablero Juego 5 7 _)
    (Tablero Juego 6 1 _) (Tablero Juego 6 2 _) (Tablero Juego 6 3 _) (Tablero Juego 6 4 _) (Tablero Juego 6 5 _) (Tablero Juego 6 6 _) (Tablero Juego 6 7 _)
    (Jugada 0)
    )

    (defrule Elige_quien_comienza
    =>
    (printout t "Quien quieres que empieze: (escribre M para la maquina o J para empezar tu) ")
    (assert (Turno (read)))
)

;;;;;;;;;;;;;;;;;;;;;;; MUESTRA POSICION ;;;;;;;;;;;;;;;;;;;;;;;
(defrule muestra_posicion
    (declare (salience 10))
    (muestra_posicion)
    (Tablero Juego 1 1 ?p11) (Tablero Juego 1 2 ?p12) (Tablero Juego 1 3 ?p13) (Tablero Juego 1 4 ?p14) (Tablero Juego 1 5 ?p15) (Tablero Juego 1 6 ?p16) (Tablero Juego 1 7 ?p17)
    (Tablero Juego 2 1 ?p21) (Tablero Juego 2 2 ?p22) (Tablero Juego 2 3 ?p23) (Tablero Juego 2 4 ?p24) (Tablero Juego 2 5 ?p25) (Tablero Juego 2 6 ?p26) (Tablero Juego 2 7 ?p27)
    (Tablero Juego 3 1 ?p31) (Tablero Juego 3 2 ?p32) (Tablero Juego 3 3 ?p33) (Tablero Juego 3 4 ?p34) (Tablero Juego 3 5 ?p35) (Tablero Juego 3 6 ?p36) (Tablero Juego 3 7 ?p37)
    (Tablero Juego 4 1 ?p41) (Tablero Juego 4 2 ?p42) (Tablero Juego 4 3 ?p43) (Tablero Juego 4 4 ?p44) (Tablero Juego 4 5 ?p45) (Tablero Juego 4 6 ?p46) (Tablero Juego 4 7 ?p47)
    (Tablero Juego 5 1 ?p51) (Tablero Juego 5 2 ?p52) (Tablero Juego 5 3 ?p53) (Tablero Juego 5 4 ?p54) (Tablero Juego 5 5 ?p55) (Tablero Juego 5 6 ?p56) (Tablero Juego 5 7 ?p57)
    (Tablero Juego 6 1 ?p61) (Tablero Juego 6 2 ?p62) (Tablero Juego 6 3 ?p63) (Tablero Juego 6 4 ?p64) (Tablero Juego 6 5 ?p65) (Tablero Juego 6 6 ?p66) (Tablero Juego 6 7 ?p67)
    =>
    (printout t crlf)
    (printout t ?p11 " " ?p12 " " ?p13 " " ?p14 " " ?p15 " " ?p16 " " ?p17 crlf)
    (printout t ?p21 " " ?p22 " " ?p23 " " ?p24 " " ?p25 " " ?p26 " " ?p27 crlf)
    (printout t ?p31 " " ?p32 " " ?p33 " " ?p34 " " ?p35 " " ?p36 " " ?p37 crlf)
    (printout t ?p41 " " ?p42 " " ?p43 " " ?p44 " " ?p45 " " ?p46 " " ?p47 crlf)
    (printout t ?p51 " " ?p52 " " ?p53 " " ?p54 " " ?p55 " " ?p56 " " ?p57 crlf)
    (printout t ?p61 " " ?p62 " " ?p63 " " ?p64 " " ?p65 " " ?p66 " " ?p67 crlf)
    (printout t  crlf)
)


;;;;;;;;;;;;;;;;;;;;;;; RECOGER JUGADA DEL CONTRARIO ;;;;;;;;;;;;;;;;;;;;;;;
(defrule mostrar_posicion
    (declare (salience 9999))
    (Turno J)
    =>
    (assert (muestra_posicion))
)

(defrule jugada_contrario
    ?f <- (Turno J)
    =>
    (printout t "en que columna introduces la siguiente ficha? ")
    (assert (Juega J (read)))
    (retract ?f)
)

(defrule juega_contrario_check_entrada_correcta
    (declare (salience 1))
    ?f <- (Juega J ?c)
    (test (and (neq ?c 1) (and (neq ?c 2) (and (neq ?c 3) (and (neq ?c 4) (and (neq ?c 5) (and (neq ?c 6) (neq ?c 7))))))))
    =>
    (printout t "Tienes que indicar un numero de columna: 1,2,3,4,5,6 o 7" crlf)
    (retract ?f)
    (assert (Turno J))
)

(defrule juega_contrario_check_columna_libre
    (declare (salience 1))
    ?f <- (Juega J ?c)
    (Tablero Juego 1 ?c ?X) 
    (test (neq ?X _))
    =>
    (printout t "Esa columna ya esta completa, tienes que jugar en otra" crlf)
    (retract ?f)
    (assert (Turno J))
)

(defrule juega_contrario_actualiza_estado
    ?f <- (Juega J ?c)
    ?g <- (Tablero Juego ?i ?c _)
    (Tablero Juego ?j ?c ?X) 
    (test (= (+ ?i 1) ?j))
    (test (neq ?X _))
    =>
    (retract ?f ?g)
    (assert (Turno M) (Tablero Juego ?i ?c J))
)

(defrule juega_contrario_actualiza_estado_columna_vacia
    ?f <- (Juega J ?c)
    ?g <- (Tablero Juego 6 ?c _)
    =>
    (retract ?f ?g)
    (assert (Turno M) (Tablero Juego 6 ?c J))
)


;;;;;;;;;;; ACTUALIZAR  ESTADO TRAS JUGADA DE CLIPS ;;;;;;;;;;;;;;;;;;

(defrule juega_clips_actualiza_estado
    ?f <- (Juega M ?c)
    ?g <- (Tablero Juego ?i ?c _)
    (Tablero Juego ?j ?c ?X) 
    (test (= (+ ?i 1) ?j))
    (test (neq ?X _))
    =>
    (retract ?f ?g)
    (assert (Turno J) (Tablero Juego ?i ?c M))
)

(defrule juega_clips_actualiza_estado_columna_vacia
    ?f <- (Juega M ?c)
    ?g <- (Tablero Juego 6 ?c _)
    =>
    (retract ?f ?g)
    (assert (Turno J) (Tablero Juego 6 ?c M))
)

;;;;;;;;;;; CLIPS JUEGA SIN CRITERIO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule elegir_jugada_aleatoria
    (declare (salience -9998))
    ?f <- (Turno M)
    =>
    (assert (Jugar (random 1 7)))
    (retract ?f)
)

(defrule comprobar_posible_jugada_aleatoria
    ?f <- (Jugar ?c)
    (Tablero Juego 1 ?c M|J)
    =>
    (retract ?f)
    (assert (Turno M))
)

(defrule clips_juega_sin_criterio
    (declare (salience -9999))
    ?f <- (Jugar ?c)
    =>
    (printout t "JUEGO en la columna (sin criterio) " ?c crlf)
    (retract ?f)
    (assert (Juega M ?c))
    (printout t "Juego sin razonar, que mal"  crlf) 
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;  Comprobar si hay 4 en linea ;;;;;;;;;;;;;;;;;;;;;

(defrule cuatro_en_linea_horizontal
    (declare (salience 9999))
    (Tablero ?t ?i ?c1 ?jugador)
    (Tablero ?t ?i ?c2 ?jugador) 
    (test (= (+ ?c1 1) ?c2))
    (Tablero ?t ?i ?c3 ?jugador)
    (test (= (+ ?c1 2) ?c3))
    (Tablero ?t ?i ?c4 ?jugador)
    (test (= (+ ?c1 3) ?c4))
    (test (or (eq ?jugador M) (eq ?jugador J) ))
    =>
    (assert (Cuatro_en_linea ?t ?jugador horizontal ?i ?c1))
)

(defrule cuatro_en_linea_vertical
    (declare (salience 9999))
    ?f <- (Turno ?X)
    (Tablero ?t ?i1 ?c ?jugador)
    (Tablero ?t ?i2 ?c ?jugador)
    (test (= (+ ?i1 1) ?i2))
    (Tablero ?t ?i3 ?c  ?jugador)
    (test (= (+ ?i1 2) ?i3))
    (Tablero ?t ?i4 ?c  ?jugador)
    (test (= (+ ?i1 3) ?i4))
    (test (or (eq ?jugador M) (eq ?jugador J) ))
    =>
    (assert (Cuatro_en_linea ?t ?jugador vertical ?i1 ?c))
)

(defrule cuatro_en_linea_diagonal_directa
    (declare (salience 9999))
    ?f <- (Turno ?X)
    (Tablero ?t ?i ?c ?jugador)
    (Tablero ?t ?i1 ?c1 ?jugador)
    (test (= (+ ?i 1) ?i1))
    (test (= (+ ?c 1) ?c1))
    (Tablero ?t ?i2 ?c2  ?jugador)
    (test (= (+ ?i 2) ?i2))
    (test (= (+ ?c 2) ?c2))
    (Tablero ?t ?i3 ?c3  ?jugador)
    (test (= (+ ?i 3) ?i3))
    (test (= (+ ?c 3) ?c3))
    (test (or (eq ?jugador M) (eq ?jugador J) ))
    =>
    (assert (Cuatro_en_linea ?t ?jugador diagonal_directa ?i ?c))
)

(defrule cuatro_en_linea_diagonal_inversa
    (declare (salience 9999))
    ?f <- (Turno ?X)
    (Tablero ?t ?i ?c ?jugador)
    (Tablero ?t ?i1 ?c1 ?jugador)
    (test (= (+ ?i 1) ?i1))
    (test (= (- ?c 1) ?c1))
    (Tablero ?t ?i2 ?c2  ?jugador)
    (test (= (+ ?i 2) ?i2))
    (test (= (- ?c 2) ?c2))
    (Tablero ?t ?i3 ?c3  ?jugador)
    (test (= (+ ?i 3) ?i3))
    (test (= (- ?c 3) ?c3))
    (test (or (eq ?jugador M) (eq ?jugador J) ))
    =>
    (assert (Cuatro_en_linea ?t ?jugador diagonal_inversa ?i ?c))
)

;;;;;;;;;;;;;;;;;;;; DESCUBRE GANADOR
(defrule gana_fila
    (declare (salience 9999))
    ?f <- (Turno ?X)
    (Cuatro_en_linea Juego ?jugador horizontal ?i ?c)
    =>
    (printout t ?jugador " ha ganado pues tiene cuatro en linea en la fila " ?i crlf)
    (retract ?f)
    (assert (muestra_posicion))
) 

(defrule gana_columna
    (declare (salience 9999))
    ?f <- (Turno ?X)
    (Cuatro_en_linea Juego ?jugador vertical ?i ?c)
    =>
    (printout t ?jugador " ha ganado pues tiene cuatro en linea en la columna " ?c crlf)
    (retract ?f)
    (assert (muestra_posicion))
) 

(defrule gana_diagonal_directa
    (declare (salience 9999))
    ?f <- (Turno ?X)
    (Cuatro_en_linea Juego ?jugador diagonal_directa ?i ?c)
    =>
    (printout t ?jugador " ha ganado pues tiene cuatro en linea en la diagonal que empieza la posicion " ?i " " ?c   crlf)
    (retract ?f)
    (assert (muestra_posicion))
) 

(defrule gana_diagonal_inversa
    (declare (salience 9999))
    ?f <- (Turno ?X)
    (Cuatro_en_linea Juego ?jugador diagonal_inversa ?i ?c)
    =>
    (printout t ?jugador " ha ganado pues tiene cuatro en linea en la diagonal hacia arriba que empieza la posicin " ?i " " ?c   crlf)
    (retract ?f)
    (assert (muestra_posicion))
) 


;;;;;;;;;;;;;;;;;;;;;;;  DETECTAR EMPATE

(defrule empate
    (declare (salience -9999))
    (Turno ?X)
    (Tablero Juego 1 1 M|J)
    (Tablero Juego 1 2 M|J)
    (Tablero Juego 1 3 M|J)
    (Tablero Juego 1 4 M|J)
    (Tablero Juego 1 5 M|J)
    (Tablero Juego 1 6 M|J)
    (Tablero Juego 1 7 M|J)
    =>
    (printout t "EMPATE! Se ha llegado al final del juego sin que nadie gane" crlf)
)

;;;;;;;;;;;;;;;;;;;;;; CONOCIMIENTO EXPERTO ;;;;;;;;;;
;;;;; ¡¡¡¡¡¡¡¡¡¡ Añadir conocimiento para que juege como vosotros jugariais !!!!!!!!!!!!

;;;;; ***************** REGLAS DE LA RELACION ***************** ;;;;; 

; Deduce las posiciones anteriores y siguientes en cada una de las alineaciones h/v/d1/d2
; _ _ _ _ _ _ _ % _ _ _ _ _ _ _
; _ _ 1 v 2 _ _ % _ _ a s s _ _
; _ _ h # h _ _ % _ _ a # s _ _
; _ _ 2 v 1 _ _ % _ _ a a s _ _
; _ _ _ _ _ _ _ % _ _ _ _ _ _ _
; _ _ _ _ _ _ _ % _ _ _ _ _ _ _
(defrule siguiente_horizontal
    (Tablero Juego ?y ?x ?)
    (test (< ?x 7))
    =>
    (assert (Siguiente ?y ?x h ?y (+ ?x 1)))
)
(defrule siguiente_vertical
    (Tablero Juego ?y ?x ?)
    (test (> ?y 1))
    =>
    (assert (Siguiente ?y ?x v (- ?y 1) ?x))
)
(defrule anterior_horizontal
    (Tablero Juego ?y ?x ?)
    (test (> ?x 1))
    =>
    (assert (Anterior ?y ?x h ?y (- ?x 1)))
)
(defrule anterior_vertical
    (Tablero Juego ?y ?x ?)
    (test (< ?y 6))
    =>
    (assert (Anterior ?y ?x v (+ ?y 1) ?x))
)
(defrule siguiente_d1
    (Tablero Juego ?y ?x ?)
    (test (and (< ?y 6) (< ?x 7)))
    =>
    (assert (Siguiente ?y ?x d1 (+ ?y 1) (+ ?x 1)))
)
(defrule anterior_d1
    (Tablero Juego ?y ?x ?)
    (test (and (> ?y 1) (> ?x 1)))
    =>
    (assert (Anterior ?y ?x d1 (- ?y 1) (- ?x 1)))
)
(defrule siguiente_d2
    (Tablero Juego ?y ?x ?)
    (test (and (> ?y 1) (< ?x 7)))
    =>
    (assert (Siguiente ?y ?x d2 (- ?y 1) (+ ?x 1)))
)
(defrule anterior_d2
    (Tablero Juego ?y ?x ?)
    (test (and (< ?y 6) (> ?x 1)))
    =>
    (assert (Anterior ?y ?x d2 (+ ?y 1) (- ?x 1)))
)

; Regla que deduce donde caeria una ficha en una columna con fichas
(defrule puede_caer_si_ocupada
    (Tablero Juego ?y ?x M|J) ; dada una ficha no vacia
    (Siguiente ?y ?x v ?y1 ?x) ; si la siguiente ficha de arriba...
    (Tablero Juego ?y1 ?x _) ; es una ficha vacia
    =>
    (assert (Caeria ?y1 ?x))
)

; Regla que deduce donde caeria una ficha en una columna vacia
(defrule puede_caer_si_vacia
    (Tablero Juego 6 ?x _)
    =>
    (assert (Caeria 6 ?x))
)

; Eliminamos los "Caeria" que ya no son validos por que ya se ha ocupado una ficha en ese lugar
(defrule eliminar_caerias_obsoletos
    (declare (salience 1000))
    ?f <- (Caeria ?y ?x)
    (Tablero Juego ?y ?x M|J)
    =>
    (retract ?f)
)

; Regla que deduce si hay dos fichas del mismo jugador conectadas
(defrule esta_conectado_sig
    (Tablero ?t & Juego|Analisis ?y ?x ?j & M|J) ; dada una ficha del tablero
    (Siguiente ?y ?x ?m & h|v|d1|d2 ?y1 ?x1) ; si la siguiente ficha de una alineacion
    (Tablero ?t ?y1 ?x1 ?j) ; es del mismo tipo de ficha
    =>
    (assert (Conectado ?t ?m ?y ?x ?y1 ?x1 ?j)) ; entonces estan conectados
)

; Regla que deduce si hay 3 fichas del mismo jugador conectadas entre si
(defrule hay_3enlinea
    (Tablero ?t & Juego|Analisis ?y ?x ?j & M|J) ; dada una ficha
    (Conectado ?t & Juego|Analisis ?m & h|v|d1|d2 ?y ?x ?y1 ?x1 ?j) ; si esta conectado con otra
    (Siguiente ?y1 ?x1 ?m ?y2 ?x2) ; y se puede conectar otra mas usando la misma alineacion
    (Tablero ?t ?y2 ?x2 ?j)
    =>
    (assert (3_en_linea ?t ?m ?y ?x ?y2 ?x2 ?j))
)

; Reglas que deduce oportunidades en las que un jugador puede ganar
; Vienen etiquetadas segun el documento de la relacion, al principio.
(defrule podria_ganar_A
    (3_en_linea ? ?m & h|v|d1|d2 ?y ?x ?y1 ?x1 ?j & M|J)
    (Siguiente ?y1 ?x1 ?m ?ys ?xs)
    (Caeria ?ys ?xs)
    =>
    (assert (Ganaria ?j ?xs))
)

(defrule podria_ganar_B
    (3_en_linea ?t & Juego|Analisis ?m & h|d1|d2 ?y ?x ?y1 ?x1 ?j & M|J)
    (Anterior ?y ?x ?m ?ys ?xs)
    (Caeria ?ys ?xs)
    =>
    (assert (Ganaria ?j ?xs))
)

(defrule podria_ganar_C
    (Conectado ?t & Juego|Analisis ?m & h|d1|d2 ?y ?x ?y1 ?x1 ?j & M|J)
    (Siguiente ?y1 ?x1 ?m ?y2 ?x2)
    (Caeria ?y2 ?x2)
    (Siguiente ?y2 ?x2 ?m ?y3 ?x3)
    (Tablero ?t ?y3 ?x3 ?j)
    =>
    (assert (Ganaria ?j ?x2))
)

(defrule podria_ganar_D
    (Conectado ?t & Juego|Analisis ?m & h|d1|d2 ?y ?x ?y1 ?x1 ?j & M|J)
    (Anterior ?y ?x ?m ?y2 ?x2)
    (Caeria ?y2 ?x2)
    (Anterior ?y2 ?x2 ?m ?y3 ?x3)
    (Tablero ?t ?y3 ?x3 ?j)
    =>
    (assert (Ganaria ?j ?x2))
)

(defrule victoria_evitada_xM
    ?f <- (Ganaria J ?x)
    (Juega M ?x)
    =>
    (printout "Victoria del humano evitada" crlf)
    (retract ?f)
)

(defrule victoria_evitada_xJ
    ?f <- (Ganaria M ?x)
    (Juega J ?x)
    =>
    (printout "Victoria de la máquina evitada" crlf)
    (retract ?f)
)
;;;;; ***************************************************** ;;;;;

; Ahora si, vamos a definir las reglas que definan el comportamiento
; de la máquina a la hora de jugar

; No vamos a incluir una regla de jugada aleatoria porque ya viene incluida
; Aunque se usara como la jugada que haces porque "no sabes que hacer"

; Enlaces de referencia
; http://clipsrules.sourceforge.net/documentation/v624/bpg.htm#:~:text=5.4.6-,Exists%20Conditional%20Element,-The%20exists%20conditional
;
;
;
;
;

; Reglas muy prioritarias a la hora de ganar/defenderse
(defrule ir_a_ganar
    (declare (salience 8000))
    ?y <- (Turno M)
    ?x <- (Ganaria M ?c)
    (not (exists (Jugar ?)))
    =>
    (assert (Jugar ?c) (criterio))
    (retract ?x ?y)
    (printout t "Tengo la oportunidad de ganar" crlf)
)

(defrule impedir_derrota
    (declare (salience 7999))
    ?y <- (Turno M)
    ?x <- (Ganaria J ?c)
    (not (exists (Jugar ?)))
    =>
    (assert (Jugar ?c) (criterio))
    (retract ?x ?y)
    (printout t "El humano esta a punto de ganar" crlf)
)

; Si veo que hay dos fichas conectadas, intento conectar otra mas
(defrule conectar_tres_extremo_sig
    (declare (salience 2000))
    ?y <- (Turno M)
    (Tablero ?t & Juego|Analisis ?f ?c M)
    (Conectado ?t ?f ?c ?m & h|v|d1|d2 ?f1 ?c1 M) ; si hay dos fichas conectadas
    (Tablero ?t ?f1 ?c1 M)
    (Siguiente ?f1 ?c1 ?m ?f2 ?c2) ; y en la siguiente de la alineacion
    (Caeria ?f2 ?c2)
    (not (exists (Jugar ?)))
    =>
    (retract ?y)
    (assert (Jugar ?c2) (criterio)) ; pues juego
    (printout t "Voy a conectar tres para tener una posibilidad de conectar 4 mas tarde" crlf)
)

(defrule conectar_tres_extremo_ant
    (declare (salience 2001))
    ?y <- (Turno M)
    (Tablero ?t & Juego|Analisis ?f ?c M)
    (Conectado ?t ?f ?c ?m & h|d1|d2 ?f1 ?c1 M) ; si hay dos fichas conectadas
    (Tablero ?t ?f1 ?c1 M)
    (Anterior ?f ?c ?m ?f2 ?c2) ; y en la anterior de la alineacion
    (Tablero ?t ?f2 ?c2 _)
    (Caeria ?f2 ?c2)
    (not (exists (Jugar ?)))
    =>
    (retract ?y)
    (assert (Jugar ?c2) (criterio)) ; pues juego
    (printout t "Voy a conectar tres para tener una posibilidad de conectar 4 mas tarde" crlf)
)

; Tambien se pueden conectar tres separadas, salvo en vertical que no se puede
(defrule conectar_tres_entre
    (declare (salience 2002))
    ?y <- (Turno M)
    (Tablero ?t & Juego|Analisis ?f ?c M) ; Dada una ficha del tablero f,c
    (Siguiente ?f ?c ?m & h|d1|d2 ?f1x ?f2x) ; La inserto en f1x,c1x
    (Caeria ?f1x ?c1x)
    (Siguiente ?f1x ?c1x ?m ?f2 ?c2) ; La ficha siguiente a f1x,c1x tambien es de la maquina
    (Tablero ?f2 ?c2 M)
    (not (exists (Jugar ?)))
    =>
    (retract ?y)
    (assert (Jugar ?c1x) (criterio))
    (printout t "Voy a conectar tres para tener una posibilidad de conectar 4 mas tarde" crlf)
)

(defrule clips_juega_con_criterio
    (declare (salience 8501))
    ?f <- (Jugar ?c)
    ?g <- (criterio)
    =>
    (printout t "Por tanto, JUEGO en la columna " ?c crlf)
    (retract ?f ?g)
    (assert (Juega M ?c))
)

(defrule clips_juega_sin_criterio_prio
    (declare (salience -1))
    ?f <- (Jugar ?c)
    (not (exists (criterio)))
    =>
    (printout t "Puedo poner la ficha donde quiera" crlf)
    (printout t "Por tanto, JUEGO en la columna " ?c crlf)
    (retract ?f)
    (assert (Juega M ?c))
)

; ¿¿?¿? PORQUE NO ME COGE ESTAS REGLAS AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA