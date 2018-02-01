extern puts
extern printf

section .data
filename: db "./input.dat",0
inputlen: dd 2263
fmtstr: db "Key: %d",0xa,0

section .text
global main

; TODO: define functions and helper functions
   
strlen:
    ;Calculez lungimea sirului
    push ebp
    mov ebp, esp
    push ecx    ;Pentru a salva adresa din ecx
    
    mov ecx, 10000
    mov edi, [ebp+8]
    mov al, 0
    repne scasb
    
    sub edi, [ebp+8]
    
    mov eax, edi
    pop ecx
    
    leave
    ret


adresa_next:
    ;Aflu adresa urmatorului string
    push ebp
    mov ebp, esp
    
    push ecx
    mov ecx, 10000
    mov edi, [ebp+8]
    xor al,al
    repnz scasb
    
    mov eax, edi
    pop ecx
    
    leave
    ret
    
    
;Task 1:
xor_strings:
    push ebp
    mov ebp, esp
    
    xor eax, eax
    
    ;Copiez cele doua siruri in esi(cheia) si edi(sirul criptat)
    mov esi, [ebp + 12]
    mov edi, [ebp + 8]
    
loop1:
    ;Cand ajung la sfarsit, ies din bucla
    cmp byte[esi+eax], 0
    je out1
    
    mov dl, byte[esi + eax]
    mov bl, byte[edi + eax]
    
    ;xor pe octeti:
    xor bl, dl
    
    mov byte[edi + eax], bl
    
    ;Trec la urmatorul caracter
    inc eax
    
    jmp loop1
    
out1:
    ;Mut inapoi sirul decriptat:
    mov [ebp + 8], edi
    leave
    ret
    

;Task 2:
rolling_xor:
    push ebp
    mov ebp, esp
    
    mov esi, [ebp + 8]
    xor eax, eax
    
    ;Pentru ca voi folosi "loop", salvez ecx pe stiva
    push ecx
    xor ecx, ecx
    
loop2.out:
    ;Bucla exterioara
    inc eax
    ;Cand ajung la sfarsit, ies din bucla
    cmp byte[esi + eax], 0
    je out2
    
    ;In bucla interioara voi folosi "loop"
    mov ecx, eax
    xor bl, bl
    ;Initializez bl cu valoarea lui esi[0]
    xor bl, byte[esi]
    
loop2.in:
    ;Fac xor cu toate elementele precedente
    mov dl, byte[esi + ecx]
    xor bl, dl
    loop loop2.in
    
    ;Pun octetul modificat inapoi in sir
    mov byte[esi+eax], bl
    jmp loop2.out
    
out2:
    ;Restaurez valoarea lui ecx
    pop ecx
    ;Mut inapoi sirul decriptat:
    mov [ebp+8], esi
    leave
    ret


;Task 3:
litera_cifra:
    ;Aici prelucrez caracterul hex
    push ebp
    mov ebp, esp
    
    mov eax, [ebp + 8]
    ;Compar cu caracterul 'a'-1
    ;Daca e mai mare => e litera
    cmp al, 96
    ja litera
    
    ;Daca  e cifra:
    sub al, 48
    jmp out_s
    
litera:
    ;Daca e litera: 
    sub al, 97
    add al, 10
    
out_s:
    leave
    ret
    
xor_hex_strings:
    push ebp
    mov ebp, esp
    
    mov esi, [ebp + 8]
    mov edi, [ebp + 12]
    
    push ecx
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    xor eax, eax
    
loop3:
    cmp byte[esi + eax * 2], 0
    je out3
    
    ;Iau caractere doua cate doua
    ;Element sir 1:(0x bl cl)
    ;Element sir 2:(0x bl cl)
    mov bl, byte[esi + eax * 2]
    mov cl, byte[esi + eax * 2 + 1]
    
    push eax
    
    ;Prelucrez primul caracter din cele doua
    push ebx
    call litera_cifra
    mov ebx, eax
    add esp, 4
    
    ;Il prelucrez pe cel de-al doilea
    push ecx
    call litera_cifra
    mov ecx, eax
    add esp, 4
    
    ;Caracter = (bl * 16 + cl)
    mov al, 16
    mul bl
    mov bl, al
    
    add bl, cl
    pop eax
    ;Adaug caracterul la sir
    mov byte[esi + eax], bl
    
    ;Al doilea caracter e prelucrat la fel
    mov bl, byte[edi + eax*2]
    mov cl, byte[edi + eax*2 + 1]
    
    push eax
    
    push ebx
    call litera_cifra
    mov ebx, eax
    add esp, 4
    
    push ecx
    call litera_cifra
    mov ecx, eax
    add esp, 4
    
    mov al, 16
    mul bl
    mov bl, al
    add bl, cl
    pop eax
    mov byte[edi + eax], bl

    inc eax
    jmp loop3
    
