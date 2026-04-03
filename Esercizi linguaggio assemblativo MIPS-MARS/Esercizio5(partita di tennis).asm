#Realizzare un programma in linguaggio assembly MIPS che simula la partita di tennis tra Sinner e il Alcaraz. L’incontro si basa su tre partite (o set). Ogni set è composto da un minimo
#di 6 giochi (o game) e per vincerlo è necessario conquistarne almeno sei con un vantaggio minimo di due (6-0, 6-1, 6-2, 6-3, 6-4 e 7-5). Il regolamento del torneo prevede che 
#sul punteggio di 6-6 si disputa tie-break, che chiude il set 7-6 o 6-7. Ad ogni turno un tennista genera un numero casuale da 0 a 10. 
#Il valore maggiore vince il gioco, nel caso di numero uguale entrambi vincono il gioco, nel caso di parità al tie break nella partita dispari vince Sinner. 
#Stampare i risultati di tutte e tre le partite e decretare il vincitore.

.globl main

.data

stringainput: .asciiz "\nBenvenuti all'incontro di tennis tra Sinner e Alcaraz! Diamo il via alla partita che si baserà su tre set!"
stringaoutput1: .asciiz "\n\nIl set numero "
stringasetsinner: .asciiz " è stato vinto da Sinner con un punteggio di "
stringasetalcaraz: .asciiz " è stato vinto da Alcaraz con un punteggio di "
stringaoutput2: .asciiz " a "
vincitafinalesinner: .asciiz"\n\nIl vincitore finale è Sinner!"
vincitafinalealcaraz: .asciiz "\n\nIl vincitore finale è Alcaraz!"

.text

main:
li $t0,0                            #inizializzo contatore set in $t0
li $t1,0                            #inizializzo registro per risultato casuale gioco SINNER in $t1
li $t2,0                            #inizializzo registro per risultato casuale gioco ALCARAZ in $t2
li $t3,0                            #inizializzo contatore giochi vinti SINNER in $t3
li $t4,0                            #inizializzo contatore giochi vinti ALCARAZ in $t4
li $t7,0                            #inizializzo contatore set vinti SINNER in $t7
li $t8,0                            #inizializzo contatore set vinti ALCARAZ in $t8
li $a1,11                           #inizializzo limite massimo generazione numero casuale in $a1

ciclogioco:
li $v0,42                           #genero numero casuale gioco SINNER e lo metto in $t1
syscall
move $t1,$a0
li $v0,42                           #genero numero casuale gioco ALCARAZ e lo metto in $t2
syscall
move $t2,$a0 
bgt $t1,$t2,vincesinner             #se $t1 maggiore o uguale di $t2 salto a vincesinner e aggiungo vincita gioco
bgt $t2,$t1,vincealcaraz            #se $t2 maggiore o uguale di $t1 salto a vincealcaraz e aggiungo vincita gioco
addi $t3,$t3,1                      #altrimenti vincono entrambi (se non già in pareggio 6 a 6) e aggiungo vincite gioco a entrambi
addi $t4,$t4,1
beq $t3,6,controlloset1             #se in $t3 si ha 6 controlliamo situazione 
beq $t4,6,controlloset2             #se in $t4 si ha 6 controlliamo situazione
beq $t3,7,controlloset1             #se in $t3 si ha 7 controlliamo situazione
beq $t4,7,controlloset2             #se in $t4 si ha 6 controlliamo situazione
j ciclogioco                        #altrimenti ciclo gioco

vincesinner:
addi $t3,$t3,1                      #aggiungo una vincita gioco a sinner
beq $t3,6,controlloset1             #se in $t3 si ha 6 controlliamo situazione
beq $t3,7,controlloset1             #se in $t3 si ha 7 controlliamo situazione
j ciclogioco                        #altrimenti ciclo gioco

vincealcaraz:
addi $t4,$t4,1                      #aggiungo una vincita gioco a alcaraz
beq $t4,6,controlloset2             #se in $t4 si ha 6 controlliamo situazione
beq $t4,7,controlloset2             #se in $t4 si ha 7 controlliamo situazione
j ciclogioco                        #altrimenti ciclo gioco

