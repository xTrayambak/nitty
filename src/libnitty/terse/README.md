# terse
The **TER**minal **S**tate **E**mulator is a full xterm-like terminal emulation machine, written in pure Nim.

It does not work yet, but is being worked on in the main tree.

# design goals
- Do not depend on a callback architecture.
  * The emulator state should simply contain a queue of events that the overlying program will consume.
  * The emulator state will contain routines to get the data for every cell in the terminal, much like vterm itself. The rest should be events inside the aforementioned queue.
- Do not allocate heap memory, unless absolutely necessary, especially in hot functions.
  * Preallocate aggressively. This is self-explanatory.
  * The emulator should simply have an interface for feeding pty data into the machine, a routine to reap the oldest event in the queue and a routine to get cell data.

