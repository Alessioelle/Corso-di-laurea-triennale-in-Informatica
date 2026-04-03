#Realizzare un programma in linmguaggio assemblativo MIPS-MARS che permetta l'immissione da input di un valore intero e stampa, a video, il numero di occorrenze della sottosequenza 10010 (con ripetizione).

.globl main

.data

stringa: .asciiz "Inserisca un numero intero da tastiera:"
stringa1: .asciiz "Il numero di occorrenze presenti all'interno del codice binario corrispondente all'intero da lei inserito è di:"
spazio: .asciiz "\t"
acapo: .asciiz "\n"

.text

main:

li $v0,4              #chiedi di inserire un intero da tastiera e salva il valore all'interno del registro $t1
la $a0,stringa
syscall
li $v0,5
syscall
move $t1,$v0
li $v0,4
la $a0,acapo
syscall


li $t0,-14            #inserisco in $t0 la stringa di controllo per la conta delle occorrenze ovvero 10010 
sll $t0,$t0,27
li $t3,27             #contatore numero di shift right da effettuare
li $t5,0              #inizializzo registro dove salvare numero occorrenze trovate
primocontrollo:
sll $t4,$t1,27
beq $t4,$t0,conta
subi $t3,$t3,1
srl $t1,$t1,1
ciclocontrollo:
sll $t4,$t1,27
beq $t4,$t0,conta
subi $t3,$t3,1
srl $t1,$t1,1
blt $t3,$zero fine
j ciclocontrollo


conta:                #conta numero di occorrenze trovate 
addi $t5,$t5,1
subi $t3,$t3,1
srl $t1,$t1,1
blt $t3,$zero fine
j ciclocontrollo



fine:                 #stampa a schermo il numero di occorrenze contate salvato all'interno del registro $t5
li $v0,4
la $a0,stringa1
syscall
li $v0,4
la $a0,spazio
syscall
li $v0,1
move $a0,$t5
syscall
