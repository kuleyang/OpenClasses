# OpenClasses
网易公开课

``` C
#import <stdio.h>
void printHello(){
    printf("hello,world!\n");
}

void printGoodbye(){
    printf("goodbyg,world!\n");
}

void doTheThing(int type){
    void (*fnc)();
    if(type ==0){
        fnc = printHello;
    }else{
        fnc = printGoodbye;
    }
    fnc();
}
```
