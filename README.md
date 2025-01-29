# Odin Syslog Bindings

Minimal syslog bindings for Odin, providing a simple interface to the system logging facilities.

## Usage

```odin
import "syslog"

main :: proc() {
   // Open with desired options
   syslog.open("myapp", .PID, .USER, .INFO)
   defer syslog.close()

   // Log messages
   syslog.log(.INFO, "Server started")
   syslog.logf(.ERR, "Failed to load %s", "config.json")
}