out3:
    ;Adaug terminator la ambele siruri
    pop ecx
    mov byte[esi + eax], 0
    mov byte[edi + eax], 0
    
    push edi
    push esi
    ;Fac xor pe cele doua siruri
    call xor_strings
    add esp, 8
    ;Copiez rezultatul la adresa initiala
    mov [ebp + 8], edi
    
    leave
    ret
    
    
;Task 4:
index_32:
    ;Functia creeaza tabela si prelucreaza
    ;si calculeaza indexul fiecarui element
    push ebp
    mov ebp, esp
    
    sub esp, 33
    lea ebx, [esp - 33]
    ;Aloc memorie pentru tabela
    
    xor eax, eax
    xor edx, edx
    xor ecx, ecx
    mov dl, 65 ;ASCII A
    mov byte[ebx + eax], dl
    
fill_letters:
    ;Completez toate literele: A-Z
    cmp eax, 25
    je filled_letters
    inc eax
    inc dl
    mov byte[ebx + eax], dl
    jmp fill_letters
    
filled_letters:
    inc eax
    xor edx, edx
    mov dl, 50 ;ASCII 2
    
fill_numbers:
    ;Completez toate cifrele: 2-7
    cmp dl, 56 ;ASCII 8
    je filled_numbers
    mov byte[ebx + eax], dl
    inc eax
    inc dl
    jmp fill_numbers
    
filled_numbers:
    mov byte[ebx + eax], 0
    mov eax, [ebp + 8]
    ;Daca e padding pun 0:
    cmp al, '='
    jne skip
    
    mov eax, 0
    jmp out_index
 
 skip: 
    ;Gasesc indexul elementului in tabel:
    mov ecx, 10000
    mov edi, ebx
    repnz scasb
    
    sub edi, ebx
    dec edi
    
    mov eax, edi

out_index:

    leave
    ret
    
base32decode:
    push ebp
    mov ebp, esp
    
    push ecx
    mov esi, [ebp + 8]
    
    push esi
    call strlen
    pop esi
    
    mov ecx, eax
    dec ecx
    xor ebx, ebx
    xor edx, edx
    xor edi, edi
    