controlloset1:
add $t5,$t3,$t4                     #faccio somma risultati giochi sinner e alcaraz e metto in $t5
beq $t3,$t4,tiebreak                #se i valori in $t3 e $t4 sono uguali (quindi per forza entrambi 6 salto a tiebreak)
ble $t5,10,stampasinner             #se la somma dei valori è minore o uguale a 10 stampo vincita sinner (per forza tra 6-0 e 6-4)
bge $t5,12,stampasinner             #se la somma dei valori è maggiore o uguale a 12 stampo vincita alcaraz (per forza tra 7-5 0 7-6)
j ciclogioco                        #altrimenti ciclo gioco (nel caso 6-5)

stampasinner:
addi $t7,$t7,1                      #aggiungo 1 al contatore vincite set sinner
addi $t0,$t0,1                      #aggiungo 1 al contatore set effettuati
li $v0,4                            #stampo a schermo risultato n-esimo set
la $a0,stringaoutput1
syscall
li $v0,1
move $a0,$t0
syscall
li $v0,4
la $a0,stringasetsinner
syscall
li $v0,1
move $a0,$t3
syscall
li $v0,4
la $a0,stringaoutput2
syscall
li $v0,1
move $a0,$t4
syscall
li $t3,0                             #resetto valori vincite giochi sinner
li $t4,0                             #resetto valori vincite giochi alcaraz           
beq $t0,3,fine                       #se numero set massimo raggiunto salto a fine
j ciclogioco                         #altrimenti salto a ciclogioco per un nuovo set


controlloset2:  
add $t5,$t3,$t4                      #faccio somma risultati giochi sinner e alcaraz e metto in $t5
beq $t3,$t4,tiebreak                 #se i valori in $t3 e $t4 sono uguali (quindi per forza entrambi 6 salto a tiebreak)
ble $t5,10,stampaalcaraz             #se la somma dei valori è minore o uguale a 10 stampo vincita alcaraz (per forza tra 6-0 e 6-4)
bge $t5,12,stampaalcaraz             #se la somma dei valori è maggiore o uguale a 12 stampo vincita alcaraz (per forza tra 7-5 0 7-6)
j ciclogioco                         #altrimenti ciclo gioco (nel caso 6-5)

stampaalcaraz:
addi $t8,$t8,1                       #aggiungo 1 al contatore vincite set alcaraz
addi $t0,$t0,1                       #aggiungo 1 al contatore set effettuati
li $v0,4                             #stampo a schermo risultato n-esimo set
la $a0,stringaoutput
syscall
li $v0,1
move $a0,$t0
syscall
li $v0,4
la $a0,stringasetalcaraz
syscall
li $v0,1
move $a0,$t4
syscall
li $v0,4
la $a0,stringaoutput2
syscall
li $v0,1
move $a0,$t3
syscall
li $t3,0                             #resetto valori vincite giochi sinner
li $t4,0                             #resetto valori vincite giochi alcaraz           
beq $t0,3,fine                       #se numero set massimo raggiunto salto a fine
j ciclogioco                         #altrimenti salto a ciclogioco per un nuovo set

tiebreak:
li $v0,42                            #genero numero casuale gioco SINNER e lo metto in $t1
syscall
move $t1,$a0
li $v0,42                            #genero numero casuale gioco ALCARAZ e lo metto in $t2
syscall
move $t2,$a0 
bge $t1,$t2,vincesinner              #se $t1 maggiore o uguale di $t2 vincesinner
j vincealcaraz                       #altrimenti vince alcaraz
      
                                            
fine:
bgt $t7,$t8,chiusura                 #se set vinti sinner maggiori set vinti alcaraz salto a chiusura con stampa a schermo vincita sinner
chiusura1:                           #altrimenti stampo a schermo vincita alcaraz
li $v0,4
la $a0,vincitafinalealcaraz
syscall
li $v0,10                            #termino programma
syscall    
chiusura:                            #stampo a schermo vincita sinner
li $v0,4  
la $a0,vincitafinalesinner
syscall
li $v0,10                            #termino programma
syscall           
