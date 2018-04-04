Here is the steps on how to get cross-compiler to hurd:

Build a cross-compiler:

0. Convenience variables:
   $ target=i686-pc-gnu

1. Install gnumach headers (message passing .defs and a few (5?) syscalls gnumach has)
   $ USE=headers-only emerge -v1 cross-${target}/gnumach

2. Install gnumach-specific IDL generator:
   $ USE=headers-only emerge -v1 cross-${target}/mig

3. Install hurd headers (actual messages for syscall implementation)
   $ USE=headers-only emerge -v1 cross-${target}/hurd

4. Install glibc headers (libc wrappers around syscalls)
   $ USE=headers-only emerge -v1 =cross-${target}/glibc-9999

5. Install gcc stage1 (C only):
   $ USE="-*" emerge -v1 cross-${target}/gcc

6. Install full glibc
   $ emerge -v1 =cross-${target}/glibc-9999

7. Install (almost) full gcc
   $ USE="-* cxx" emerge -v1 cross-${target}/gcc

Done!

TODOs:

- fix crossdev to handle automatic ARCH and KERNEL (re-)assignment in profiles
- describe symlink creation in detail