loop4:
    cmp edi, ecx
    je out4
    
    ;Efectuez doua parcurgeri in paralel
    ;Din 5 in 5 (elemente prelucrata)
    ;Din 8 in 8 (elemente de prelucrat)
    xor eax, eax
    ;Iau primul caracter
    mov al, byte[esi + edi]
    push ecx
    push edi
    push edx
    push eax
    ;Calculez indexul pe 5 biti
    call index_32
    add esp, 4
    pop edx
    pop edi
    pop ecx
    ;al = 000aaaaa
    shl al, 3
    mov bl, al
    ;bl = aaaaa000
    xor eax, eax
    ;Iau al doilea caracter
    mov al, byte[esi + edi + 1]
    push ebx
    push ecx
    push edi
    push edx
    push eax
    ;Calculez indexul
    call index_32
    add esp, 4
    pop edx
    pop edi
    pop ecx
    pop ebx
    ;al = 000bbbbb
    push eax
    shr al, 2
    ;al = 00000bbb
    add bl, al
    ;bl = aaaaabbb
    ;Octetul rezultat il adaug la sirul initial
    mov byte[esi + edx], bl
    pop eax
    ;al = 000bbbbb
    mov bl, al
    shl bl, 6
    ;bl = bb000000
    xor eax, eax
    mov al, byte[esi + edi + 2]
    push ebx
    push ecx
    push edi
    push edx
    push eax
    call index_32
    add esp, 4
    pop edx
    pop edi
    pop ecx
    pop ebx
    ;al = 000ccccc
    shl al, 1
    ;al = 00ccccc0
    add bl, al
    ;bl = bbccccc0
    xor eax, eax
    mov al, byte[esi + edi + 3]
    push ebx
    push ecx
    push edi
    push edx
    push eax
    call index_32
    add esp, 4
    pop edx
    pop edi
    pop ecx
    pop ebx
    ;al = 000ddddd
    push eax
    shr al, 4
    add bl, al
    ;bl = bbcccccd
    mov byte[esi + edx + 1], bl
    pop ebx
    ;bl = 000ddddd
    shl bl, 4
    ;bl = dddd0000
    xor eax, eax
    mov al, byte[esi + edi + 4]
    push ebx
    push ecx
    push edi
    push edx
    push eax
    call index_32
    add esp, 4
    pop edx
    pop edi
    pop ecx
    pop ebx
    ;al = 000eeeee
    push eax
    shr al, 1
    ;al = 0000eeee
    add bl, al
    ;bl = ddddeeee
    mov byte[esi + edx + 2], bl
    pop ebx
    ;bl = 000eeeee
    shl bl, 7
    ;bl = e0000000
    xor eax, eax
    mov al, byte[esi + edi + 5]
    push ebx
    push ecx
    push edi
    push edx
    push eax
    call index_32
    add esp, 4
    pop edx
    pop edi
    pop ecx
    pop ebx
    ;al = 000fffff
    shl al, 2
    ;al = 0fffff00
    add bl, al
    ;bl = efffff00
    xor eax, eax
    mov al, byte[esi + edi + 6]
    push ebx
    push ecx
    push edi
    push edx
    push eax
    call index_32
    add esp, 4
    pop edx
    pop edi
    pop ecx
    pop ebx
    ;al = 000ggggg
    push eax
    shr al, 3
    ;al = 000000gg
    add bl, al
    ;bl = efffffgg
    mov byte[esi + edx + 3], bl
    pop ebx
    ;bl = 000ggggg
    shl bl, 5
    ;bl = ggg00000
    xor eax, eax
    mov al, byte[esi + edi + 7]
    push ebx
    push ecx
    push edi
    push edx
    push eax
    call index_32
    add esp, 4
    pop edx
    pop edi
    pop ecx
    pop ebx
    ;al = 000hhhhh
    add bl, al
    ;bl = ggghhhhh
    mov byte[esi + edx + 4], bl
    xor ebx, ebx
    xor eax, eax
    
    add edx, 5
    add edi, 8
    jmp loop4
            
out4: 
    pop ecx
    ;Adaug la sfarsit terminatorul de sir
    mov byte[esi + edx], 0
    ;Mut sirul la adresa initiala
    mov [ebp + 8], esi
    
    leave
    ret
    
    
;Task 5:
bruteforce_singlebyte_xor:
    push ebp
    mov ebp, esp
    
    mov esi, [ebp + 8]  ;string
    mov edi, [ebp + 12] ;cheie
    xor ebx, ebx

    push ecx
    xor ecx, ecx
    
loop5_1:
    cmp byte[esi + ebx], 0
    je check_key
    mov byte[edi + ebx], cl
    inc ebx
    jmp loop5_1
    
check_key:  
    ;Verific cheia obtinuta:
    mov byte[edi + ebx], 0
    xor ebx, ebx
    
    push edi
    push esi
    ;Decriptez sirul cu cheia
    call xor_strings
    pop esi
    pop edi
    xor ebx, ebx

check_loop:
    ;Verific daca gasesc substringul:
    ;"force"
    cmp byte[esi + ebx], 0
    je back
    
    cmp byte[esi + ebx], 'f'
    je _1
    jmp check_rep
    
_1: 
    cmp byte[esi + ebx + 1], 'o'
    je _2
    jmp check_rep
    
_2: cmp byte[esi + ebx + 2], 'r'
    je _3
    jmp check_rep
    
_3: cmp byte[esi + ebx + 3], 'c'
    je _4
    jmp check_rep
    
_4: cmp byte[esi + ebx + 4], 'e'
    je out5
    
check_rep:
    ;Avansez in sir, cautand subirul
    inc ebx
    jmp check_loop 

