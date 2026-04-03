#Scrivere un programma in linguaggio assemblativo MIPS-MARS che calcola la seguente funzione ricorsiva utilizzando lo stack: f(x,y)= f(x-2,y+3)+2x-3y se x+y<0
#                                                                                                                            f(x,y)= 12 altrimenti

.globl main

.data

stringainput: .asciiz "Salve, inserisca due interi da tastiera x e y compresi nell'intervallo [-32768,32767] in modo da permettere l'esecuzione del programma:"
stringaoutput: .asciiz "Il risultato della funzione generato sulla base degli input da lei inseriti è "
acapo: .asciiz "\n\n"
x: .word 0
y: .word 0

.text

main:
li $v0,4                 #stampo a schermo istruzioni per immissione input da parte dell'utente
la $a0,stringainput
syscall
li $v0,5                 #leggo valore x in ingresso e lo salvo in memoria dati 'x'
syscall
sw $v0,x
li $v0,5                 #leggo valore y in ingresso e lo salvo in memoria dati 'y'
syscall
sw $v0,y
li $t0,12                #inizializzo valore utile per calcolo funzione
li $t6,0                 #inizializzo valore registro risultato ricorsione
li $t7,0                 #inizializzo valore registro risultato finale
li $t8,0                 #inizializzo contatore cicli ricorsione
lw $t1,x                 #inizializzo valore input x nel registro $t1
lw $t2,y                 #inizializzo valore input y nel registro $t2
 
jal funzione

chiusura:
add $t7,$t7,$t0
li $v0,4
la $a0,acapo
syscall
li $v0,4
la $a0,stringaoutput
syscall
li $v0,1
move $a0,$t7
syscall
li $v0,10
syscall

#-----------------------------------------------------------------------------

funzione:
addi $t8,$t8,1
subi $sp,$sp,8              #inizializzo stack 2 posizioni word
sw $t6,0($sp)               #salvo valore risultante ciclo nello stack
sw $ra,4($sp)               #salvo indirizzo di ritorno main function nello stack
add $t3,$t1,$t2             #x+y
bge $t3,$zero,finefunzione
mul $t4,$t1,2               #2x
mul $t5,$t2,-3              #-3y
add $t6,$t4,$t5             #+2x-3y e salvo valore in $t6
subi $t1,$t1,2              #x-2
addi $t2,$t2,3              #y+3 
jal funzione

finefunzione:
subi $t8,$t8,1              #sottraggo a ritroso tutti i cicli ricorsivi effettuati
lw $t6,0($sp)               #inserisco in $t6 ultimo valore utile funzione calcolato
lw $ra,4($sp)               #inserisco in $ra ultimo indirizzo di ritorno utile (o finefunzione o main)
add $t7,$t7,$t6             #salvo in $t7 il risultato finale
addi $sp,$sp,8              #resetto 2 word di stack
bgt $t8,$zero,finefunzione  #se raggiungo numero cicli uguale a zero torno a main altrimenti ciclo finefunzione
jr $ra






