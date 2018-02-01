
                        ##############################
                        #           README           #
                        #                            #
                        #  Nume Proiect:Tema2 IOCLA  #
                        #  Creat de: Apostol Teodor  #
                        #        Grupa: 322CC        #
                        #    Deadline: 06.12.2017    #
                        #                            #
                        ##############################



	Pentru efectuarea temei am creat cate o functie principala
pentru rezolvarea fiecarui task, alaturi de functii aditionale.
	Functia strlen o vom folosi numai la task-ul 4.
	Functia adresa_next este functia folosita pentru calculul
adresei sirului urmator. Practic, aceasta parcurge tot sirul curent
de la inceput pana la sfarsit si returneaza adresa primului caracter
de dupa terminatorul de sir, adica primul caracter din sirul urmator.

	
Pentru task-ul 1:

	In functia main am apelat adresa_next pentru a calcula adresa
cheii. si apoi am trimis-o impreuna cu sirul initial catre functia
xor_strings (functia principala pentru rezolvarea taskului).
	Functia xor_string contine un loop: "loop1" in care sunt
parcurse cele doua siruri in paralel, octet cu octet si se face
xor pe fiecare octet.
	La sfarsit se inlocuieste sirul criptat cu sirul prelucrat.

	
Pentru task-ul 2:

	Se calculeaza adresa sirului ce trebuie prelucrat, iar apoi
se apeleaza functia rolling_xor. In aceasta functie am doua bucle.
Una exterioara in care prelucrez octet cu octet si una interioara
in care parcurg fiecare octet anterior, fac xor si apoi fac xor
cu elementul curent din bucla exterioara.
	La sfarsitul functiei salvez sirul prelucrat il locul sirului
criptat.


Pentru task-ul 3:

	Pentru rezolvarea acestui task am doua functii:
O functie principala : xor_hex_strings in care parcurg sirurile
in paralel intr-o bucla. La fiecare iteratie iau doua caractere
de pe aceeasi pozitie din fiecare string si apele functia 
litera_cifra care transforma octetul din caracter cifra in cifra
sau din caracter litera in valoarea corespunzatoare pentru baza
16. ex a -> 10, b -> 11, etc.
	Dupa ce modific cele doua siruri, apelez functia xor_strings
de la task-ul 1 pentru decriptare. In final aduc sirul la adresa
corespunzatoare.


Pentru task-ul 4:

	Aici avem doua functii: index_32 si base32decode.
In prima functie creez tabela base32 intr-un string.
La pozitia 0 am 'A', la pozitia 1 am 'B' etc.
	Functia primeste un caracter ca parametru si
returneaza indexul in tabela (pe 5 biti).

	Functia principala pentru acest task este base32decode.
Aceasta are un loop principal in care se efectueaza doua parcurgeri.
Din 8 in 8 elementele din sirul de input si din 5 in 5 rezultatul.

Logica e urmatoarea:
Iau primul caracter si ii calculez indexul in tabela:
0 0 0 a a a a a

il shiftez la stanga cu 3:
a a a a a 0 0 0

apoi iau al doilea caracter.
0 0 0 b b b b b

iau o copie si o shiftez la dreapta cu 2
0 0 0 0 0 b b b

adun cele doua siruri si calculez rezultatul.

Ca o sinteza la fiecare loop avem asa:

a a a a a b b b
b b c c c c c d
d d d d e e e e
e f f f f f g g
g g g h h h h h

Urmatorul loop:
i i i i i j j j

Si tot asa.


Pentru task-ul 5:

	Voi folosi o singura functie: bruteforce_singlebyte_xor:
In loop-ul loop5_1 iau cheia si o multiplic intr-un string pana ajung
la dimensiunea sirului ce trebuie decriptat.

In check_key decriptez sirul cu cheia calculata.

In check_loop verific daca exista urmatoarele caractere unul dupa
altul: 'f''o''r''c''e', cu alte cuvinte daca exista substringul
"force". Daca nu este gasit execut xor pentru a recripta (a aduce
stringul la forma initiala) si incercam cu urmatoarea cheie.

pe principiul am cheia: 0 0 0 0 0 ...
nu merge incerc cheia:  1 1 1 1 1 ...

	Dupa ce am gasit cheia efectuez xor si aflu sirul decriptat si
returnez cheia.

OBS: Pentru decriptare si recriptare am folosit functia xor_strings
de la primul Task.  
