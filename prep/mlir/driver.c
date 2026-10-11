/* C interface emitted by MLIR for static rank-one memref arguments. */
#include <stdint.h>
#include <stdio.h>
typedef struct {
    int16_t *allocated, *aligned;
    int64_t offset, sizes[1], strides[1];
} MemRef16;
extern void _mlir_ciface_vecadd(MemRef16 *, MemRef16 *, MemRef16 *);
int main(void) {
    int16_t a[16], b[16], c[16] = {0};
    for (int i=0;i<16;i++) { a[i]=(int16_t)i; b[i]=1; }
    MemRef16 x={a,a,0,{16},{1}}, y={b,b,0,{16},{1}}, z={c,c,0,{16},{1}};
    _mlir_ciface_vecadd(&x,&y,&z);
    for (int i=0;i<16;i++) {
        if (c[i]!=i+1) { fprintf(stderr,"wrong result at %d\n",i); return 1; }
        printf("%d%c",c[i],i==15?'\n':' ');
    }
    return 0;
}
