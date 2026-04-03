# L'esercizio chiedeva di scrivere un programma in linguaggio assemnblativo MIPS-MARS che permette di simulare un attacco del Risiko. 
# L'utente imposta il numero di armate del colore blu (ATK) e il numero di armate del colore giallo (DEF). 
# Il programma genere 3 numeri casuali per l'attacco e 3 numeri casuali per la difesa (simulando il lancio di dadi a sei facce).
# Il programma poi con una funzione ordina i 3 numeri dell'attacco e con la stessa funzione ordina i 3 numeri della difesa. 
# Poi con una ulteriore funzione valuta i carri armarti persi dalla difesa e quelli persi dall'attacco li sottrae alle truppe correnti e si prosegue. 
# Il gioco termina quando la difesa arriva a 0 (Vittoria Attacco) o quando l'attacco ha solo 3 carri armati (Vittoria Difesa).
# N.B. il programma effettuerá il lancio di 3 dadi indipendentemente dal numero di carri rimasti all'attaccante o al difensore se ancora in partita
# N.B. il programma é stato scritto in modo da non utilizzare lo stack

.globl main

.data

carriblu: .asciiz "Insersca il numero di carri blu in attacco:"
carrigialli: .asciiz "Inserisca il numero di carri gialli in difesa:"
vinceblu: .asciiz "Il vincitore della battaglia é il giocatore blu in attacco"
vincegiallo: .asciiz "Il vincitore della battaglia é il giocatore giallo in difesa"
acapo: .asciiz "\n"
vettoreattacco: .word 1:3
vettoredifesa: .word 1:3

.text

main:
 
li $v0,4                                 #Inserisco numero di carri blu e lo salvo nel registro $t0 (attacco)
la $a0,carriblu
syscall
li $v0,5
syscall
move $t0,$v0
li $v0,4                                 #spazio a capo
la $a0,acapo
syscall
li $v0,4
la $a0,carrigialli                       #Inserisco numero di carri gialli e lo salvo nel registro $t1 (difesa)
syscall
li $v0,5
syscall
move $t1,$v0

lanciodadi:                              #Genero 3 numeri casuali compresi tra 1 e 6 che simulano il lancio di tre dadi per l'attacco e li metto in vettoreattacco ordinati
li $t3,6                            
move $a1,$t3
lancioprimodado:
li $v0,42                                
syscall
beqz $a0,lancioprimodado
sw $a0,vettoreattacco
lanciosecondodado:                     
li $v0,42                                
syscall
beqz $a0,lanciosecondodado
sw $a0,vettoreattacco+4
lancioterzodado:
li $v0,42                                
syscall
beqz $a0,lancioterzodado
sw $a0,vettoreattacco+8                 
move $a1,$t3
lancioquartodado:                        #Genero 3 numeri casuali compresi tra 1 e 6 che simulano il lancio di tre dadi per la difesa e li metto in vettoredifesa ordinati
li $v0,42
beqz $a0,lancioquartodado
syscall
sw $a0,vettoredifesa
lancioquintodado:
li $v0,42
syscall
beqz $a0,lancioquintodado
sw $a0,vettoredifesa+4
lanciosestodado:
li $v0,42
syscall
beqz $a0,lanciosestodado
sw $a0,vettoredifesa+8

                                         
li $t5,3                                 #Effettuo tre battaglie sulla base dei dadi lanciati e tolgo un carro per ogni battaglia persa
li $t7,0                                 #(se l'attacco arriva a tre o la difesa arriva a zero termino gioco, altrimenti torno al lancio dei dadi per effettuare altre tre battaglie)
battaglia:
lw $t3,vettoreattacco($t7)
lw $t4,vettoredifesa($t7)
sub $t6,$t3,$t4
bltz $t6,vincedifesa
bgtz $t6,vinceattacco
pari:
sub $t5,$t5,1
beqz $t5,lanciodadi
add $t7,$t7,4
j battaglia
vinceattacco:
sub $t1,$t1,1
sub $t5,$t5,1
blez $t1,finebattaglia1
beqz $t5,lanciodadi
add $t7,$t7,4
j battaglia
vincedifesa:
sub $t0,$t0,1
sub $t5,$t5,1
ble $t0,3,finebattaglia2
beqz $t5,lanciodadi
add $t7,$t7,4
j battaglia

finebattaglia1:                        #termino il gioco e annuncio come vincitore attaccante stampando il risultato a schermo
li $v0,4                               #spazio a capo
la $a0,acapo
syscall
li $v0,4
la $a0,vinceblu
syscall
j fine

finebattaglia2:                        #termino il gioco e annuncio come vincitore difensore stampando il risultato a schermo
li $v0,4                               #spazio a capo
la $a0,acapo
syscall
li $v0,4
la $a0,vincegiallo
syscall

fine:
li $v0,10
syscall
