#Scrivere un programma in linguaggio assemblativo MIPS-MARS che calcola la seguente funzione ricorsiva utilizzando lo stack: f(x,y)= 100 se x<0 e y<=0
#                                                                                                                            f(x,y)= f(x-4,y-x) -xy -|x-y| altrimenti
#I valori x, y sono letti da tastiera (mediante syscall); il risultato è stampato a video (mediante syscall).

.globl main


.data

stringainput: .asciiz "Inserisca da tastiera due interi 'x' e 'y' per permettere al programma di eseguire la funzione:" 
stringaoutput: .asciiz "\n\nIl risultato della funzione è "


.text

main:
li $t2,100                     #inizializzo registro $t2 con risultato caso base
li $t4,0                       #inizializzo registro $t4 utile per calcolo risultato finale
li $t8,0                       #inizializzo contatore cicli
li $v0,4                       #stampo a schermo istruzioni per utente
la $a0,stringainput
syscall
li $v0,5
syscall
move $t0,$v0                   #metto intero x inserito dentro il registro $t0
li $v0,5
syscall
move $t1,$v0                   #metto intero y inserito dentro il registro $t1
subi $sp,$sp,4
jal funzione

chiusura:                      #stampo a schermo risultato caso base oppure risultato finale funzione storato in $t2 e termino programma
li $v0,4
la $a0,stringaoutput
syscall
li $v0,1
move $a0,$t2
syscall
li $v0,10
syscall

#------------------------------------------------------------------------------------

funzione:
bgez $t0,ciclofunzione          #controllo se condizioni caso base verificate torno a main per chiusura altrimenti procedo con ciclofunzione
bgtz $t1,ciclofunzione
jr $ra
ciclofunzione:
sw $t2,0($sp)                   #salvo risultato caso base oppure risultato ciclo storato nel registro $t2 nello stack
subi $sp,$sp,4                  #ricavo spazio per risultato ciclo in stack
mul $t3,$t0,$t1                 #calcolo xy e lo metto in $t3
mul $t3,$t3,-1                  #calcolo -xy e lo metto in $t3
sub $t4,$t0,$t1                 #calcolo x-y e metto risultato in $t4
abs $t4,$t4                     #calcolo |x-y| e metto risultato in $t4
mul $t4,$t4,-1                  #calcolo -|x-y| e metto risultato in $t4
add $t2,$t3,$t4                 #calcolo -xy -|x-y| e metto risultato in $t2
sub $t1,$t1,$t0                 #aggiorno valore y=y-x e metto risultato in $t1
subi $t0,$t0,4                  #aggiorno valore x=x-4 e metto risultato in $t0
addi $t8,$t8,1                  #aggiorno contatore cicli
bgez $t0,ciclofunzione          #controllo se condizioni caso base verificate salto a chiusura altrimenti procedo con ciclofunzione
bgtz $t1,ciclofunzione
calcolorisultato:
addi $sp,$sp,4                  #pulisco 4 celle di memoria da stack
lw $t3,0($sp)                   #carico penultimo risultato ciclo in $t3
add $t2,$t2,$t3                 #sommo ultimo e penultimo risultato ciclo in $t2
subi $t8,$t8,1                  #sottraggo uno a ciclo
bgtz $t8,calcolorisultato       #ciclo nuovamente calcolorisultato fino a che non termino somma tutti risultati trovati durante ciclofunzione presenti nello stack
jr $ra                          #altrimenti torno a main per chiusura
