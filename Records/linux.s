# Common Linux Definations
.equ SYS_READ, 0
.equ SYS_WRITE, 1
.equ SYS_CLOSE, 3
.equ SYS_EXIT, 60
.equ SYS_OPENAT, 257

# Standard File Descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

# Common Direcotry Usages
.equ CURR_DIR, -100

# Common File Modes
.equ READ_ONLY, 0
.equ WRITE_ONLY, 1
.equ READ_WRITE, 2
.equ CREATE, 64
.equ TUNCATE, 512
.equ APPEND, 1024

# Common File Permissions
.equ ORW, 0600
.equ AR_ORW, 0644
.equ ARX_ORWX, 755

# Common Status Code
.equ END_OF_FILE, 0
