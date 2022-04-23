; Ejercicio 3 de la práctica 1
; Luis Miguel Guirado Bautista
; Curso 2021/22

; Así, la práctica consiste en crear un programa en CLIPS que:
; Le pregunte al usuario que pide asesoramiento lo que le
;   preguntaríais a alguien que os pida consejo en ese sentido,
;   y de la forma y orden en que lo preguntaríais vosotros.
; Razone y tome decisiones cómo lo haríais vosotros para esta tarea.
; Le aconseje la rama o las ramas que le aconsejaríais vosotros, 
;   junto con los motivos por los que se le aconseja.
;
; La maquina tiene que simular nuestro comportamiento
;
; Vamos a suponer que el estudiante ya ha cursado los dos primeros
; cursos de la carrera, de modo que podemos hacerle preguntas sobre
; esos cursos en concreto

(deftemplate ValoracionRama
    (slot rama)
    (slot val)
)

(deffacts Ramas
    (Rama "Computacion y Sistemas Inteligentes")
    (Rama "Ingenieria del Software")
    (Rama "Ingenieria de Computadores")
    (Rama "Sistemas de Informacion")
    (Rama "Tecnologias de la Informacion")
    ;---------------------------------------------------------------
    (ValoracionRama (rama CSI) (val 0))
    (ValoracionRama (rama IS) (val 0))
    (ValoracionRama (rama IC) (val 0))
    (ValoracionRama (rama SI) (val 0))
    (ValoracionRama (rama TI) (val 0)) 
)

(deffacts AsignaturasPrimero
    ; Primer cuatrimestre ------------------------------------------
    (Asignatura FP "Fundamentos de Programacion")
    (Asignatura FS "Fundamentos del Software")
    (Asignatura FFT "Fundamentos Fisicos y Tecnologicos")
    (Asignatura CA "Calculo")
    (Asignatura ALEM "Algebra Lineal y Estructuras Matematicas")
    ; Segundo cuatrimestre -----------------------------------------
    (Asignatura MP "Metodologia de la Programacion")
    (Asignatura TOC "Tecnologia y Organizacion de Computadores")
    (Asignatura LMD "Logica y Metodos Discretos")
    (Asignatura IES "Ingenieria Empresa y Sociedad")
    (Asignatura ES "Estadistica")
    ;---------------------------------------------------------------
)

(deffacts AsignaturasSegundo
    ; Primer cuatrimestre ------------------------------------------
    (Asignatura SO "Sistemas Operativos")
    (Asignatura ED "Estructuras de Datos")
    (Asignatura PDOO "Programacion y Diseno Orientado a objetos")
    (Asignatura SCD "Sistemas Concurrentes y Distribuidos")
    (Asignatura EC "Estructura de Computadores")
    ; Segundo cuatrimestre -----------------------------------------
    (Asignatura AC "Arquitectura de Computadores")
    (Asignatura FBD "Fundamentos de Bases de Datos")
    (Asignatura ALG "Algoritmica")
    (Asignatura IA "Inteligencia Artificial")
    (Asignatura FIS "Fundamentos de Ingenieria del Software")
    ;---------------------------------------------------------------
)

; PAG. 16 del FAQ
; Para tener un contador que vaya incrementando
; poco a poco
(deftemplate num_pregunta (slot num))

(deffacts Preguntas
    (Pregunta 1 "Te gusta la programacion?")
    (Pregunta 2 "Te gustan las matematicas?")
    (Pregunta 3 "Se te dan bien las matematicas?")
    (Pregunta 4 "Te gusta lo relacionado con la inteligencia artificial?")
    (Pregunta 5 "Te gusta el mundo de la robotica?")
    (Pregunta 6 "Te gustan los videojuegos?")
    (Pregunta 7 "Te gusta la informatica tipo web?")
    (Pregunta 8 "Te gustan los sistemas informaticos?")
    (Pregunta 9 "Te gustan las redes y los servidores?")
    (Pregunta 10 "Te gustan las bases de datos?")
    (num_pregunta (num 11))
)

(defrule PreguntasAsignaturas
    (declare (salience 9998))
    ?x <- (Asignatura ? ?a)
    ?y <- (num_pregunta (num ?n))
    =>
    (assert (Pregunta ?n (str-cat (str-cat "Te ha gustado la asignatura " ?a) "?")))
    (modify ?y (num (+ ?n 1)))
    (retract ?x)
)

(defrule inicio
    (declare (salience 9999))
    =>
    (printout t
    "Hola! No sabes que mencion escoger? No te preocupes!" crlf
    "Contesta a algunas preguntas y te dire que mencion deberias escoger y los motivos por los que deberias escogerla" crlf
    "Empecemos!" crlf crlf)
)

(defrule preguntar
    ?x <- (Pregunta ?np ?p)
    =>
    (printout t ?p crlf)
    (assert (Respuesta ?np (upcase (readline))))
    (retract ?x)
)

; (defrule test_respuesta
;     (Respuesta ?np ?r)
;     =>
;     (printout t ?r crlf)
; )

(defrule valorar_respuesta
    ?x <- (Respuesta ?np ?r)
    =>
    (assert (Valoracion ?np 
        (switch ?r
            (case "MUCHISIMO" then 5)
            (case "ME ENCANTA" then 5)
            (case "MUCHO" then 5)
            (case "BASTANTE" then 5)
            ;-------------------------------------
            (case "SI" then 4)
            (case "ME GUSTA" then 4)
            (case "SI ME GUSTA" then 4)
            (case "POCO" then 4)
            (case "UN POCO" then 4)
            ;------------------------------------
            (case "NO SE" then 3)
            (case "REGULAR" then 3)
            (case "MAS O MENOS" then 3)
            (case "NI IDEA" then 3)
            ;------------------------------------
            (case "NO" then 2)
            (case "NO ME GUSTA" then 2)
            (case "NO MUCHO" then 2)
            (case "NO TANTO" then 2)
            (case "NO ME GUSTA MUCHO" then 2)
            ;------------------------------------
            (case "MUY POCO" then 1)
            (case "NADA" then 1)
            (case "NO ME GUSTA NADA" then 1)
            (case "PARA NADA" then 1)
            (default 3)
        )
    ))
)

(defrule razonar_respuesta
    ?x <- (Valoracion ?np ?v)
    ?a <- (ValoracionRama (rama CSI) (val ?csi))
    ?b <- (ValoracionRama (rama IS) (val ?is))
    ?c <- (ValoracionRama (rama IC) (val ?ic))
    ?d <- (ValoracionRama (rama SI) (val ?si))
    ?e <- (ValoracionRama (rama TI) (val ?ti))
    =>
    (switch ?np
        ; Un "case" por pregunta
        ; Te gusta la programacion?
        (case 1 then
            ; ¿¿Cómo afecta la respuesta a la valoración de cada una de las ramas?? [0,1]
            ;                                      |
            ;                                      v
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
            ; Insertamos tambien consejos
        )
        ; Te gustan las matemáticas
        (case 2 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 3 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 4 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 5 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 6 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 7 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 8 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 9 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 10 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 11 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 12 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 13 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 14 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 15 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 16 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 17 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 18 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 19 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 20 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 21 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 22 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 23 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 24 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 25 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 26 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 27 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 28 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 29 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
        (case 30 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
        )
    )
    (retract ?x) ; <- importante
)