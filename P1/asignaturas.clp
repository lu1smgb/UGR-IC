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
    (Asignatura FP)     ; Fundamentos de Programacion
    (Asignatura FS)     ; Fundamentos del Software
    (Asignatura FFT)    ; Fundamentos Fisicos y Tecnologicos
    (Asignatura CA)     ; Calculo
    (Asignatura ALEM)   ; Algebra Lineal y Estructuras Matematicas
    ;-------------------;-------------------------------------------
    (Asignatura MP)     ; Metodologia de la Programacion
    (Asignatura TOC)    ; Tecnologia y Organizacion de Computadores
    (Asignatura LMD)    ; Logica y metodos discretos
    (Asignatura IES)    ; Ingenieria, empresa y sociedad
    (Asignatura ES)     ; Estadistica
)

(deffacts AsignaturasSegundo
    (Asignatura SO)     ; Sistemas Operativos
    (Asignatura ED)     ; Estructuras de Datos
    (Asignatura PDOO)   ; Programacion y Diseño Orientado a Objetos
    (Asignatura SCD)    ; Sistemas Concurrentes y Distribuidos
    (Asignatura EC)     ; Estructura de Computadores
    ;-------------------;-------------------------------------------
    (Asignatura AC)     ; Arquitectura de computadores
    (Asignatura FBD)    ; Fundamentos de Bases de Datos
    (Asignatura ALG)    ; Algoritmica
    (Asignatura IA)     ; Inteligencia artificial
    (Asignatura FIS)    ; Fundamentos de Ingenieria del Software
)

; TODO: Formular preguntas del programa

; (Consejo <nombre de la rama> <contexto>)
; (Calificacion_media Alta|Media|Baja)
; (calificacion_media ?c)