//
//  main.m
//  BitFieldDemo
//
//  Created by 002 on 2020/3/4.
//  Copyright © 2020 002. All rights reserved.
//

#import <Foundation/Foundation.h>

struct BitFields {
    unsigned int bit1 : 1;
    unsigned int bit2 : 1;
    unsigned int bit3 : 4;
    unsigned int bit4 : 2;
};

union my_isa_t {
    unsigned int bitfields;
    
    unsigned int bit1 : 1;
    unsigned int bit2 : 1;
    unsigned int bit3 : 4;
    unsigned int bit4 : 2;
};


union my_new_isa_t {
    unsigned int bitfields;
    struct {
        unsigned int bit1 : 1;
        unsigned int bit2 : 1;
        unsigned int bit3 : 4;
        unsigned int bit4 : 2;
    };
};

struct isa_t_notBitFields {
    unsigned char nonpointer;  // 1字节
    unsigned char has_assoc; // 1字节
    unsigned char has_cxx_dtor; // 1字节
    unsigned long shiftcls; // 8字节
    unsigned char magic; // 1字节
    unsigned char weakly_referenced; // 1字节
    unsigned char deallocating; // 1字节
    unsigned char has_sidetable_rc; // 1字节
    unsigned int extra_rc; // 4字节
};

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        struct BitFields bitFields = {};
        bitFields.bit1 = 0b0;
        bitFields.bit2 = 0b1;
        bitFields.bit3 = 0b1010;
        bitFields.bit4 = 0b11;
        
        union my_isa_t isa = {};
        isa.bitfields = 0b00000011;
        isa.bit1 = 0b0;
        isa.bit2 = 0b1;
        isa.bit3 = 0b1010;
        isa.bit4 = 0b11;
        
        union my_new_isa_t newIsa = {};
        newIsa.bitfields = 0b00000011;
        newIsa.bit1 = 0b0;
        newIsa.bit2 = 0b1;
        newIsa.bit3 = 0b1010;
        newIsa.bit4 = 0b11;
 
        NSLog(@"sizeof(bitfileds):%lu",sizeof(bitFields));
        NSLog(@"bitFields.bit1:%d",bitFields.bit1);
        NSLog(@"bitFields.bit2:%d",bitFields.bit2);
        NSLog(@"bitFields.bit3:%d",bitFields.bit3);
        NSLog(@"bitFields.bit4:%d",bitFields.bit4);
        
        NSLog(@"sizeof(isa):%lu",sizeof(isa));
        NSLog(@"isa.bit1:%d",isa.bit1);
        NSLog(@"isa.bit2:%d",isa.bit2);
        NSLog(@"isa.bit3:%d",isa.bit3);
        NSLog(@"isa.bit4:%d",isa.bit4);
        NSLog(@"isa.bitfileds:%d",isa.bitfields);
        
        NSLog(@"sizeof(newIsa):%lu",sizeof(newIsa));
        NSLog(@"newIsa.bit1:%d",newIsa.bit1);
        NSLog(@"newIsa.bit2:%d",newIsa.bit2);
        NSLog(@"newIsa.bit3:%d",newIsa.bit3);
        NSLog(@"newIsa.bit4:%d",newIsa.bit4);
        NSLog(@"newIsa.bitfields:%d",newIsa.bitfields);
        
        NSLog(@"0b1111:%d",0b1111);
        
        struct isa_t_notBitFields isaNotBitFields = {};
        NSLog(@"sizeof(isaNotBitFields):%lu",sizeof(isaNotBitFields));
    
    }
    return 0;
}
