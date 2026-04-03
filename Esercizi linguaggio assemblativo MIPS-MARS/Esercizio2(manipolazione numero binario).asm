#Scrivere un programma in linguaggio assemblativo MIPS-MARS che acquisito un intero positivo (da 0 a 255) inserito da tastiera, scrivere il valore binario al contrario.
#Esempio
#INPUT:  5 (cioè 00000101)
#OUTPUT: 160 (10100000)
#INPUT:  105 (cioè 01101001)
#OUTPUT: 150 (10010110)

.globl main

.data

stringa1: .asciiz "Per favore inserisca un numero intero positivo compreso tra 0 e 255"
stringa2: .asciiz "Il numero da lei inserito è:"
stringa3: .asciiz "O no! Sembrerebbe che il numero da lei inserito non è corretto. Inserisca nuovamente il numero:"
stringa4: .asciiz "L'inverso decimale del numero da lei inserito è:"
acapo: .asciiz "\n"
spazio: .asciiz "\t"
valore: .byte 0
.text

main:

primotentativo:              #chiedo tramite stringa di testo di inserire un intero da tastiera con relativi limiti
li $t1,255
li $t5,127
li $v0,4
la $a0,stringa1
syscall

tentativo:                   #pop up immissione intero da tastiera
li $v0,5
syscall
move $t0,$v0                 #metto in $t0 l'intero inserito da tastiera e lo stampo a schermo se compreso nel range previsto altrimenti chiedo di riprovare saltando a istruzioni funzione riprova
ble $t0,$zero,riprova
bgt $t0,$t1,riprova
li $v0,4
la $a0,acapo
syscall
li $v0,4
la $a0,stringa2
syscall
li $v0,4
la $a0,spazio
syscall                      #stampo a schermo intero inserito se compreso nel range di riferimento
li $v0,1
move $a0,$t0
syscall
li $v0,4
la $a0,acapo
syscall
bgt $t0,$t5,invertobinario2  #se numero maggiore di 127 devo ciclare 9 volte quindi eseguo invertobinario2 altrimenti eseguo invertobinario

invertobinario:              #inverto bit e storo valore decimale con binario invertito in $t3
li $t3,8                     #numero di cicli da effettuare per invertire 8 bit (fino a 127)
sll $t2,$t0,31               #shifto di 31 posizioni bit meno significativo riempendo il resto con soli zeri
rol $t2,$t2,1                #ruoto bit più significativo a bit meno significativo
subi $t3,$t3,1               #sottraggo primo ciclo effettuato a conteggio
ciclo:       
srl $t0,$t0,1                #tolgo bit meno significativo (cifra già invertita) e sostituisco a numero iniziale
sll $t4,$t0,31               #shifto di 31 posizioni bit meno significativo riempendo il resto con soli zeri
or $t2,$t4,$t2               #scrivo nuova cifra nel bit più significativo del numero finale mantenendo bit già ruotati nei bit meno significativi
rol $t2,$t2,1                #ruoto nuova cifra nel bit meno significativo del numero finale mantenendo bit già ruotati nei bit meno significativi
subi $t3,$t3,1               #sottraggo ciclo effettuato a conteggio
beqz $t3,fine                #effettuati 8 cicli salto a fine con decimale corrispondente a binario in input scritto al contrario salvato in $t2
j ciclo

invertobinario2:             #inverto bit e storo valore decimale con binario invertito in $t3
li $t3,9                     #numero di cicli da effettuare per invertire 9 bit (fino a max valore inseribile)
sll $t2,$t0,31               #shifto di 31 posizioni bit meno significativo riempendo il resto con soli zeri
rol $t2,$t2,1                #ruoto bit più significativo a bit meno significativo
subi $t3,$t3,1               #sottraggo primo ciclo effettuato a conteggio
ciclo1:       
srl $t0,$t0,1                #tolgo bit meno significativo (cifra già invertita) e sostituisco a numero iniziale
sll $t4,$t0,31               #shifto di 31 posizioni bit meno significativo riempendo il resto con soli zeri
or $t2,$t4,$t2               #scrivo nuova cifra nel bit più significativo del numero finale mantenendo bit già ruotati nei bit meno significativi
rol $t2,$t2,1                #ruoto nuova cifra nel bit meno significativo del numero finale mantenendo bit già ruotati nei bit meno significativi
subi $t3,$t3,1               #sottraggo ciclo effettuato a conteggio
beqz $t3,fine                #effettuati 9 cicli salto a fine con decimale corrispondente a binario in input scritto al contrario salvato in $t2
j ciclo1


riprova:                     #valutato input non corretto stampo a schermo istruzioni per riprovare a inserire input corretto
li $v0,4
la $a0,acapo
syscall
li $v0,4
la $a0,stringa3
syscall
j tentativo



fine:                        #stampo a schermo il corrispettivo decimale del codice binario ricevuto in input scritto al contrario che trovo memorizzato in $t2
li $v0,4
la $a0,acapo
syscall
li $v0,4
la $a0,stringa4
syscall
li $v0,4
la $a0,spazio
syscall
li $v0,1
move $a0,$t2
syscall
li $v0,10
syscall





