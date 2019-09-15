<<<<<<< HEAD
program daniel
	implicit none
	!TYPE QUE EMPACOTA UM VETOR ESPARSO
    type PackedVector
        integer :: nz, NFull
        real, allocatable :: Value(:)
        integer, allocatable :: Vector_Index(:)
    end type PackedVector
    
    !TYPE QUE EMPACOTA UMA MATRIZ NO ESQUEMA COORDENADAS
    type PackedMatrixEntry
        integer :: NNZ
        integer, allocatable :: Row_Index(:), Col_Index(:)
        real, allocatable :: Value(:)
    end type PackedMatrixEntry
    
    !TYPE QUE EMPACOTA UMA MATRIZ COMO COLECAO DE COLUNAS
    type PackedMatrixCol
        integer, allocatable :: Len_Col(:), Col_Start(:), Row_Index(:)
        real, allocatable :: Value(:)
    end type PackedMatrixCol
    
    !TYPE QUE EMPACOTA UMA MATRIZ COMO COLECAO DE LINHAS
    type PackedMatrixRow
        integer, allocatable :: Len_Row(:), Row_Start(:), Col_Index(:)
        real, allocatable :: Value(:)
    end type PackedMatrixRow
    
    contains
    
    subroutine col_permutation(A,j1,j2)! supposed that j1 < j2
        implicit none
        type(col_packed) :: A
=======
module daniel
    use gustavo
    
    contains
    
!================================================================================================
!     PERMUTA DUAS COLUNAS DUMA MATRIZ EMPACOTADA POR COLUNAS, J1 É MENOR DO QUE J2
!================================================================================================
    subroutine col_permutation(A,j1,j2)! supposed that j1 < j2
        implicit none
        type(ColPacked) :: A
>>>>>>> 37fc9daaf4f1b639ffbc730b79ae4b85882793d2
        integer :: j1, j2, i, m, i_aux
        integer, allocatable :: inter(:)
        real, allocatable :: array(:)
        real :: r_aux
<<<<<<< HEAD
        m = max(A%Len_Col(j1),A%Len_Col(j2))
        if(A%Len_Col(j1) /= A%Len_Col(j2)) then
            allocate(inter(m), array(m))
        end if
		if(A%Len_Col(j1) == A%Len_Col(j2)) then
			do i = 1, m
				r_aux = A%Value(i-1+A%Col_Start(j2))
				i_aux = A%Row_Index(i-1+A%Col_Start(j2))
				A%Value(i-1+A%Col_Start(j2)) = A%Value(i-1+A%Col_Start(j1))
				A%Row_Index(i-1+A%Col_Start(j2)) = A%Row_Index(i-1+A%Col_Start(j1))
				A%Value(i-1+A%Col_Start(j1)) = r_aux
				A%Row_Index(i-1+A%Col_Start(j1)) = i_aux
			enddo
		elseif(A%Len_Col(j1) > A%Len_Col(j2)) then
			do i = 1, m
				array(i) = A%Value(i-1+A%Col_Start(j1))
				inter(i) = A%Row_Index(i-1+A%Col_Start(j1))
			enddo
			do i = 1, A%Len_Col(j2)!escrevemos as entradas da coluna j2 no lugar da j1
                A%value(i-1+A%col_start(j1)) = A%value(i-1+A%Col_Start(j2))
=======
        m = max(A%len_col(j1),A%len_col(j2))
        if(A%len_col(j1) /= A%len_col(j2)) then
            allocate(inter(m), array(m))
        end if
		if(A%len_col(j1) == A%len_col(j2)) then
			do i = 1, m
				r_aux = A%value(i-1+A%col_start(j2))
				i_aux = A%row_index(i-1+A%col_start(j2))
				A%value(i-1+A%col_start(j2)) = A%value(i-1+A%col_start(j1))
				A%row_index(i-1+A%col_start(j2)) = A%row_index(i-1+A%col_start(j1))
				A%value(i-1+A%col_start(j1)) = r_aux
				A%row_index(i-1+A%col_start(j1)) = i_aux
			enddo
		elseif(A%len_col(j1) > A%len_col(j2)) then
			do i = 1, m
				array(i) = A%value(i-1+A%col_start(j1))
				inter(i) = A%row_index(i-1+A%col_start(j1))
			enddo
			do i = 1, A%len_col(j2)!escrevemos as entradas da coluna j2 no lugar da j1
                A%value(i-1+A%col_start(j1)) = A%value(i-1+A%col_start(j2))
