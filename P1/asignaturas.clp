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
    (ValoracionRama (rama "Computacion y Sistemas Inteligentes") (val 0))
    (ValoracionRama (rama "Ingenieria del Software") (val 0))
    (ValoracionRama (rama "Ingenieria de Computadores") (val 0))
    (ValoracionRama (rama "Sistemas de Informacion") (val 0))
    (ValoracionRama (rama "Tecnologias de la Informacion") (val 0)) 
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
    (ValoracionRama (rama ?r) (val ?v))
    (not (exists (fin ?)))
    =>
    (printout t ?p crlf)
    (assert (Respuesta ?np (upcase (readline))))
    (retract ?x)
)

(defrule terminar
    (declare (salience 1000))
    (ValoracionRama (rama ?r) (val ?v))
    (test (or (> ?v 25) (= ?v 25)))
    =>
    (printout t crlf "Te recomiendo la rama de " ?r " porque" crlf)
    (assert (fin ?r))
)

(defrule aconsejar
    (declare (salience 2000))
    (fin ?r)
    ?x <- (Consejo ?r ?txt)
    =>
    (printout t ?txt crlf)
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
            (case "ME ENCANTO" then 5)
            (case "MUCHO" then 5)
            (case "ME GUSTA MUCHO" then 5)
            (case "ME GUSTO MUCHO" then 5)
            (case "BASTANTE" then 5)
            ;-------------------------------------
            (case "SI" then 4)
            (case "ME GUSTA" then 4)
            (case "ME GUSTO" then 4)
            (case "SI ME GUSTA" then 4)
            (case "SI ME GUSTO" then 4)
            (case "ME GUSTA UN POCO" then 4)
            (case "ME GUSTO UN POCO" then 4)
            ;------------------------------------
            (case "NO SE" then 3)
            (case "REGULAR" then 3)
            (case "MAS O MENOS" then 3)
            (case "NI IDEA" then 3)
            ;------------------------------------
            (case "NO" then 2)
            (case "NO ME GUSTA" then 2)
            (case "NO ME GUSTO" then 2)
            (case "NO MUCHO" then 2)
            (case "NO TANTO" then 2)
            (case "NO ME GUSTA MUCHO" then 2)
            (case "NO ME GUSTO MUCHO" then 2)
            (case "POCO" then 2)
            (case "UN POCO" then 2)
            ;------------------------------------
            (case "MUY POCO" then 1)
            (case "NADA" then 1)
            (case "NO ME GUSTA NADA" then 1)
            (case "NO ME GUSTO NADA" then 1)
            (case "PARA NADA" then 1)
            (case "EN ABSOLUTO" then 1)
            (case "LO ODIO" then 1)
            (case "LA ODIO" then 1)
            (default 3)
        )
    ))
)

