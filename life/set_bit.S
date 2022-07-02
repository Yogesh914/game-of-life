.text
.global set_bit


//
// Get a bit from an array of words.
// x0 - Array of integers
// w1 - Width of the array in bits
// w2 - Desired bit
// w3 - 1 if bit is to be set
//
set_bit:
  stp x29, x30, [sp, #-16]!   // Push fp and lr onto the stack
  stp x19, x20, [sp, #-16]!   // Push x19 and x20 onto the stack 
  stp x21, x22, [sp, #-16]!   // Push x21 and x22 onto the stack
      
      // validating desired
       
  cmp w2, w1
  bge set_bit_done
      
  cmp w2, #0
  blt set_bit_done
      
  mov x22, x0 // save array
      
  lsr w5, w2, #5   // Determine the word, w3 = word
  and w4, w2, #0x1f  // Bit index, w4 = bit index 
      
  lsl w7, w5, #2       // word * 4
  ldr w6, [x0, w7, uxtw] // data[word]
  mov w21, w7 //save word offset
      
  mov w7, #31
  sub w4, w7, w4      // 31 - bit
      
  mov w19, w4 //save bit
  mov w20, w6 //save loaded word
	    
  cmp w3, #0
  beq clear
    
  b set

clear:              //when set bit is 0
  mov w1, #1
  lsl w1, w1, w19
  bic w20, w20, w1
  str w20, [x22, w21, uxtw] 
  b set_bit_done

set:                //when set bit is 1
  mov w1, #1
  lsl w1, w1, w19
  orr w20, w20, w1 
  str w20, [x22, w21, uxtw]
  b set_bit_done
  

set_bit_done:
  ldp x21, x22, [sp], #16     // Restore x21 and x22 from the stack
  ldp x19, x20, [sp], #16     // Restore x19 and x20 from the stack
  ldp x29, x30, [sp], #16     // Restore fp and lr from the stack
  ret   
