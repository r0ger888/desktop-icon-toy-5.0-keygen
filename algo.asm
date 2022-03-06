GenKey		PROTO	:DWORD

.data 
Phormat 	db "%d",0
NoName 		db "Insert ur name.",0
Toolong		db "Too long!",0

.data?
NameBuffer 	db 512 dup(?)
SrlBuffer 	db 512 dup(?)
hLen 		dd ?
Srlcounter 	db ?

.code
GenKey proc hWin:DWORD

		invoke GetDlgItemText,hWin,IDC_NAME,offset NameBuffer,sizeof NameBuffer
		mov hLen, eax

		.if eax == 0
			invoke SetDlgItemText,hWin,IDC_SERIAL,addr NoName
			invoke GetDlgItem,hWin,IDB_COPY
			invoke EnableWindow,eax,FALSE
			ret
		.elseif eax > 24
			invoke SetDlgItemText,hWin,IDC_SERIAL,addr Toolong
			invoke GetDlgItem,hWin,IDB_COPY
			invoke EnableWindow,eax,FALSE
			ret
		.endif

		or eax, eax
		xor edx, edx
		xor edi, edi
		mov ebx, hLen
		mov ecx, 0

part_one:
		lea eax, NameBuffer[ecx]
		mov al, [eax]
		mov Srlcounter[edx], al
		add edx, 2
		inc ecx
		dec ebx
		jnz part_one
		lea eax, Srlcounter
		mov esi, hLen
		xor ecx, ecx
		mov edx, eax

part_two:
		cmp ecx, 9
		jg part_five
		mov ax, [edx]
		cmp ax, 41h
		jb part_five
		cmp ax, 5Ah
		jbe part_three
		and eax, 0FFFFh
		sub eax, 20h
		jmp part_four

part_three:
		and eax, 0FFFFh

part_four:
		add edi, eax
		inc ecx
		add edx, 2
		cmp ecx, esi
		jl part_two

part_five:
		xor edi, 373F373Fh
		push edi
		invoke wsprintf,offset SrlBuffer,offset Phormat
		invoke SetDlgItemText,hWin,IDC_SERIAL,offset SrlBuffer
		call Clean
		invoke GetDlgItem,hWin,IDB_COPY
		invoke EnableWindow,eax,TRUE
		ret
GenKey endp

Clean proc

	invoke RtlZeroMemory,offset NameBuffer,sizeof NameBuffer
	invoke RtlZeroMemory,offset Srlcounter,sizeof Srlcounter
	invoke RtlZeroMemory,offset SrlBuffer,sizeof SrlBuffer
	Ret
Clean endp


