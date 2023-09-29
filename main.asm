// @warning
// Be warned. This code has already been submitted as of 09/28/2023 at 10:11 PM.
// You will be automatically flagged for plagiarism if you copy it. MOSS is badass.
//
// @author Ryan Huellen <rhuellen@iastate.edu>
// @netid rhuellen
// @course COM S 321
// @professor Sheaffer

main:
    // Saved stored registers
    SUBI SP, SP, #8
    STUR X19, [SP, #0]

    SUBI SP, SP, #8
    STUR X20, [SP, #0]

    // Setup main
    ADD X19, XZR, XZR // &a
    ADDI X20, XZR, #23 // n = 4

    // Load parameters and call fill
    ADD X0, XZR, X19
    ADD X1, XZR, X20
    BL fill

    // Load parameters and call cycle_sort
    ADD X0, XZR, X19
    ADD X1, XZR, X20
    BL cycle_sort

    // Load parameters and call binary search
    ADD X0, XZR, X19
    ADD X1, XZR, XZR
    SUBI X2, X20, #1
    ADDI X3, XZR, #3

    BL binary_search

    PRNT X4

    // Load parameters and call binary search
    ADD X0, XZR, X19
    ADD X1, XZR, XZR
    SUBI X2, X20, #1
    ADDI X3, XZR, #22

    BL binary_search

    PRNT X4

    // Load parameters and call binary search
    ADD X0, XZR, X19
    ADD X1, XZR, XZR
    SUBI X2, X20, #1
    ADDI X3, XZR, #29

    BL binary_search

    PRNT X4

    // Print some new lines to separate the DUMP from HALT.
    PRNL
    PRNL

    // Restore saved registers
    LDUR X19, [SP, #0]
    ADDI SP, SP, #8

    LDUR X20, [SP, #0]
    ADDI SP, SP, #8

    B end

// * Confident *
// @param X0: Address to start of array
// @param X1: Size of array
fill:
    ADD X9, XZR, XZR

    fill_loop:
        ADD X10, XZR, X9
        LSL X10, X10, #3
        ADD X10, X10, X0
        
        SUB X11, X1, X9
        SUBI X11, X11, #1

        STUR X11, [X10, #0]

        ADDI X9, X9, #1

        SUBS XZR, X9, X1
        B.LT fill_loop

    BR LR

// * Confident *
// @param X0: Address to start of array
// @param X1: Size of array
// @param X2: Start index
// @param X3: Value
// @return X4: Found index
find_index:
    ADDI X9, X2, #1
    ADD X10, XZR, X2

    SUBS XZR, X9, X1
    B.LT find_index_loop

    B find_index_end

    find_index_loop_increment:
        ADDI X10, X10, #1
        B find_index_loop_end

    find_index_loop:
        ADD X11, XZR, X9
        LSL X11, X11, #3
        ADD X11, X11, X0
        LDUR X11, [X11, #0]

        SUBS XZR, X11, X3
        B.LT find_index_loop_increment

        find_index_loop_end:
            ADDI X9, X9, #1

            SUBS XZR, X9, X1
            B.LT find_index_loop

    find_index_end:
        ADD X4, XZR, X10
        BR LR

// * Confident *
// @param X0: First address
// @param X1: Second address
swap:
    LDUR X9, [X0, #0]
    LDUR X10, [X1, #0]

    STUR X9, [X1, #0]
    STUR X10, [X0, #0]

    BR LR

// * Confident *
// @param X0: Address to start of array
// @param X1: Start index
// @param X2: Value to progress on
skip_duplicates:
    ADD X9, XZR, X1

    ADD X10, XZR, X9
    LSL X10, X10, #3
    ADD X10, X10, X0
    LDUR X10, [X10, #0]

    SUBS XZR, X2, X10
    B.NE skip_duplicates_end

    ADDI X9, X9, #1

    skip_duplicates_loop:
        ADD X10, XZR, X9
        LSL X10, X10, #3
        ADD X10, X10, X0
        LDUR X10, [X10, #0]

        SUBS XZR, X2, X10
        B.NE skip_duplicates_end

        ADDI X9, X9, #1
        B skip_duplicates_loop

    skip_duplicates_end:
        ADD X3, XZR, X9
        BR LR

// * Confident *
// @param X0: Address to start of array
// @param X1: Size of array
// @param X2: Start index
// @param X3: Initial index
// @param X4: Value to do the ol' switcheroo
complete_cycle:
    SUBI SP, SP, #8
    STUR LR, [SP, #0]

    SUBS XZR, X3, X2
    B.EQ complete_cycle_end

    SUBI SP, SP, #8
    STUR X19, [SP, #0]

    SUBI SP, SP, #8
    STUR X20, [SP, #0]

    SUBI SP, SP, #8
    STUR X21, [SP, #0]

    complete_cycle_loop:
        // find_index (a, n, start, value)
        ADD X19, XZR, X3
        ADD X20, XZR, X4
        
        ADD X3, XZR, X4

        BL find_index

        ADD X9, XZR, X4
        ADD X3, XZR, X19
        ADD X4, XZR, X20

        // skip_duplicates (a, index, value)

        ADD X19, XZR, X1
        ADD X20, XZR, X2
        ADD X21, XZR, X3

        ADD X1, XZR, X9
        ADD X2, XZR, X4

        BL skip_duplicates

        ADD X9, XZR, X3

        ADD X1, XZR, X19
        ADD X2, XZR, X20
        ADD X3, XZR, X21

        // swap
        ADD X19, XZR, X0
        ADD X20, XZR, X1
        ADD X21, XZR, X9

        ADD X10, XZR, X9
        LSL X10, X10, #3
        ADD X10, X10, X0

        ADD X11, XZR, X1 // n
        LSL X11, X11, #3 // n * 8
        ADD X11, X11, X0 // &a + n * 8
        ADDI X11, X11, #16 // &a + n * 8 + 16
        STUR X4, [X11, #0]

        ADD X0, XZR, X10
        ADD X1, XZR, X11

        BL swap

        ADD X0, XZR, X19
        ADD X1, XZR, X20
        ADD X9, XZR, X21

        LDUR X4, [X11, #0]

        SUBS XZR, X9, X2
        B.NE complete_cycle_loop

    complete_cycle_end:
        LDUR X21, [SP, #0]
        ADDI SP, SP, #8

        LDUR X20, [SP, #0]
        ADDI SP, SP, #8

        LDUR X19, [SP, #0]
        ADDI SP, SP, #8

        LDUR LR, [SP, #0]
        ADDI SP, SP, #8

        BR LR

// * Confident *
// @param X0: Address to start of array
// @param X1: Size of array
cycle_sort:
    SUBI SP, SP, #8
    STUR LR, [SP, #0]

    SUBI SP, SP, #8
    STUR X19, [SP, #0]

    SUBI SP, SP, #8
    STUR X20, [SP, #0]

    SUBI SP, SP, #8
    STUR X21, [SP, #0]

    SUBI SP, SP, #8
    STUR X22, [SP, #0]
    
    SUBI SP, SP, #8
    STUR X23, [SP, #0]

    SUBI SP, SP, #8
    STUR X24, [SP, #0]

    SUBI SP, SP, #8
    STUR X25, [SP, #0]

    ADD X9, XZR, XZR // cstart

    B cycle_sort_loop

    cycle_sort_increment:
        ADDI X9, X9, #1

        SUBI X15, X1, #1
        SUBS XZR, X9, X15
        B.EQ cycle_sort_end

    cycle_sort_loop:
        ADD X10, XZR, X9
        LSL X10, X10, #3
        ADD X10, X10, X0

        LDUR X11, [X10, #0]

        // find_index (a, n, cstart, val)
        ADD X19, XZR, X2
        ADD X20, XZR, X3
        ADD X21, XZR, X4
        ADD X22, XZR, X9
        ADD X23, XZR, X10
        ADD X24, XZR, X11

        ADD X2, XZR, X9
        ADD X3, XZR, X11

        BL find_index

        ADD X12, XZR, X4

        ADD X2, XZR, X19
        ADD X3, XZR, X20
        ADD X4, XZR, X21
        ADD X9, XZR, X22
        ADD X10, XZR, X23
        ADD X11, XZR, X24

        // idx == cstart

        SUBS XZR, X12, X9
        B.EQ cycle_sort_increment

        // skip_duplicates (a, idx, val)

        ADD X19, XZR, X1
        ADD X20, XZR, X2
        ADD X21, XZR, X3
        ADD X22, XZR, X9
        ADD X23, XZR, X10
        ADD X24, XZR, X11

        ADD X1, XZR, X12
        ADD X2, XZR, X11

        BL skip_duplicates

        ADD X12, XZR, X3

        ADD X1, XZR, X19
        ADD X2, XZR, X20
        ADD X3, XZR, X21
        ADD X9, XZR, X22
        ADD X10, XZR, X23
        ADD X11, XZR, X24

        // swap

        ADD X19, XZR, X0
        ADD X20, XZR, X1
        ADD X21, XZR, X9
        ADD X22, XZR, X10

        ADD X13, XZR, X1 // n
        LSL X13, X13, #3 // n * 8
        ADD X13, X13, X0 // &a + n * 8
        ADDI X13, X13, #16 // &a + n * 8 + 16
        STUR X11, [X13, #0]

        ADD X14, XZR, X12
        LSL X14, X14, #3
        ADD X14, X14, X0

        ADD X0, XZR, X13
        ADD X1, XZR, X14

        BL swap

        ADD X0, XZR, X19
        ADD X1, XZR, X20
        ADD X9, XZR, X21
        ADD X10, XZR, X22

        LDUR X11, [X13, #0]

        // complete_cycle (a, n, cstart, idx, val)
        // X9 -> X2
        // X12 -> X3
        // X11 -> X4

        // store: 2,3,4,9
        ADD X19, XZR, X2
        ADD X20, XZR, X3
        ADD X21, XZR, X4
        ADD X22, XZR, X9

        ADD X2, XZR, X9
        ADD X3, XZR, X12
        ADD X4, XZR, X11

        BL complete_cycle

        ADD X2, XZR, X19
        ADD X3, XZR, X20
        ADD X4, XZR, X21
        ADD X9, XZR, X22

        SUBI X15, X1, #1
        SUBS XZR, X9, X15
        B.LT cycle_sort_increment

    cycle_sort_end:
        LDUR X25, [SP, #0]
        ADDI SP, SP, #8

        LDUR X24, [SP, #0]
        ADDI SP, SP, #8

        LDUR X23, [SP, #0]
        ADDI SP, SP, #8

        LDUR X22, [SP, #0]
        ADDI SP, SP, #8
    
        LDUR X21, [SP, #0]
        ADDI SP, SP, #8

        LDUR X20, [SP, #0]
        ADDI SP, SP, #8

        LDUR X19, [SP, #0]
        ADDI SP, SP, #8

        LDUR LR, [SP, #0]
        ADDI SP, SP, #8
        
        BR LR 

// @param X0: Address of start of array
// @param X1: Start index
// @param X2: End index
// @param X3: Value
// @return X4: The index of the value, or -1 if not found
binary_search:
    SUBI SP, SP, #8
    STUR LR, [SP, #0]

    SUBS XZR, X2, X1
    B.LT not_found

    // index = (start + end) / 2;
    ADD X9, X1, X2
    LSR X9, X9, #1

    ADD X10, XZR, X9
    LSL X10, X10, #3
    ADD X10, X10, X0
    LDUR X10, [X10, #0]

    SUBS XZR, X10, X3
    B.EQ found
    
    B.GT binary_search_left

    binary_search_right:
        ADDI X1, X9, #1
        BL binary_search
        B binary_search_end

    binary_search_left:
        SUBI X2, X9, #1
        BL binary_search
        B binary_search_end

    found:
        ADD X4, XZR, X9
        B binary_search_end
    
    not_found:
        ADDI X4, XZR, #-1
        B binary_search_end

    binary_search_end:
        LDUR LR, [SP, #0]
        ADDI SP, SP, #8

        BR LR
end:
    HALT