>>>>>>> 37fc9daaf4f1b639ffbc730b79ae4b85882793d2
                A%row_index(i-1+A%col_start(j1)) = A%row_index(i-1+A%col_start(j2))
			enddo
			if(j2-j1 > 1) then!empurramos à esquerda os elementos entre as colunas j1 e j2
                do i = 1, A%col_start(j2)-A%col_start(j1+1)
                    A%value(i-1+A%col_start(j1)+A%len_col(j2)) = A%value(i-1+A%col_start(j1+1))
                    A%row_index(i-1+A%col_start(j1)+A%len_col(j2)) = A%row_index(i-1+A%col_start(j1+1))
                enddo
            endif
            do i = 1, m!escrevemos as entradas da coluna j1 no lugar da j2
                A%value(i-1+A%col_start(j1)+A%len_col(j2)+A%col_start(j2)-A%col_start(j1+1)) = array(i)
                A%row_index(i-1+A%col_start(j1)+A%len_col(j2)+A%col_start(j2)-A%col_start(j1+1)) = inter(i)
            enddo
		else
			do i = 1, m
				array(i) = A%value(i-1+A%col_start(j2))
				inter(i) = A%row_index(i-1+A%col_start(j2))
			enddo
			if(j2 == size(A%len_col)) then 
                do i = A%len_col(j1), 1, -1
                    A%value(i+size(A%value)-A%len_col(j1)) = A%value(i-1+A%col_start(j1))
                    A%row_index(i+size(A%value)-A%len_col(j1)) = A%row_index(i-1+A%col_start(j1))
                enddo
            else !da para colocar elseif(j2 < m) mas isso é evidente
                do i = A%len_col(j1), 1, -1
                    A%value(i-A%len_col(j1)+A%col_start(j2+1)-1) = A%value(i-1+A%col_start(j1))
                    A%row_index(i-A%len_col(j1)+A%col_start(j2+1)-1) = A%row_index(i-1+A%col_start(j1))
                enddo
			endif
			if(j2-j1 > 1) then!empurramos de novo
                do i = A%col_start(j2)-A%col_start(j1+1), 1, -1
                    A%value(i+A%col_start(j1+1)-1+A%len_col(j2)-A%len_col(j1)) = A%value(i+A%col_start(j1+1)-1)
                    A%row_index(i+A%col_start(j1+1)-1+A%len_col(j2)-A%len_col(j1)) = A%row_index(i+A%col_start(j1+1)-1)
                enddo
			endif
			do i = 1, m
                A%value(i-1+A%col_start(j1)) = array(i)
                A%row_index(i-1+A%col_start(j1)) = inter(i)
			enddo
		endif
		
		i_aux = A%len_col(j2)
		A%len_col(j2) = A%len_col(j1)
		A%len_col(j1) = i_aux
		
		do i = 1, size(A%len_col)
            A%col_start(i+1) = A%len_col(i)+A%col_start(i)
		enddo
    end subroutine col_permutation
<<<<<<< HEAD
    
=======
!================================================================================================
!     PERMUTA DUAS LINHAS DUMA MATRIZ EMPACOTADA POR COLUNAS, I1 É MENOR DO QUE I2
!================================================================================================    
>>>>>>> 37fc9daaf4f1b639ffbc730b79ae4b85882793d2
    subroutine row_permutation(A, i1, i2)
        implicit none
        type(col_packed) :: A
        integer :: i1, i2, i
        do i = 1, size(A%value)
            if(A%row_index(i) == i1) then
                A%row_index(i) = i2
            elseif(A%row_index(i) == i2) then
                A%row_index(i) = i1
            endif
        enddo
    end subroutine
<<<<<<< HEAD
end program
=======

end module
>>>>>>> 37fc9daaf4f1b639ffbc730b79ae4b85882793d2
