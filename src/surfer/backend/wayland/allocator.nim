## Routines for handling CPU-backed (RAM) buffers
##
## Copyright (C) 2025 Trayambak Rai (xtrayambak@disroot.org)
import ../../types

when defined(posix):
  import std/posix

when defined(linux):
  var MFD_CLOEXEC {.importc, header: "<sys/mman.h>".}: uint32
  proc memfd_create(
    name: cstring, flags: uint32
  ): int32 {.importc, header: "<sys/mman.h>".}

else:
  {.error: "The shared memory allocator only supports Linux right now. Sorry!".}

type SharedMemory* = object
  fd*: int32
  buffer*: pointer

proc allocateShmemFd*(size: int32): SharedMemory =
  when defined(linux):
    let fd = memfd_create("surfer", MFD_CLOEXEC)
    if fd < 0:
      raise newException(
        CannotAllocateBuffer,
        "Cannot allocate shared memory buffer (size=" & $size & "): " & $strerror(errno) &
          " (errno " & $errno & ')',
      )

    discard ftruncate(fd, Off(size))
    let buffer = posix.mmap(nil, size.int, PROT_READ or PROT_WRITE, MAP_SHARED, fd, 0)
    if buffer == cast[pointer](-1):
      raise newException(
        CannotAllocateBuffer,
        "Cannot mmap shared memory buffer (size=" & $size & "): " & $strerror(errno) &
          " (errno " & $errno & ')',
      )

    SharedMemory(fd: fd, buffer: buffer)
  else:
    SharedMemory(fd: 0'i32, buffer: nil)
