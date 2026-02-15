# ⏰ 8086 Real-Time Clock Display

A real-time clock rendered directly to VGA text-mode video memory on the Intel 8086 processor, written in TASM (Turbo Assembler).

The clock displays `HH:MM:SS` in the bottom-right corner of the screen, with each component in a different color:

| Component | Color  |
|-----------|--------|
| Hours     | Green  |
| Minutes   | Blue   |
| Seconds   | Red    |
| Colons    | Black  |

All text is rendered on a white background. The display updates every second and exits on any keypress.

## How It Works

- Time is read via DOS interrupt `int 21h` (function `2Ch`)
- Output is written directly to VGA text memory at segment `0B800h` using the `stosw` string instruction — each call writes a character + color attribute and auto-increments the pointer
- The main loop polls for time changes and only redraws when the second value changes, avoiding unnecessary writes to video memory
- Keyboard input is checked via `int 16h` (function `01h`) in a non-blocking manner

## Build & Run

### Requirements

- [TASM](https://en.wikipedia.org/wiki/Turbo_Assembler) (Turbo Assembler)
- [TLINK](https://en.wikipedia.org/wiki/Turbo_Assembler) (Turbo Linker)
- DOS environment or [DOSBox](https://www.dosbox.com/)

### Commands

```
tasm clock.asm
tlink clock.obj
clock.exe
```

Press any key to exit.

## Project Structure

```
├── clock.asm    — main source file
└── README.md
```
