#Realizzare un programma in linguaggio assemblativo MIPS-MARS che legge un intero da tastiera e memorizza le cifre in ordine inverso. 
#Esempio: Input: 983178 Output: 871389

.globl main

.data

stringainput: .asciiz "\nInserisca un numero intero da tastiera:"
stringainput1: .asciiz "\n\nBene, il numero da lei inserito è "
stringaoutput: .asciiz " che scritto con le cifre in ordine inverso risulta uguale a "

.text:

main:
li $t1,0                       #inizializzo registro risultato in $t1
li $t6,10                      #inizializzo registro con divisore numero
li $t7,0                       #inizializzo registro per calcolo resto numero
li $t8,0                       #inizializzo registro per calcolo positività numero
li $v0,4                       #stampo a schermo istruzioni per utente
la $a0,stringainput
syscall
li $v0,5                       #leggo intero da tastiera e lo metto nel registro $t2
syscall
move $t2,$v0
li $v0,4
la $a0,stringainput1
syscall
sge $t8,$t2,$zero              #set a 1 registro $t8 se numero inserito è positivo altrimenti set a 0
abs $t2,$t2
ciclo:
div $t2,$t2,$t6
mfhi $t7                       #metto cifra di interesse in $t7
add $t1,$t1,$t7                #addiziono cifra di interesse nel registro risultato $t1
beqz $t2,chiusura
mul $t1,$t1,$t6                #moltiplico per 10 il risultato
j ciclo

chiusura:                      #se numero iniziale era negativo moltiplico per -1 altrimento salto a fine e stampo a schermo risultato
bne $t8,$zero,fine
mul $t1,$t1,-1
fine:                          #metti risultato nel registro $t1 e stampa a schermo
li $v0,1
move $a0,$t1
syscall
li $v0,10
syscall
                        
