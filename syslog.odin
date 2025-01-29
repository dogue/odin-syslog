package syslog

import "core:fmt"
foreign import lib "system:c"

foreign lib {
    closelog :: proc() ---
    openlog :: proc(cstring, i32, i32) ---
    setlogmask :: proc(i32) -> i32 ---
    syslog :: proc(i32, cstring) ---
}

LogPriority :: enum i32 {
    EMERG,      // system is unusable
    ALERT,      // action must be taken immediately
    CRIT,       // critical conditions
    ERR,        // error conditions
    WARNING,    // warning conditions
    NOTICE,     // normal but significant conditions
    INFO,       // informational
    DEBUG,      // debug-level messages
}

LogFacility :: enum i32 {
    KERN,       // kernel messages
    USER,       // random user-level messages
    MAIL,       // mail system
    DAEMON,     // system daemons
    AUTH,       // security/authorization messages
    SYSLOG,     // messages generated internally by syslogd
    LPR,        // line printer subsystem
    NEWS,       // network news subsystem
    UUCP,       // UUCP subsystem
    CRON,       // clock daemon
    AUTHPRIV,   // security/authorization messages (private)
    FTP,        // ftp daemon
}

LogOption :: enum i32 {
    PID = 0x01,     // log the pid with each message
    CONS = 0x02,    // log on the console if errors in sending
    ODELAY = 0x04,  // delay open until first syslog() (default)
    NDELAY = 0x08,  // don't delay open
    NOWAIT = 0x10,  // don't wait for console forks: DEPRECATED
    PERROR = 0x20,  // log to stderr as well
}

close :: proc() {
    closelog()
}

open :: proc(ident: cstring, options: LogOption, facility: LogFacility, priority: LogPriority) {
    fac := (i32(facility) << 3) | i32(priority)
    openlog(ident, i32(options), fac)
}

set_priority :: proc(mask: LogPriority) -> i32 {
    return setlogmask(i32(mask))
}

log :: proc(priority: LogPriority, message: cstring) {
    syslog(i32(priority), message)
}

logf :: proc(priority: LogPriority, format: string, args: ..any) {
    msg := fmt.ctprintf(format, ..args)
    syslog(i32(priority), msg)
}
