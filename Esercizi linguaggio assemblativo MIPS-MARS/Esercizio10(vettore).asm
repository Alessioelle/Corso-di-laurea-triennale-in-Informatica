#Realizza un programma in linguaggio assemblativo MIPS-MARS che inserisca in memoria un vettore di lunghezza 10 con valori compresi tra -2^32<x<2^31-1 ed un vettore di lunghezza 10 con valori compresi tra -2^8<x<2^7-1
#L'algoritmo deve prendere gli elementi che sono nella stessa posizione dei due vettori (stesso indice), elevarli al quadrato, ordinarli in ordine decrescente e dividerli.
#Se il quoziente risultante dalla divisione dovesse risultare multiplo di 10 allora il programma deve contare tale occorrenza
#Si procede in questo modo per tutti e 10 gli elementi dei due vettori e si procede a stampare a schermo il numero delle eventuali occorrenze riscontrate e a terminare l'esecuzione.

.globl main

.data

vettoreword: .word 60000,-32,80,56,77,15,33,99,450,301
lunghezzavettoreword: .word 10
vettorebyte: .byte 10,88,-20,29,33,5,3,10,120,98
lunghezzavettorebyte: .byte 10
stringafine: .asciiz "Il numero di quozienti multipli di dieci trovati all'interno della traccia equivale a:"
spazio: .asciiz "\t"

.text

main:
la $t1, vettoreword                         #punta in memoria indirizzo primo elemento vettoreword
la $t2, vettorebyte                         #punta in memoria indirizzo primo elemento vettorebyte
li $t5,0                                    #inizializza contatore cicli
li $t8,4                                    #incremento indirizzi vettore word
li $s1,1                                    #incremento indirizzi vettore byte
ciclo:                    
addi $t5,$t5,1                              #incremento indice 
bgt $t5,10,fine                             #salto a fine se ciclo effettuato su tutti e dieci gli elementi dei vettori
lw $t3,($t1)                                #salvo in $t3 indirizzo elemento vettoreword da confrontare
lb $t4,($t2)                                #salvo in $t4 indirizzo elemento vettorebyte da confrontare
add $t1,$t1,$t8                             #incremento indirizzo elemento vettoreword
add $t2,$t2,$s1                             #incremento indirizzo elemento vettorebyte
multu $t3,$t3                               #elevo al quadrato elemento vettoreword
mflo $s2
mfhi $s3
mul $t4,$t4,$t4                             #elevo al quadrato elemento vettorebyte
bgt $t4, $t3,secondomaggioreprimo           #se quadrato elemento vettorebyte maggiore quadrato elemento vettoreword salto a istruzione corretta che inverte divisione altrimenti proseguo con
primomaggioreugualesecondo:                 #divisione tra quadrato primo elemento e quadrato secondo elemento
div $t6,$t3,$t4
mflo $t6                                    #metto in $t6 il quoziente della divisione
div $t6,$t6,10                              #divido quoziente per dieci
mfhi $t6                                    #metto in $t6 resto della divisione e conto se uguale a zero (significherebbe che quoziente multiplo di dieci)
beqz $t6,conta
j ciclo                                     #ciclo fino a quando non termino controllo di tutti gli elementi


secondomaggioreprimo:
div $t6,$t4,$t3                             #divido secondo quadrato per il primo
mflo $t6                                    #metto in $t6 il quoziente della divisione
div $t6,$t6,10                              #divido quoziente per dieci
mfhi $t6                                    #metto in $t6 resto della divisione e conto se uguale a zero (significherebbe che quoziente multiplo di dieci)
beqz $t6,conta
j ciclo                                     #ciclo fino a quando non termino controllo di tutti gli elementi


conta:
addi $t7,$t7,1                              #conto le occorrenze trovate e le metto dentro al registro $t7 pronto per la stampa a schermo
j ciclo                                     #ciclo fino a quando non termino controllo di tutti gli elementi

 
fine:                                       #stampa a schermo il numero di quozienti multipli di dieci trovati all'interno della traccia salvato nel registro $t7
li $v0,4
la $a0,stringafine
syscall
li $v0,4
la $a0,spazio
syscall
li $v0,1
move $a0,$t7
syscall
