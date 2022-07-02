.text
.global get_bit


//
// Get a bit from an array of words.
// x0 - Array of integers
// w1 - Width of the array in bits
// w2 - Desired bit
//
get_bit:
    stp x29, x30, [sp, #-16]!   // Push fp and lr onto the stack
            
    // validating desired
             
    cmp w2, w1
    bge return_zero
                    
    cmp w2, #0
    blt return_zero
                            
                            
    lsr w3, w2, #5   // Determine the word, w3 = word
    and w4, w2, #0x1f  // Bit index, w4 = bit index 
                                    
    lsl w7, w3, #2       // word * 4
    ldr w6, [x0, w7, uxtw] // data[word]
                                            
    mov w7, #31
    sub w4, w7, w4      // 31 - bit
    lsr w6, w6, w4      // Shift bit to lowest bit

    and w0, w6, #1      // And with 1 and return value
    b get_bit_done

return_zero:
    mov w0, #0
    b get_bit_done   
             
get_bit_done:
    ldp x29, x30, [sp], #16     // Restore fp and lr from the stack
    ret  
