#!/usr/bin/env bash

command -v bc > /dev/null || { echo "bc was not found. Please install bc."; exit 1; }
{ command -v drill > /dev/null && dig=drill; } || { command -v dig > /dev/null && dig=dig; } || { echo "dig was not found. Please install dnsutils."; exit 1; }



NAMESERVERS=`cat /etc/resolv.conf | grep ^nameserver | cut -d " " -f 2 | sed 's/\(.*\)/&#&/'`

PROVIDERS="
1.1.1.1#cloudflare 
4.2.2.1#level3 
8.8.8.8#google 
9.9.9.9#quad9
80.80.80.80#freenom 
208.67.222.123#opendns 
199.85.126.10#norton 
185.228.168.9#cleanbrowsing 
77.88.8.7#yandex 
176.103.130.132#adguard 
8.26.56.26#comodo 
174.138.21.128#tiarapp 
198.101.242.72#alternate 
216.146.35.35#dyn 
64.6.64.6#verisign 
84.200.69.80#watch 
185.121.177.177#openic 
195.46.39.39#safe 
91.239.100.100#uncensored 
156.154.70.1#neustar 
"

# Domains to test. Duplicated domains are ok
DOMAINS2TEST="google.com amazon.com facebook.com youtube.com wikipedia.org twitter.com gmail.com github.com pahe.me bola.net anitoki.web.id instagram.com skype.com godaddy.com tokopedia.com shopee.co.id bukalapak.com traveloka.com walmart.com yahoo.com linkedin.com bing.com apple.com jquery.com adobe.com pinterest.com msn.com avast.com hola.org cloudflare.com whatsapp.com yandex.ru viber.com imgur.com giphy.com wikimedia.org flickr.com 500px.com mozilla.org tumblr.com teamviewer.com oracle.com stumbleupon.com steamcommunity.com discordapp.com gravatar.com wordpress.com outbrain.com disqus.com ebay.com vk.com bittorrent.com live.com digg.com office.com accu-weather.com paypal.com dropbox.com microsoft.com baidu.com imdb.com alexa.com vimeo.com naver.com pixiv.net avg.com aol.com cnn.com soundcloud.com kaspersky.com norton.com nytimes.com bbc.co.uk heroku.com goodreads.com rottentomatoes.com samsung.com lazada.co.id dailymail.co.uk alibaba.com spotify.com bloomberg.com symantec.com billboard.com nvidia.com huffpost.com ask.com stackoverflow.com telegraph.co.uk opera.com reuters.com"


totaldomains=0
result=2000000
printf "%-18s" ""
for d in $DOMAINS2TEST; do
    totaldomains=$((totaldomains + 1))
    printf "%-8s" "test$totaldomains"
done
printf "%-8s" "Average"
echo ""


for p in $NAMESERVERS $PROVIDERS; do
    pip=${p%%#*}
    pname=${p##*#}
    ftime=0

    printf "%-18s" "$pname"
    for d in $DOMAINS2TEST; do
        ttime=`$dig +tries=1 +time=2 +stats @$pip $d |grep "Query time:" | cut -d : -f 2- | cut -d " " -f 2`
        if [ -z "$ttime" ]; then
	        #let's have time out be 1s = 1000ms
	        ttime=1000
        elif [ "x$ttime" = "x0" ]; then
	        ttime=1
	    fi

        printf "%-8s" "$ttime ms"
        ftime=$((ftime + ttime))
    done
    avg=`bc -lq <<< "scale=2; $ftime/$totaldomains"`

    echo "  $avg"
        n1=$(echo $avg | cut -d"." -f 1)
    n2=$(echo $avg | cut -d"." -f 2)
    nf=$(echo "$n1$n2")
    if [[ "$nf" -lt "$result" ]]; then
        timer=$avg
        result=$nf
        winner=$pname
    fi
done

echo ""
echo "## The Winner is $winner with a time of $timer ##"

exit 0;
