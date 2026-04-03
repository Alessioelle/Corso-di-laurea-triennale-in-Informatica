#Data una matrice Arxc di elementi halfword, realizzare un programma, in linguaggio assemblativo MIPS-MARS, che restituisca la somma degli elementi la cui somma degli indici è multipla di 3; 
#cioè sommare tutti gli ai,j con i+j multiplo di 3. La matrice, il numero di righe R e il numero di colonne C sono definite in memoria; il risultato è stampato a video (mediante syscall).
#Per l’inizializzazione della matrice è possibile utilizzare l’esempio. NB: Il programma deve essere valido per ogni matrice di dimensione RxC variabile.

.globl main


.data

stringaoutput: .asciiz "\n\nLa somma di tutti gli elementi appartenenti alla matrice in memoria con indice i+j multiplo di 3 è uguale a : "
nrig: .word 3
ncol: .word 5
matrice: .half 1,0,7,5,1970
               8,2,14,10,456
               2,23,12,1974,15
               
.text


main:
li $t0,0               #inizializzo registro $t0 per risultato finale
lw $t1,nrig            #inizializzo registro $t1 con numero righe matrice in memoria
lw $t2,ncol            #inizializzo registro $t2 con numero colonne matrice in memoria
li $t3,1               #inizializzo registro $t3 con r primo elemento da controllare
li $t4,1               #inizializzo registro $t4 con c primo elemento da controllare 
li $t8,2               #inizializzo registro $t8 con dimensione elementi matrice

funzione:
add $t5,$t3,$t4
rem $t5,$t5,3
beqz $t5,contatore
j colonnasuccessiva


chiusura:
li $v0,4
la $a0,stringaoutput
syscall
li $v0,1
move $a0,$t0
syscall
li $v0,10
syscall

#-----------------------------------------------------------------------------------------

contatore:             #prendo elemento di interesse e lo sommo a valore storato in $t0 per stampa risultato finale
sub $t6,$t3,1          #r-1
mul $t6,$t2,$t6        #C(r-1)
sub $t7,$t4,1          #(c-1) 
add $t6,$t6,$t7        #C(r-1)+(c-1) #calcolo indice elemnto di interesse
mul $t6,$t6,$t8        #indice*dimensione elemento di interesse e metto in $t6
lh $t7,matrice($t6)    #prelevo elemento di interesse e lo metto in $t7
add $t0,$t0,$t7
colonnasuccessiva:
add $t4,$t4,1
bgt $t4,$t2,rigasuccessiva
j funzione
rigasuccessiva:
add $t3,$t3,1
bgt $t3,$t1,chiusura
li $t4,1
j funzione
