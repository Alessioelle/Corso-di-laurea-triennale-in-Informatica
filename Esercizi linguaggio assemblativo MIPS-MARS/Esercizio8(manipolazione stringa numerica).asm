#Realizzare un programma in linguaggio assemblativo MIPS-MARS che genera un numero intero in maniera casuale compreso tra i valori 1100000 e 3300000 e riporta le cifre in ordine inverso.
#Esempio: Input (valore randomico creato automaticamente): 12051985 Output: 58915021
#OSS: evitare, se possibile, di ricorrere a cicli per la generazione del numero nell'intervallo richiesto.

.globl main

.data

stringainput: .asciiz "Il numero intero compreso tra 1100000 e 3300000 generato casualmente dal programma è: "
stringaoutput: .asciiz "\n\nLe cifre in ordine inverso del numero generato casualmente all'interno del programma equivalgono a: "
spazio: .byte 100

.text

main:
li $t0,1100000         #inizializzo limite minimo generazione autmatica intero in $t0
li $t2,10              #inizializzo numero per recupero cifre in $t2
li $t4,0               #inizializzo contatore cicli prelievo elementi        
li $t5,0               #inizializzo contatore cicli stampa elementi
li $a1,3300001         #inizializzo limite massimo generazione automatica intero in $a1
sub $a1,$a1,$t0        #inizializzo limite massimo reale generazione automatica intero da tastiera in $a1
li $v0,42              #genero intero casuale tra 0 e 2200000 e lo sposto nel registro 4t1
syscall
move $t1,$a0
add $t1,$t1,$t0        #addiziono al numero generato casualmente 1100000 e storo risultato di interesse nel registro $t1
li $v0,4               #stampo a schermo numero generato casualmente
la $a0,stringainput
syscall
li $v0,1
move $a0,$t1
syscall

cicloprelievo:
rem $t3,$t1,$t2        #divido numero per dieci e recupero ultima cifra e la metto in $t3
mflo $t1               #il quoziente della divisione lo metto invece in $t1
sb $t3,spazio($t4)     #salvo la cifra di interesse in memoria dati
beqz $t1,chiusura      #se numero casuale ha raggiunto valore zero salto a chiusura
addi $t4,$t4,1         #altrimenti conto ciclo e salto a cicloprelievo
j cicloprelievo 


chiusura:              #stampo a schermo stringa finale
li $v0,4
la $a0,stringaoutput
syscall
ciclochiusura:         #stampo a schermo ogni cifra recuperata ma al contrario come intero di byte
li $v0,1
lb $a0,spazio($t5)
syscall
addi $t5,$t5,1         #aggiunto 1 al contatore di ogni ciclochiusura effettuato
bgt $t5,$t4,fine       #salto a fine quando contatore ciclochiusura supera contatore cicloprelievo
j ciclochiusura
fine:                  #termino esecuzione programma
li $v0,10
syscall

