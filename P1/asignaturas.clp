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

(deffacts Ramas
    (Rama Computacion_y_Sistemas_Inteligentes)
    (Rama Ingenieria_del_Software)
    (Rama Ingenieria_de_Computadores)
    (Rama Sistemas_de_Informacion)
    (Rama Tecnologias_de_la_Informacion)
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

; PAG 16 del FAQ
(deftemplate num_pregunta (slot num))

(deffacts Preguntas
    (Pregunta 1 "Te gusta la programacion?")
    (Pregunta 2 "Te gustan las matematicas?")
    (Pregunta 3 "Se te dan bien las matematicas?")
    (Pregunta 4 "Te gusta lo relacionado con la inteligencia artificial?")
    (Pregunta 5 "Te gusta el mundo de la robotica?")
    (Pregunta 6 "Te gustan los videojuegos?")
    (Pregunta 7 "Te gusta la informatica web?")
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
    (retract ?x)
    (modify ?y (num (+ ?n 1)))
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
            (case "5" then 5)
            ;-------------------------------------
            (case "SI" then 4)
            (case "MUCHO" then 4)
            (case "BASTANTE" then 4)
            (case "ME GUSTA" then 4)
            (case "4" then 4)
            ;------------------------------------
            (case "NO SE" then 3)
            (case "REGULAR" then 3)
            (case "MAS O MENOS" then 3)
            (case "NI IDEA" then 3)
            (case "3" then 3)
            ;------------------------------------
            (case "NO" then 2)
            (case "POCO" then 2)
            (case "UN POCO" then 2)
            (case "NO MUCHO" then 3)
            (case "NO TANTO" then 3)
            (case "2" then 2)
            ;------------------------------------
            (case "MUY POCO" then 1)
            (case "NADA" then 1)
            (case "NO ME GUSTA" then 1)
            (case "PARA NADA" then 1)
            (case "1" then 1)
            (default 3)
        )
    ))
)