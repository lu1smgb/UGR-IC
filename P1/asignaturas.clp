; Así, la práctica consiste en crear un programa en CLIPS que:
; Le pregunte al usuario que pide asesoramiento lo que le
;   preguntaríais a alguien que os pida consejo en ese sentido,
;   y de la forma y orden en que lo preguntaríais vosotros.
; Razone y tome decisiones cómo lo haríais vosotros para esta tarea.
; Le aconseje la rama o las ramas que le aconsejaríais vosotros, 
;   junto con los motivos por los que se le aconseja.

; La maquina tiene que simular nuestro comportamiento

; Vamos a suponer que el estudiante ya ha cursado los dos primeros
; cursos de la carrera, de modo que podemos hacerle preguntas sobre
; esto en concreto

(deffacts Ramas
    (Rama Computación_y_Sistemas_Inteligentes)
    (Rama Ingeniería_del_Software)
    (Rama Ingeniería_de_Computadores)
    (Rama Sistemas_de_Información)
    (Rama Tecnologías_de_la_Información)
)

; (Consejo <nombre de la rama> <contexto>)
; (Calificacion_media Alta|Media|Baja)
; (calificacion_media ?c)