/* ============================================================
 * 最小 SysY 运行时库（教学用实现）
 * 正式作业的《SysY运行时库》接口与此一致，可平滑替换
 * 函数命名/语义遵循全国编译系统设计赛 SysY 约定
 * ============================================================ */
#include <stdio.h>

/* ---- 输入 ---- */
int getint() {
    int x;
    scanf("%d", &x);
    return x;
}

int getch() {
    return getchar();
}

int getarray(int a[]) {
    int n;
    scanf("%d", &n);
    for (int i = 0; i < n; i++) scanf("%d", &a[i]);
    return n;
}

/* ---- 输出 ---- */
void putint(int x) {
    printf("%d", x);
}

void putch(int x) {
    putchar(x);
}

void putarray(int n, int a[]) {
    printf("%d:", n);
    for (int i = 0; i < n; i++) printf(" %d", a[i]);
    printf("\n");
}

/* ---- 计时（性能测试用，此处为简易实现）---- */
#include <time.h>
static clock_t _start_clk;
void starttime() { _start_clk = clock(); }
void stoptime() {
    fprintf(stderr, "[stoptime] %ld us\n",
            (long)(clock() - _start_clk) * 1000000 / CLOCKS_PER_SEC);
}
