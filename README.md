# BitFieldDemo


前言：在探究OC底层代码的时候，涉及到了联合体和位域相关知识。比如**objc_objct**里面的**isa_t**就是一个联合体，isa_t里面就有**位域**类型的数据。今天我们就来好好学习一下**位域**。

![目录.png](https://upload-images.jianshu.io/upload_images/2351207-da0378909e767247.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


### 简介
位域，也称位段，在C语言中，位段的声明和结构（struct）类似，但它的成员是一个或多个位的字段，这些不同长度的字段实际储存在一个或多个整型变量中。在声明时，位段成员必须是整形或枚举类型（通常是无符号类型），且在成员名的后面是一个冒号和一个整数，整数规定了成员所占用的位数。
位域不能是静态类型。不能使用`&`对位域做取地址运算，因此不存在位域的指针，编译器通常不支持位域的引用（reference）。

以下程序则展示了一个位段的声明：
```
struct CHAR 
{
    unsigned int ch   : 8;    //8位
    unsigned int font : 6;    //6位
    unsigned int size : 18;   //18位
};
struct CHAR ch1;
```
以下程序展示了一个结构体的声明：
```
struct CHAR2 
{
    unsigned char ch;    //8位
    unsigned char font;  //8位
    unsigned int  size;  //32位
};
struct CHAR2 ch2;
```
第一个声明取自一段文本格式化程序，应用了位段声明。它可以处理256个不同的字符（8位），64种不同字体（6位），以及最多262,144个单位的长度（18位）。这样，在ch1这个字段对象中，一共才占据了32位的空间。而第二个程序利用结构体进行声明，可以看出，处理相同的数据，CHAR2类型占用了48位空间，如果考虑边界对齐并把要求最严格的int类型最先声明进行优化，那么CHAR2类型则要占据64位的空间。


### 实例分析
下面的demo例子输出什么  
```
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
    
    }
    return 0;
}
```

* log打印如下
![log.png](https://upload-images.jianshu.io/upload_images/2351207-38c8dfb2da93b106.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


struct BitFileds 很多人都能理解，但是对union my_new_isa_t以及union my_isa_t 可能存在疑惑，我们一一进行分析：

#### struct BitFileds
```
struct BitFileds {
    unsigned int bit1 : 1;
    unsigned int bit2 : 1;
    unsigned int bit3 : 4;
    unsigned int bit4 : 2;
};
```
* 结构体的每个成员都是独立的，struct BitFileds有4个位域类型的成员，一共占8位。其中**bit1占第0位，bit2占第1位，bit3占第2\~5位，bit4占第6~7位**，结合**内存对齐**可以知道struct BitFileds占4个字节。
* struct BitFileds的内存结构图如下
![结构体&位域.png](https://upload-images.jianshu.io/upload_images/2351207-9ed09dd0f6dc6b4c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


* 根据最后的整体内存布局图我们可以得到：
**bit1=0b0=0**
**bit2=0b1=1**
**bit1=0b1010=10**
**bit1=0b11=3**

#### union my_isa_t 
```
union my_isa_t {
    unsigned int bitfileds;
    
    unsigned int bit1 : 1;
    unsigned int bit2 : 1;
    unsigned int bit3 : 4;
    unsigned int bit4 : 2;
};
```
* 该联合体有**5个成员**，**unsigned int类型的bitfields和4个位域bit1,bit2,bit3,bit4**。
* 由于**4个位域成员是属于联合体的**，因此4个位域是参考联合体进行内存布局，所以**每个位域的开始位置都是第0位**。
* 因此，bitfields占用4个字节32位（第1~32位），**bit1占用1个二进制位（第0位），bit2占用1个二进制位（第0位），bit3占用4个二进制位（第0\~3位），bit4占用2个二进制位（第0\~1位）。**
* union my_isa_t 的内存结构图如下
![联合体&位域.png](https://upload-images.jianshu.io/upload_images/2351207-600a4fdfac64ac2c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 结合最后的整体布局内存可以得到：
**bitfields=0b00001011=11**
**bit1=0b1=1**
**bit2=0b1=1**
**bit3=0b1011=11**
**bit4=0b11=3**

#### union my_new_isa_t
```
union my_new_isa_t {
    unsigned int bitfileds;
    struct {
        unsigned int bit1 : 1;
        unsigned int bit2 : 1;
        unsigned int bit3 : 4;
        unsigned int bit4 : 2;
    };
};
```
* 该联合体有**2个成员**，一个为**unsigned int 类型的bitfileds**，一个为**匿名结构体**，为了方便，我们暂时把该匿名结构体称为s,**s包含4个位域成员**。
* bitfileds大小为4字节，s大小也是4个字节，所以联合体my_new_isa_t大小为4字节，**bitfileds和s共同占用4字节内存空间**。
* **4个位域成员是属于结构体的**，所以位域成员的内存布局是在匿名结构体s下，**参考结构体s**。由于结构体的成员占用的内存是互相独立的，因此bit1占用s的第1位，bit2占用s的第2位，bit3占用s的第3\~6位，bit4占用s的第7~8位。
#### 整体内存结构图如下
![联合体&结构体&位域.png](https://upload-images.jianshu.io/upload_images/2351207-6439dcfc0fe5af20.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 结合最后的整体内存布局图可以得到：
**bitfields=0b11101010=128+64+32+8+2=234**
**bit1=0b0=0**
**bit2=0b1=1**
**bit3=0b1010=10**
**bit4=0b11=3**

结合demo中的三个例子大家应该对位域有了深入的理解，对于位段成员类型不一致的情况，这里就不展开了，大家可以结合规则进行内存分析。

## isa_t位域分析
* 结合上面的三个例子，我们自己也可以画出isa_t的内存结构图了
* isa_t根据cpu架构bitfields也会有所不同
```
union isa_t {
    isa_t() { }
    isa_t(uintptr_t value) : bits(value) { }

    Class cls;
    uintptr_t bits;
#if defined(ISA_BITFIELD)
    struct {
        ISA_BITFIELD;  // defined in isa.h
    };
#endif
};

# if __arm64__
#   define ISA_MASK        0x0000000ffffffff8ULL
#   define ISA_MAGIC_MASK  0x000003f000000001ULL
#   define ISA_MAGIC_VALUE 0x000001a000000001ULL
#   define ISA_BITFIELD                                                      \
      uintptr_t nonpointer        : 1;                                       \
      uintptr_t has_assoc         : 1;                                       \
      uintptr_t has_cxx_dtor      : 1;                                       \
      uintptr_t shiftcls          : 33; /*MACH_VM_MAX_ADDRESS 0x1000000000*/ \
      uintptr_t magic             : 6;                                       \
      uintptr_t weakly_referenced : 1;                                       \
      uintptr_t deallocating      : 1;                                       \
      uintptr_t has_sidetable_rc  : 1;                                       \
      uintptr_t extra_rc          : 19
#   define RC_ONE   (1ULL<<45)
#   define RC_HALF  (1ULL<<18)

# elif __x86_64__
#   define ISA_MASK        0x00007ffffffffff8ULL
#   define ISA_MAGIC_MASK  0x001f800000000001ULL
#   define ISA_MAGIC_VALUE 0x001d800000000001ULL
#   define ISA_BITFIELD                                                        \
      uintptr_t nonpointer        : 1;                                         \
      uintptr_t has_assoc         : 1;                                         \
      uintptr_t has_cxx_dtor      : 1;                                         \
      uintptr_t shiftcls          : 44; /*MACH_VM_MAX_ADDRESS 0x7fffffe00000*/ \
      uintptr_t magic             : 6;                                         \
      uintptr_t weakly_referenced : 1;                                         \
      uintptr_t deallocating      : 1;                                         \
      uintptr_t has_sidetable_rc  : 1;                                         \
      uintptr_t extra_rc          : 8
#   define RC_ONE   (1ULL<<56)
#   define RC_HALF  (1ULL<<7)

# else
#   error unknown architecture for packed isa
# endif
```
* isa_t在arm64架构下的内存结构图
* 首先是匿名结构体的内存结构图
![bits.png](https://upload-images.jianshu.io/upload_images/2351207-81edf20b4dfbe637.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
* 整体isa_t的内存结构图
![isa_t.png](https://upload-images.jianshu.io/upload_images/2351207-fe02241c52595d45.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
* 具体位域字段含义如下
  * **nonpointer**：表示是否对 isa指针 开启指针优化。
    * 0：不优化，是纯isa指针，当访问isa指针时，直接返回其成员变量cls。
    * 1：优化，即isa 指针内容不止是类地址，还包含了类的一些信息、对象的引用计数等。
  * **has_assoc**：是否有关联对象。
  * **has_cxx_dtor**：该对象是否有C++或Objc的析构器,如果有析构函数，则需要做一些析构的逻辑处理；如果没有，则可以更快的释放对象。
  * **shiftcls**：存储类指针的值。开启指针优化的情况下，在 x86_64 架构有 44位 用来存储类指针，arm64 架构中有 33位 。
  * **magic**：用于调试器判断当前对象是真的对象，还是一段没有初始化的空间。
  * **weakly_referenced**：用于标识对象是否被指向或者曾经被指向一个ARC的弱变量，没有弱引用的对象释放的更快。
  * **deallocating**：标识对象是否正在释放内存。
  * **has_sidetable_rc**：对象的引用计数值是否有进位。
  * **extra_c**：表示该对象的引用计数值。extra_rc只是存储了额外的引用计数，实际的引用计数公式：实际引用计数 = extra_rc + 1。
* 通过位域成员，我们就能够对位域代表的二进制进行方便的存取了，更重要的是**大大节省了内存空间的占用**。

* isa_t总结如下：isa_t联合体有3个成员，3个成员**cls\bit\匿名结构体s**共同占用8字节的内存空间，通过匿名结构体里面的位域成员，可以对8字节空间的不同二进制位进行操作，达到**节省内存空间**的目的。

### 思考
* 如果我们把匿名结构体中的位域换成基本数据类型来表示，结合内存对齐原则，得额外增加多少内存空间的消耗？
我们可以算一下
```
// 在arm64下将位域换成基本数据类型
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
```
* 答案是**24个字节**。你答对了么？
对结**构体所占空间大小、 内存对齐**这方面还存在疑惑的，可以参考[带你深入理解iOS内存对齐]([https://www.jianshu.com/p/18401f252293](https://www.jianshu.com/p/18401f252293)
)。
* 通过**位域**，可以做每一个继承自NSObject的对象都至少**减少了16字节**的内存空间，要知道1M内存也就1024个字节，这可是相当可观的！

### 总结
* 本文介绍了位域的概念和作用，结合实例让读者能够掌握分析有关位域的内存结构图，同时结合Apple的源码isa_t的内容，直观感受**位域**的带来的巨大好处，apple在优化方面的可谓是尽可能做到了极致。

参考   
[百度百科-位域](https://baike.baidu.com/item/位段/10979511?fromtitle=位域&fromid=9215688&fr=aladdin)  
[C语言位域（位段）详解](http://c.biancheng.net/view/2037.html)

