#Realizzare un programma in linguaggio assemblativo MIPS-MARS che simula il gioco dell'oca tra il giocatore Blu e il giocatore Rosso. A turno un giocatore lancia un dado e avanza di tante caselle 
#quanto è il valore del dado. Se il giocatore, però, arriva ad una casella con valore multiplo di 17 torna a zero. La gara termina quando uno dei due giocatori raggiunge o eccede la casella 31.
#II programma stampa a video i due giocatori con il relativo punteggio.

.globl main

.data
stringainput: .asciiz "Benvenuti al gioco dell'oca! Chi vincerà tra il giocatore blu e quello rosso? Scopriamolo insieme....pronti? Via!"
stringaoutput1: .asciiz "\n\nIl vincitore della partita è il giocatore ROSSO!"
stringaoutput2: .asciiz "\n\nIl vincitore della partita è il giocatore BLU!"


.text

main:
li $v0,4
la $a0,stringainput
syscall
li $t0,17                      #inizializzo valore ritorno a casella zero
li $a1,7                       #inizializzo valore massimo generatore casuale numeri (6)
li $t6,0                       #inizializzo registro punteggio giocatore rosso
li $t7,0                       #inizializzo registro punteggio giocatore blu
li $t8,31                      #inizializzo valore vincita

lanciodado1:                   #lancio dado giocatore rosso
li $v0,42                      #genero numero casuale tra 0 e 6
syscall
beqz $a0,lanciodado1           #se numero generato è uguale a zero ciclo di nuovo (dado tradizionale non ha mai una faccia con valore zero0
move $t1,$a0                   #metto valore primo dado lanciato nel registro $t1         
add $t6,$t6,$t1                #metto punteggio totale raggiunto da giocatore rosso in $t6
rem $t3,$t6,$t0                #metto resto divisione tra punteggio raggiunto giocatore rosso e numero 17 in $t3 per controllo se multiplo
beqz $t3,tornazero1
bge $t6,$t8,chiusura1          #se giocatore rosso ha raggiunto o superato il valore di 31 con un non multiplo di 17 chiudo programma con stampa a schermo vincita giocatore rosso

lanciodado2:                   #lancio dado giocatore blu
li $v0,42                      #genero numero casuale tra 0 e 6
syscall
beqz $a0,lanciodado2           #se numero generato è uguale a zero ciclo di nuovo (dado tradizionale non ha mai una faccia con valore zero0
move $t2,$a0                   #metto valore secondo dado lanciato nel registro $t2
add $t7,$t7,$t2                #metto punteggio totale raggiunto da giocatore blu in $t7
rem $t3,$t7,$t0                #metto resto divisione tra punteggio raggiunto giocatore blu e numero 17 in $t3 per controllo se multiplo
beqz $t3,tornazero2      
bge $t7,$t8,chiusura2          #se giocatore blu ha raggiunto o superato il valore di 31 con un non multiplo di 17 chiudo programma con stampa a schermo vincita giocatore blu
j lanciodado1

#----------------------------------------------------------------------------------------------------------------------

chiusura1:                     #stampo a schermo vincita giocatore rosso e chiudo programma
li $v0,4
la $a0,stringaoutput1
syscall
li $v0,10
syscall

chiusura2:                     #stampo a schermo vincita giocatore blu e chiudo programma
li $v0,4
la $a0,stringaoutput2
syscall
li $v0,10
syscall

#----------------------------------------------------------------------------------------------------------------------

tornazero1:                    #azzero punteggio raggiunto da giocatore rosso e torno a funzione principale
mul $t6,$t6,$zero
j lanciodado2

tornazero2:                    #azzero punteggio raggiunto da giocatore rosso e torno a funzione principale
mul $t7,$t7,$zero
j lanciodado1
