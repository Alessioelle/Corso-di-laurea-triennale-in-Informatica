#Realizzare un programma in linguaggio assemblativo MIPS-MARS che risolve l'equazione di secondo grado ax2+bx+c con a,b,c interi (word) immessi da input (e a diverso da 0). 
#La soluzione deve essere espressa come numeri reali e stampata a video. Segnalare con messaggi testuali eventuali casi anomali.
#La formula da utilizzare per la risoluzione della equazione di secondo grado è: x1,2 = {-b±[(b2-4ac)^1/2]}/2a

.globl main

.data
stringa1: .asciiz "Immetta tre numeri interi da tastiera rispettando il vincolo che il primo risulti diverso da zero:"
stringa2: .asciiz "Ops, sembrerebbe che il primo intero inserito non sia corretto. Inserisca nuovamente i tre numeri interi ricordando che il primo deve risultare diverso da zero:"
stringa3: .asciiz "Il programma e'stato progettato per risolvere l'equazione di secondo grado ax2+bx+c con a,b,c uguali ai tre input da lei inseriti. Le due soluzioni sono:"
soluzione1: .asciiz "Due soluzioni non reali" 
soluzione2: .asciiz "Due soluzioni coincidenti x1,2="
soluzione3: .asciiz "x1="
soluzione4: .asciiz "e x2="
spazio: .asciiz "\t"
acapo: .asciiz "\n"

.text

main:       

li $v0,4                   #stampo istruzioni per utente a schermo e salvo input in ingresso in $t0, $t1 e $t2
la $a0,stringa1
syscall
li $v0,5
syscall
move $t0,$v0
beqz $t0,erroreinput  
input:       
li $v0,5
syscall
move $t1,$v0
li $v0,5
syscall
move $t2,$v0
j risoluzioneequazione
erroreinput:               #stampo istruzioni per utente a schermo e salvo input in ingresso in $t0, $t1 e $t2
li $v0,4
la $a0,acapo
syscall
li $v0,4                
la $a0,stringa2
syscall
li $v0,5
syscall
move $t0,$v0
beqz $t0,erroreinput
j input

risoluzioneequazione:      #(n.b. onde evitare problemi di overflow nelle moltiplicazioni e il troncamento dei risultati sarebbe meglio operare con gli stessi già all'interno del coprocessore
li $t5,-1                  #immetto valore utile per calcolo -b
li $t6,2                   #immetto valore utile per calcolo 2a
li $t7,4                   #immetto valore utile per calcolo 2a
mul $t3,$t1,$t1            #risolvo b^2
mul $t4,$t0,$t2            #risolvo 4ac
mul $t4,$t4,$t7
sub $t3,$t3,$t4            #risolvo b^2-4ac
bltz $t3,stampasoluzione1  #se b^2-4ac minore di zero allora si hanno due soluzioni impossibili e termino esecuzione programma
mul $t1,$t1,$t5            #risolvo -b
mul $t0,$t0,$t6            #risolvo 2a
beqz $t3,stampasoluzione2  #se b^2-4ac uguale a zero allora si hanno due soluzioni uguali, salto a calcolo soluzione
mtc1 $t3,$f0               #in questo caso b^2-4ac ha un valore maggiore di zero allora si hanno due soluzioni distinte, procedo al calcolo nel coprocessore matematico storando e convertendo
mtc1 $t1,$f2               #i valori nei registri previsti per lavorare nel coprocessore       
mtc1 $t0,$f4
cvt.d.w $f0,$f0
cvt.d.w $f2,$f2
cvt.d.w $f4,$f4
sqrt.d $f0,$f0             #risolvo la radice quadrata [(b2-4ac)^1/2] e la salvo in $f0 in double precision
add.d $f6,$f2,$f0          #calcolo prima soluzione e la salvo in $f6 in double precision
div.d $f6,$f6,$f4
sub.d $f8,$f2,$f0          #calcolo seconda soluzione e la salvo in $f8 in double precision
div.d $f8,$f8,$f4
stampasoluzione3:          #stampo a schermo le due soluzioni x1=$f6 e x2=$f8 (n.b. per stampare a schermo double il condition flag zero del coprocessore deve essere flaggato prima
li $v0,4                   #dell'esecuzione del programma
la $a0,acapo
syscall
li $v0,4
la $a0,stringa3
syscall
li $v0,4
la $a0,acapo
syscall
li $v0,4
la $a0,soluzione3
syscall
li $v0,3
movt.d $f12,$f6
syscall
li $v0,4
la $a0,spazio
syscall
li $v0,4
la $a0,soluzione4
syscall
li $v0,3
movt.d $f12,$f8
syscall
j fine

stampasoluzione1:
li $v0,4
la $a0,acapo
syscall
li $v0,4
la $a0,stringa3
syscall
li $v0,4
la $a0,acapo
syscall
li $v0,4
la $a0,soluzione1
syscall
j fine

stampasoluzione2:
div $t4,$t1,$t0          #risolvo -b\2a e storo risultato in $t4
li $v0,4                 #stampo a schermo la soluzione comune combaciante x1,2=$t4 in quanto il delta è risultato uguale a zero
la $a0,acapo
syscall
la $a0,stringa3
syscall
li $v0,4
la $a0,acapo
syscall
li $v0,4
la $a0,soluzione2
syscall
li $v0,1
move $a0,$t4
syscall

fine:                    #termino l'esecuzione del programma  
li $v0,10
syscall

