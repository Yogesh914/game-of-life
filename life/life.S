.data
test: .asciz "%d \n"


.text

.global life

// @author Yogesh Prabhu
// life iteration calculator
// x0 - int *cells
// w1 - int width in words
// w2 - int height in rows
//
life: 
  stp x29, x30, [sp, #-16]!   // Push fp and lr onto the stack
  stp x19, x20, [sp, #-16]!   // Push x19 and x20 onto the stack 
  stp x21, x22, [sp, #-16]!   // Push x21 and x22 onto the stack
  stp x23, x24, [sp, #-16]!   // Push x23 and x24 onto the stack
  stp x25, x26, [sp, #-16]!
  
  mul w3, w1, w2  // width * height
  totalbits .req w19 
  mov w26, w3
  lsl totalbits, w3, #5  // totalbits <- height*width*32
  

  lsl w23, w1, #5  // w23 <- width*32
  
  cells .req x22
  mov cells, x0       //save cells

  mov w0, w26
  mov w1, #4
  bl calloc

  
  cells2 .req x20    
  mov cells2, x0       //save cells2
  mov x25, x0

  i .req w21                  // Use w21 for the loop counter
  mov i, #0

main_loop:
  cmp i, totalbits
  bge end_loop        // i < total_bits
  
  mov w24, #0          // set sum to 0

  //left neighbor

  mov x0, cells
  mov w1, totalbits
  sub w2, i, #1       // i - 1
  bl get_bit

  add w24, w24, w0      //add to sum
  
  //right neighbor
  
  mov x0, cells
  mov w1, totalbits
  add w2, i, #1       // i + 1
  bl get_bit
  
  add w24, w24, w0

  //above neighbor

  mov x0, cells
  mov w1, totalbits
  sub w2, i, w23      // i - width*32
  bl get_bit
  
  add w24, w24, w0

  
  //below neighbor

  mov x0, cells
  mov w1, totalbits
  add w2, i, w23      // i + width*32
  bl get_bit
  
  add w24, w24, w0


  //UpperLeft neighbor

  mov x0, cells
  mov w1, totalbits
  sub w2, i, w23
  sub w2, w2, #1      // i - width*32 - 1
  bl get_bit
  
  add w24, w24, w0
  
  
  //UpperRight neighbor

  mov x0, cells
  mov w1, totalbits
  sub w2, i, w23
  add w2, w2, #1      // i - width*32 + 1
  bl get_bit
  
  add w24, w24, w0
  
  
  //LowerLeft neighbor

  mov x0, cells
  mov w1, totalbits
  add w2, i, w23
  sub w2, w2, #1      // i + width*32 - 1
  bl get_bit
  
  add w24, w24, w0

  //LowerRight neighbor

  mov x0, cells
  mov w1, totalbits
  add w2, i, w23
  add w2, w2, #1      // i + width*32 + 1
  bl get_bit
  
  add w24, w24, w0

  // if sum == 2
  cmp w24, #2
  beq eq2

  // if sum == 3
  cmp w24, #3
  beq eq3

  b less2_or_more3


less2_or_more3:             //SetBit(newCells, totalBits, counter, 0)
  mov x0, cells2
  mov w1, totalbits
  mov w2, i
  mov w3, #0
  bl set_bit
  

  add i, i, #1
  b main_loop

eq2:                //SetBit(newCells, totalBits, counter, GetBit(cells,totalBits, counter))

  mov x0, cells
  mov w1, totalbits
  mov w2, i
  bl get_bit
  mov w3, w0

  mov x0, cells2
  mov w1, totalbits
  mov w2, i
  bl set_bit

  add i, i, #1
  b main_loop

eq3:                        //SetBit(newCells, totalBits, counter, 1)
  mov x0, cells2
  mov w1, totalbits
  mov w2, i
  mov w3, #1
  bl set_bit
  
  add i, i, #1
  b main_loop  

end_loop:
  mov i, #0
  b move_loop

move_loop:                      // cells = newcells
  cmp i, w26
  beq end_move

  ldr w1, [cells2]
  str w1, [cells]
  
  add cells, cells, #4
  add cells2, cells2, #4
  
  add i, i, #1
  b move_loop

end_move:
  mov x0, x25
  bl free
  b life_return 


// TESTING .........
print_loop:
  cmp i, totalbits
  beq end_print

  ldr w1, [cells2]
  ldr x0, =test
  bl printf

  add cells2, cells2, #4
  add i,i,#1
  b print_loop

end_print:
  mov i, #0
  ldr x0, =test
  mov w1, #9
  bl printf

  b print_loop2

print_loop2:
  cmp i, totalbits
  beq end_move
  
  ldr w1, [cells]
  ldr x0, =test
  bl printf 
  add cells, cells, #4
  add i,i,#1
  b print_loop2
  
life_return:
  ldp x25, x26, [sp], #16
  ldp x23, x24, [sp], #16
  ldp x21, x22, [sp], #16     // Restore x21 and x22 from the stack
  ldp x19, x20, [sp], #16     // Restore x19 and x20 from the stack
  ldp x29, x30, [sp], #16     // Restore fp and lr from the stack
  ret
  .unreq totalbits
  .unreq cells
  .unreq cells2
  .unreq i  