back:
    ;Daca nu a fost gasit incrementez cheia
    ;Si incerc din nou
    inc cl
    xor ebx, ebx
    
    push edi
    push esi
    ;Decriptez pentru a obtine sirul initial
    call xor_strings
    pop esi
    pop edi
    
    xor ebx, ebx
    
    jmp loop5_1
    
out5:
    pop ecx
    ;Copiez sirul la adresa initiala
    mov [ebp + 8], esi
    
    xor eax, eax
    ;Returnez cheia
    mov al, byte[edi]
    
    leave
    ret
    
    
main:
    push ebp
    mov ebp, esp
    sub esp, 2300
    
    ; fd = open("./input.dat", O_RDONLY);
    mov eax, 5
    mov ebx, filename
    xor ecx, ecx
    xor edx, edx
    int 0x80
    
    ; read(fd, ebp-2300, inputlen);
    mov ebx, eax
    mov eax, 3
    lea ecx, [ebp-2300]
    mov edx, [inputlen]
    int 0x80

    ; close(fd);
    ; all input.dat contents are now in ecx (address on stack)
    ; TASK 1: Simple XOR between two byte streams
    ; Compute addresses on stack for str1(ecx) and str2(eax):
    push ecx
    call adresa_next
    add esp, 4
    ; XOR them byte by byte:
    push eax
    push ecx
    call xor_strings
    add esp, 4 ;Adresa catre primul string
    ; Las eax pe stiva (va fi modificat de puts)
    ; Print the first resulting string
    push ecx
    call puts
    add esp, 4
         
    pop eax ;Restaurez eax
        
    ; TASK 2: Rolling XOR
    ; TODO: compute address on stack for str3
        
    push eax
    call adresa_next
    add esp, 4
    ; TODO: implement and apply rolling_xor function
    ;push addr_str3:
    push eax
    call rolling_xor
    pop eax
    ; Print the second resulting string
    push eax
    call puts
    pop eax

    ; TASK 3: XORing strings represented as hex strings
    ; TODO: compute addresses on stack for strings 4 and 5
    push eax
    call adresa_next
    add esp, 4
       
    mov ebx, eax
    push eax
    call adresa_next
    add esp, 4
    ; TODO: implement and apply xor_hex_strings
    push eax
    push ebx
    call xor_hex_strings
    pop ebx

    ; Print the third string
    push ebx
    call puts
    add esp, 4
    pop eax
	
    ; TASK 4: decoding a base32-encoded string
    ; TODO: compute address on stack for string 6
    push eax
    call adresa_next
    add esp, 4
       
    push eax
    call adresa_next
    add esp, 4
        
    ; TODO: implement and apply base32decode
    push eax
    call base32decode
    pop eax
    
    ; Print the fourth string
    push eax
    call puts
    pop eax
    
    ; TASK 5: Find the single-byte key used in a XOR encoding
    ; TODO: determine address on stack for string 7
    push eax
    call adresa_next
    add esp, 4
    
    push eax
    call adresa_next
    add esp, 4
    
    push eax
    call adresa_next
    add esp, 4
        
    push eax
    call adresa_next
    add esp, 4
    
    push eax
    call adresa_next
    mov ebx, eax
    pop eax
    sub esp, 200    ;memorie alocata pentru cheie
    lea edx, [ebp + 2700]   ;Pointer catre inceputul cheii
    ; TODO: implement and apply bruteforce_singlebyte_xor
    push edx
    push ebx
    call bruteforce_singlebyte_xor
    pop ebx
    pop edx
    add esp, 200

    ; Print the fifth string and the found key value
    push eax ;Va fi modificat de puts, deci ii salvam valoarea in stiva
    push ebx
    call puts
    pop ebx
    
    ;Scot cheia
    pop eax

    push eax
    push fmtstr
    call printf
    add esp, 8

    ; TASK 6: Break substitution cipher
    ; TODO: determine address on stack for string 8
    ; TODO: implement break_substitution
    ;push substitution_table_addr
    ;push addr_str8
    ;call break_substitution
    ;add esp, 8

    ; Print final solution (after some trial and error)
    ;push addr_str8
    ;call puts
    ;add esp, 4

    ; Print substitution table
    ;push substitution_table_addr
    ;call puts
    ;add esp, 4
    
    ; Phew, finally done
    xor eax, eax
    leave
    ret
