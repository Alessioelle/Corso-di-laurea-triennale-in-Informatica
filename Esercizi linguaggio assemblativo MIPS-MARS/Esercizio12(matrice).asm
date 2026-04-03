#Data una matrice ARxc di elementi halfword, realizzare un programma, in linguaggio assemblativo MIPS-MARS, che restituisca la somma degli elementi la cui somma degli indici è multipla di 3; 
#cioè sommare tutti gli aij con i+j multiplo di 3.

.globl main

.data
stringaoutput: .asciiz "\nLa somma degli elementi della matrice Arxc storata in memoria dati la cui somma degli indici è multipla di tre risulta essere di "
nrig: .word 3
ncol: .word 4
dimensionelementi: .word 2
matrice: .half 22,10,55,400
               10,88,125,-23
               9999,34,77,198
               
.text

main:
lw $t1,nrig                 #metto nel registro $t1 il numero massimo di righe della matrice in memoria
lw $t2,ncol                 #metto nel registro $t2 numero massimo di colonne della matrice in memoria
lw $t7,dimensionelementi    #metto nel registro $t7 dimensione elementi matrice
move $t5,$t2                #metto nel registro $t3 numero massimo di colonne della matrice
li $t0,0                    #inizializzo registro per risultato finale
ciclocolonne:               #controllo tutti gli elementi della riga riducendo indice colonna
add $t3,$t1,$t2             #sommo indici i+j
rem $t3,$t3,3               #vedo se la somma degli indici i+j è multiplo di 3
beqz $t3,prelevoelemento    #se resto divisione uguale a zero salto a funzione prelevoelemento per prelevare elemento a posizione corrispondente indici
subi $t2,$t2,1              #riduco di una posizione indice colonna
beqz $t2,ciclorighe         
j ciclocolonne


chiusura:                   #stampa a schermo il risultato della somma richiesta che risulta essere storato nel registro $t0
li $v0,4
la $a0,stringaoutput
syscall
li $v0,1
move $a0,$t0
syscall
li $v0,10
syscall

#------------------------------------------------------------------------------

ciclorighe:                 #terminata la riga passo a riga precedente 
subi $t1,$t1,1              #diminuisco di una posizione indice righe
move $t2,$t5                #resetto a valore iniziale indice colonne
beqz $t1,chiusura           #quando raggiungo indice righe uguale a zero salto a chiusura programma per stampa risultato a schermo
j ciclocolonne              #altrimento salto a ciclo colonne

#------------------------------------------------------------------------------


prelevoelemento:
li $t6,0                    #resetto registro per calcolo posizione elemento
sub $t4,$t1,1               #calcolo indice elemento matrice 
mul $t4,$t5,$t4
sub $t6,$t2,1
add $t6,$t6,$t4
mul $t6,$t6,$t7
lh $t8,matrice($t6)         #metto nel registro $t8 valore di interesse
add $t0,$t0,$t8             #sommo valore di interesse al valore già salvato dentro il registro $t0
subi $t2,$t2,1              #riduco di una posizione indice colonna
beqz $t2,ciclorighe  
j ciclocolonne
