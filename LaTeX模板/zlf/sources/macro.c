#define STEP(x) ((x) + 1)
#ifndef MODE
#define MODE 0
#endif
// This comment should disappear.
int main(void) {
#if MODE
  return STEP(4);
#else
  return STEP(1);
#endif
}
