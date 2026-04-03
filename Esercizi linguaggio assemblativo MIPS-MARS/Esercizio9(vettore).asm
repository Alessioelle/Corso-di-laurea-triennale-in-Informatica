#Realizzare un programma in linguaggio assemblativo MIPS-MARS che definiti in memoria un vettore vett1 di 10 elementi positivi halfword ed un vettore vett2 di 10 elementi positivi word stabilisca 
#il numero di elementi che alla stessa posizione hanno dei quadrati perfetti. VINCOLO: NON BISOGNA USARE IL COPROCESSORE MATEMATICO!

.globl main

.data

vettore1: .half 9,55,144,33,44,10,5,90,777,100
lunghezzavettore1: .word 10
vettore2: .word 81,99999,121,676,343,22,550,6,10,64
lunghezzavettore2: .word 10
stringaoutput: .asciiz "\nIl numero di elementi che, posti nella stessa posizione all'interno dei due vettori in memoria, risultano essere quadrati perfetti è di  "

.text

main:
li $t0,2                        #inizializzo offset elementi vettore half in memoria
li $t1,4                        #inizializzo offset elementi vettore word in memoria
li $t2,-1                       #inizializzo indice elementi vettori
lw $t7,lunghezzavettore1        #inizializzo limite ciclo
li $s1,0                        #inizializzo registro per risultato finale
ciclocontrollo:
addi $t2,$t2,1                  #aggiorno contatore ciclocontrollo   
beq $t2,$t7,chiusura            #se contatore ciclocontrollo uguale a lunghezza vettori esco da ciclocontrollo e vado a chiusura
li $t6,0                        #inizializzo valore per controllo quadrato perfetto senza coprocessore
mul $t3,$t2,$t0                 #calcolo offset vettore half moltiplicando indice elemento di interesse vettore half per la dimensione degli elementi vettore half e metto in $t3
lh $t4,vettore1($t3)            #prelevo elemento vettore half in memoria di interesse e lo metto nel registro $t4
jal controlloquadratoperfetto1
li $t6,0                        #inizializzo valore per controllo quadrato perfetto senza coprocessore
mul $t3,$t2,$t1                 #calcolo offset vettore half moltiplicando indice elemento di interesse vettore word per la dimensione degli elementi vettore word e metto in $t3
lh $t5,vettore2($t3)            #prelevo elemento vettore half in memoria di interesse e lo metto nel registro $t5
controlloquadratoperfetto2:
mul $t8,$t6,$t6
addi $t6,$t6,1
bgt $t8,$t5,ciclocontrollo
bne $t8,$t5,controlloquadratoperfetto2
addi $s1,$s1,1
j ciclocontrollo

chiusura:                       #stampo risultato funzione a schermo storato in $s1 e termino esecuzione programma
li $v0,4
la $a0,stringaoutput
syscall
li $v0,1
move $a0,$s1
syscall
li $v0,10
syscall

#----------------------------------------------------------------------------------------

controlloquadratoperfetto1:
mul $t8,$t6,$t6
addi $t6,$t6,1
bgt $t8,$t4,ciclocontrollo
bne $t8,$t4,controlloquadratoperfetto1
jr $ra
