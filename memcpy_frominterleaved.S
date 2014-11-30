/*
	Helix library Arduino interface

	Copyright (c) 2014 Frank Bösing

	This library is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this library.  If not, see <http://www.gnu.org/licenses/>.

	The helix decoder itself as a different license, look at the subdirectories for more info.

	Diese Bibliothek ist freie Software: Sie können es unter den Bedingungen
	der GNU General Public License, wie von der Free Software Foundation,
	Version 3 der Lizenz oder (nach Ihrer Wahl) jeder neueren
	veröffentlichten Version, weiterverbreiten und/oder modifizieren.

	Diese Bibliothek wird in der Hoffnung, dass es nützlich sein wird, aber
	OHNE JEDE GEWÄHRLEISTUNG, bereitgestellt; sogar ohne die implizite
	Gewährleistung der MARKTFÄHIGKEIT oder EIGNUNG FÜR EINEN BESTIMMTEN ZWECK.
	Siehe die GNU General Public License für weitere Details.

	Sie sollten eine Kopie der GNU General Public License zusammen mit diesem
	Programm erhalten haben. Wenn nicht, siehe <http://www.gnu.org/licenses/>.

	Der Helixdecoder selbst hat eine eigene Lizenz, bitte für mehr Informationen
	in den Unterverzeichnissen nachsehen.

 */

//Fast copy decoded data (interleaved LRLRLR) to the two audiobuffers (LLL, RRR)
 
 .cpu cortex-m4
.syntax unified
.thumb
.text
.align	2

/* void memcpy_frominterleaved(short *dst1, short *dst2, short *src); */
 .global	memcpy_frominterleaved
.thumb_func	
	memcpy_frominterleaved:

	@ r0: dst1
	@ r1: dst2
	@ r2: src

	push	{r0, r4-r10, r12}
	mov r12, #4 - 1
	//mov r12, #64 - 1
	.align 2	
.loop:
	//.irp offset, 1,2,3,4, 5,6,7,8, 9,10,11,12, 13,14,15,16
	.irp offset, 1,2,3,4, 5,6,7,8

	//load 4 words (16 byte)  at once into r3,r4, increase adress of r2
	ldmia r2!,{r3,r4,r7,r8}
	
	// Neighboring load and store single instructions can pipeline their address and data phases. 
	// This enables these instructions to complete in a single execution cycle

	strh r3,[r1], #2
	strh r4,[r1], #2
	strh r7,[r1], #2
	strh r8,[r1], #2
	
	mov r5, r3, lsr #16	
	mov r6, r4, lsr #16		
	mov r9, r7, lsr #16	
	mov r10, r8, lsr #16		
	strh r5,[r0], #2
	strh r6,[r0], #2
	strh r9,[r0], #2	
	strh r10,[r0], #2
	
	.endr
	
	subs r12, #1
	bhs .loop
	
	pop	{r0, r4-r10,r12}
	
.END