(defrule razonar_respuesta
    ?x <- (Valoracion ?np ?v)
    ?a <- (ValoracionRama (rama "Computacion y Sistemas Inteligentes") (val ?csi))
    ?b <- (ValoracionRama (rama "Ingenieria del Software") (val ?is))
    ?c <- (ValoracionRama (rama "Ingenieria de Computadores") (val ?ic))
    ?d <- (ValoracionRama (rama "Sistemas de Informacion") (val ?si))
    ?e <- (ValoracionRama (rama "Tecnologias de la Informacion") (val ?ti))
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
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusta programar")
                (assert
                    (Consejo "Computacion y Sistemas Inteligentes" ?motivo1)
                    (Consejo "Ingenieria del Software" ?motivo1)
                )
            )
        )
        ; Te gustan las matemáticas?
        (case 2 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 0.8)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.6)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.2)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.2)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gustan las matematicas")
                (assert
                    (Consejo "Computacion y Sistemas Inteligentes" ?motivo1)
                    (Consejo "Ingenieria del Software" ?motivo1)
                )
            )
        )
        ; Se te dan bien las matematicas?
        (case 3 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 0.4)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.2)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.2)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Se te dan bien las matematicas")
                (assert
                    (Consejo "Computacion y Sistemas Inteligentes" ?motivo1)
                )
            )
        )
        ; Te gusta lo relacionado con la IA?
        (case 4 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 0.2)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.2)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.2)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusta la Inteligencia Artificial")
                (assert
                    (Consejo "Computacion y Sistemas Inteligentes" ?motivo1)
                )
            )
        )
        ; Te gusta el mundo de la robotica?
        (case 5 then
            (modify ?a (val (+ ?csi (integer (* ?v 0.8)))))
            (modify ?b (val (+ ?is (integer (* ?v 0.4)))))
            (modify ?c (val (+ ?ic (integer (* ?v 1)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.2)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusta la robotica")
                (assert
                    (Consejo "Computacion y Sistemas Inteligentes" ?motivo1)
                    (Consejo "Ingenieria de Computadores" ?motivo1)
                )
            )
        )
        ; Te gustan los videojuegos?
        (case 6 then
            (modify ?a (val (+ ?csi (integer (* ?v 0.6)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.2)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.2)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gustan los videojuegos")
                (assert
                    (Consejo "Computacion y Sistemas Inteligentes" ?motivo1)
                    (Consejo "Ingenieria del Software" ?motivo1)
                )
            )
        )
        ; Te gusta la informatica tipo web?
        (case 7 then
            (modify ?a (val (+ ?csi (integer (* ?v 0.2)))))
            (modify ?b (val (+ ?is (integer (* ?v 0.8)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 1)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.8)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusta la informatica web")
                (assert
                    (Consejo "Sistemas de Informacion" ?motivo1)
                    (Consejo "Tecnologias de la Informacion" ?motivo1)
                )
            )
        )
        ; Te gustan los sistemas informaticos?
        (case 8 then
            (modify ?a (val (+ ?csi (integer (* ?v 0.2)))))
            (modify ?b (val (+ ?is (integer (* ?v 0.2)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 1)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.6)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gustan los sistemas informaticos")
                (assert
                    (Consejo "Sistemas de Informacion" ?motivo1)
                )
            )
        )
        ; Te gustan las redes y los servidores?
        (case 9 then
            (modify ?a (val (+ ?csi (integer (* ?v 0.2)))))
            (modify ?b (val (+ ?is (integer (* ?v 0.4)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 1)))))
            (modify ?e (val (+ ?ti (integer (* ?v 1)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusta las redes, servidores, etc.")
                (assert
                    (Consejo "Sistemas de Informacion" ?motivo1)
                    (Consejo "Tecnologias de la Informacion" ?motivo1)
                )
            )
        )
        ; Te gustan las bases de datos?
        (case 10 then
            (modify ?a (val (+ ?csi (integer (* ?v 0.2)))))
            (modify ?b (val (+ ?is (integer (* ?v 0.2)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 1)))))
            (modify ?e (val (+ ?ti (integer (* ?v 1)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gustan las bases de datos")
                (assert
                    (Consejo "Sistemas de Informacion" ?motivo1)
                    (Consejo "Tecnologias de la Informacion" ?motivo1)
                )
            )
        )
        ; Fundamentos de Programacion
        (case 11 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.8)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.8)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.8)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusto Fundamentos de Programacion")
                (assert
                    (Consejo "Computacion y Sistemas Inteligentes" ?motivo1)
                    (Consejo "Ingenieria del Software" ?motivo1)
                    (Consejo "Sistemas de Informacion" ?motivo1)
                )
            )
        )
        ; Fundamentos del Software
        (case 12 then
            (modify ?a (val (+ ?csi (integer (* ?v 0.2)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.8)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.8)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.8)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusto Fundamentos del Software")
                (assert
                    (Consejo "Computacion y Sistemas Inteligentes" ?motivo1)
                    (Consejo "Ingenieria del Software" ?motivo1)
                    (Consejo "Sistemas de Informacion" ?motivo1)
                    (Consejo "Tecnologias de la Informacion" ?motivo1)
                )
            )
        )
        ; Fundamentos Fisicos y Tecnologicos
        (case 13 then
            (modify ?a (val (+ ?csi (integer (* ?v 0.2)))))
            (modify ?b (val (+ ?is (integer (* ?v 0.2)))))
            (modify ?c (val (+ ?ic (integer (* ?v 1)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.2)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.2)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusto Fundamentos del Software")
                (assert
                    (Consejo "Ingenieria del Computadores" ?motivo1)
                )
            )
        )
        ; Calculo
        (case 14 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 0.2)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.2)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.2)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusto Calculo")
                (assert
                    (Consejo "Computacion y Sistemas Inteligentes" ?motivo1)
                )
            )
        )
        ; Algebra
        (case 15 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 0.2)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.2)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.2)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusto Algebra")
                (assert
                    (Consejo "Computacion y Sistemas Inteligentes" ?motivo1)
                )
            )
        )
        ; Metodologia de la Programacion
        (case 16 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.8)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.8)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.8)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusto Algebra")
                (assert
                    (Consejo "Computacion y Sistemas Inteligentes" ?motivo1)
                    (Consejo "Ingenieria del Software" ?motivo1)
                    (Consejo "Sistemas Inteligentes" ?motivo1)
                )
            )
        )
        ; Tecnologia y Organizacion de Computadores
        (case 17 then
            (modify ?a (val (+ ?csi (integer (* ?v 0.2)))))
            (modify ?b (val (+ ?is (integer (* ?v 0.2)))))
            (modify ?c (val (+ ?ic (integer (* ?v 1)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.2)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.2)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusto Tecnologia y Organizacion de Computadores")
                (assert
                    (Consejo "Ingenieria del Computadores" ?motivo1)
                )
            )
        )
        ; Logica y Metodos Discretos
        (case 18 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 0.2)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.2)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.2)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusto Logica y Metodos Discretos")
                (assert
                    (Consejo "Computacion y Sistemas Inteligentes" ?motivo1)
                )
            )
        )
        ; Ingenieria, Empresa y Sociedad
        (case 19 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 1)))))
            (modify ?d (val (+ ?si (integer (* ?v 1)))))
            (modify ?e (val (+ ?ti (integer (* ?v 1)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusto Ingenieria, Empresa y Sociedad")
                (assert
                    (Consejo "Ingenieria del Software" ?motivo1)
                    (Consejo "Sistemas de Informacion" ?motivo1)
                )
            )
        )
        ; Estadistica
        (case 20 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 0.8)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.8)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.2)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusto Estadistica")
                (assert
                    (Consejo "Computacion y Sistemas Inteligentes" ?motivo1)
                    (Consejo "Ingenieria del Software" ?motivo1)
                    (Consejo "Sistemas de Informacion" ?motivo1)
                )
            )
        )
        ; Sistemas Operativos
        (case 21 then
            (modify ?a (val (+ ?csi (integer (* ?v 0.2)))))
            (modify ?b (val (+ ?is (integer (* ?v 0.2)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 1)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.8)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusto Sistemas Operativos")
                (assert
                    (Consejo "Tecnologias de la Informacion" ?motivo1)
                    (Consejo "Sistemas de Informacion" ?motivo1)
                )
            )
        )
        ; Estructuras de Datos
        (case 22 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.4)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.6)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.6)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusto Sistemas Operativos")
                (assert
                    (Consejo "Computacion y Sistemas Inteligentes" ?motivo1)
                    (Consejo "Ingenieria del Software" ?motivo1)
                )
            )
        )
        ; Programacion y Diseño Orientado a Objetos
        (case 23 then
            (modify ?a (val (+ ?csi (integer (* ?v 0.6)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.4)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusto Sistemas Operativos")
                (assert
                    (Consejo "Ingenieria del Software" ?motivo1)
                )
            )
        )
        ; Sistemas Concurrentes y Distribuidos
        (case 24 then
            (modify ?a (val (+ ?csi (integer (* ?v 0.2)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.4)))))
            (modify ?d (val (+ ?si (integer (* ?v 1)))))
            (modify ?e (val (+ ?ti (integer (* ?v 1)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusto Sistemas Operativos")
                (assert
                    (Consejo "Sistemas de Informacion" ?motivo1)
                    (Consejo "Tecnologias de la Informacion" ?motivo1)
                )
            )
        )
        ; Estructura de Computadores
        (case 25 then
            (modify ?a (val (+ ?csi (integer (* ?v 0.2)))))
            (modify ?b (val (+ ?is (integer (* ?v 0.2)))))
            (modify ?c (val (+ ?ic (integer (* ?v 1)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.2)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.2)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusto Sistemas Operativos")
                (assert
                    (Consejo "Ingenieria de Computadores" ?motivo1)
                )
            )
        )
        ; Arquitectura de Computadores
        (case 26 then
            (modify ?a (val (+ ?csi (integer (* ?v 0.2)))))
            (modify ?b (val (+ ?is (integer (* ?v 0.2)))))
            (modify ?c (val (+ ?ic (integer (* ?v 1)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.2)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.2)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusto Sistemas Operativos")
                (assert
                    (Consejo "Ingenieria de Computadores" ?motivo1)
                )
            )
        )
        ; Fundamentos de Bases de Datos
        (case 27 then
            (modify ?a (val (+ ?csi (integer (* ?v 0.2)))))
            (modify ?b (val (+ ?is (integer (* ?v 0.8)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 1)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.4)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusto Sistemas Operativos")
                (assert
                    (Consejo "Ingenieria del Software" ?motivo1)
                    (Consejo "Sistemas de Informacion" ?motivo1)
                )
            )
        )
        ; Algoritmica
        (case 28 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 0.4)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.2)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.2)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusto Algoritmica")
                (assert
                    (Consejo "Computacion y Sistemas Inteligentes" ?motivo1)
                )
            )
        )
        ; Inteligencia Artificial
        (case 29 then
            (modify ?a (val (+ ?csi (integer (* ?v 1)))))
            (modify ?b (val (+ ?is (integer (* ?v 0.2)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.2)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.2)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusto Inteligencia Artificial")
                (assert
                    (Consejo "Computacion y Sistemas Inteligentes" ?motivo1)
                )
            )
        )
        ; Fundamentos de Ingenieria del Software
        (case 30 then
            (modify ?a (val (+ ?csi (integer (* ?v 0.2)))))
            (modify ?b (val (+ ?is (integer (* ?v 1)))))
            (modify ?c (val (+ ?ic (integer (* ?v 0.2)))))
            (modify ?d (val (+ ?si (integer (* ?v 0.2)))))
            (modify ?e (val (+ ?ti (integer (* ?v 0.2)))))
            (if (> ?v 3) then
                (bind ?motivo1 "Te gusto Fundamentos de Ingenieria del Software")
                (assert
                    (Consejo "Ingenieria del Software" ?motivo1)
                )
            )
        )
    )
    (retract ?x) ; <- importante
)