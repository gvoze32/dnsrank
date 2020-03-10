# DNS Performance Ranker

Shell script to test the performance of the most popular DNS resolvers from your location.

Includes by default:
 * CloudFlare
 * Google
 * Quad9
 * OpenDNS
 * CleanBrowsing
 * Yandex
 * AdGuard
 * Neustar
 * Tiarapp
 * Verisign 
 * DNS.WATCH
 * OpeNIC 
 * UncensoredDNS 
 * Neustar 

# Required 

You need to install bc and dig. For Arch:

```
 $ sudo pacman -S bc dnsutils
```

# Utilization

``` 
 $ git clone --depth=1 https://github.com/gvoze32/dnsrank
 $ cd dnsrank
 $ bash ./dnsrank.sh 
```

# For Windows users using the Linux subsystem

If you receive an error `$'\r': command not found`, convert the file to a Linux-compatible line endings using:

    tr -d '\15\32' < dnsrank.sh > dnsrank-2.sh
    
Then run `bash ./dnsrank-2.sh`
