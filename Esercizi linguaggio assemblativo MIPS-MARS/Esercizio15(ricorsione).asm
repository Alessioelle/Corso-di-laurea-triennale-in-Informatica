#Scrivere un programma in assembly MIPS che calcola la seguente funzione ricorsiva utilizzando lo stack: f(x,y)= 10 se x <=0
#                                                                                                        f(x,y)= f(x-1,y-3)+2y se x pari
#                                                                                                        f(x,y)= f(x-1,y-5)-xy se x dispari
#I valori x, y sono letti da tastiera (mediante syscall); il risultato è stampato a video (mediante syscall).

.globl main

.data

stringainput: .asciiz "\nInserisca da tastiera due valori interi x e y per permettere al programma di svolgere la funzione:"
stringaoutput: .asciiz "\n\nSulla base degli input da lei inseriti il risultato della funzione svolta dal programma è di: "

.text

main:
li $v1,10                                  #metto dentro il registro $v1 il risultato del caso base
li $v0,4                                   #stampo a schermo istruzioni per utente
la $a0,stringainput
syscall
li $v0,5                                   #pop up inserimento intero x da tastiera e lo metto in $a0 pronto per eventuale trasferimento in funzione
syscall
move $a0,$v0
li $v0,5                                   #pop up inserimento intero y da tastiera e lo metto in $a1 pronto per eventuale trasfermineto in funzione
syscall
move $a1,$v0
ble $a0,$zero chiusura
li $v0,0
jal funzione
ciclofine:
lw $t0,($sp)                               #carico ultimo valore stack in $t0
add $v1,$v1,$t0                            #sommo ultimo risultato in risultato precedente stack e metto risultato finale in $v1
subi $v0,$v0,1                             #tolgo 1 a contatore cicli funzione
addi $sp,$sp,4                             #resetto 4 byte contatore
beqz, $v0,chiusura                         #salto a fine quando contatore cicli funzione uguale a zero
j ciclofine

chiusura:
li $v0,4                                   #stampo a schermo stringa finale
la $a0,stringaoutput
syscall
li $v0,1                                   #stampo a schermo risultato finale funzione contenuto dentro il registro 4v1
move $a0,$v1
syscall
li $v0,10
syscall

#--------------------------------------------------------------------------------------------------------------------------------------------------------

funzione:
addi $v0,$v0,1                             #aggiungo 1 a contatore cicli funzione
subi $sp,$sp,4                             #ricavo 4 byte in stack
sw $v1,($sp)                               #salvo valore caso base in stack
xpari:
rem $t0,$a0,2
bnez $t0,xdispari
mul $v1,$a1,2                              #+2y e salvo risultato in $v1
subi $a0,$a0,1                             #sottraggo 1 a x
subi $a1,$a1,3                             #sottraggo 3 a y
bgtz $a0,funzione                          #controllo se non sono arrivato a caso base salto a funzione
jr $ra                                     #altrimenti torno a main

xdispari:
mul $t0,$a0,$a1                            #xy
mul $v1,$t0,-1                             #-xy e salvo risultato in $v1
subi $a0,$a0,1                             #sottraggo 1 a x
subi $a1,$a1,5                             #sottraggo 5 a y
bgtz $a0,funzione                          #controllo se non sono arrivato a caso base salto a funzione
jr $ra                                     #altrimenti torno a main





