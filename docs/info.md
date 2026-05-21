<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project is a digital bioimpedance demodulator made in GF180 technology.
It uses eight I/Q stages. Each stage takes a 1‑bit input signal and a clock.
The clock is divided by two at every stage. This means each stage works at a lower frequency than the one before.
Each stage gives two values of 8 bits: one for I and one for Q.
All eight stages produce 128 bits in total. These bits are stored in a register.
When the data is ready, a signal turns on.
Then a UART module sends the 16 bytes (I and Q values of all stages) on the TX pin.
The clock for the demodulation comes from outside, so you can choose the frequency.

## How to test

Turn on the board with the Tiny Tapeout setup.
Connect an external clock to ui[1].
Connect the 1‑bit ADC signal to ui[0].
Reset the chip by pulling rst_n low, then high.
Read the UART output on uo[0] with 9600 bauderate  
The chip sends 16 bytes. For each stage, you receive two bytes: first Q, then I.
Stage 0 is the fastest. Stage 7 is the slowest.
You can also use a USB‑UART adapter and a serial terminal to see the data (Putty for example).

## External hardware

An external clock generator connected to ui[1].
A 1‑bit signal source (for example a sigma‑delta ADC) connected to ui[0].
