https://blog.cloudflare.com/how-to-receive-a-million-packets/

I was very surprized by your low numbers and now I'm seriously wondering how you implemented your programs, because I get significantly different results even with the most naive send() / recv() approach each running on a single core, without threads nor anything :

sender$ taskset -c 1 ./snd -l 172.16.0.12:4000 -n 10000000 -m 32
10000000 packets sent in 9832132 us

receiver$ taskset -c 1 ./rcv -l 172.16.0.12:4000
1048576 packets in 1101686 us = 0.952 Mpps
1048576 packets in 1022431 us = 1.026 Mpps
1048576 packets in 1023755 us = 1.024 Mpps
1048576 packets in 1020582 us = 1.027 Mpps
1048576 packets in 1022920 us = 1.025 Mpps
1048576 packets in 1025329 us = 1.023 Mpps
1048576 packets in 1022739 us = 1.025 Mpps
1048576 packets in 1022317 us = 1.026 Mpps
1048576 packets in 1022663 us = 1.025 Mpps
^C

And as you can see with strace, it's very naive :

04:48:37.599730 sendto(3, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", 32, MSG_DONTWAIT|MSG_NOSIGNAL, {sa_family=AF_INET, sin_port=htons(4000), sin_addr=inet_addr("172.16.0.12")}, 16) = 32
04:48:37.599782 sendto(3, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", 32, MSG_DONTWAIT|MSG_NOSIGNAL, {sa_family=AF_INET, sin_port=htons(4000), sin_addr=inet_addr("172.16.0.12")}, 16) = 32
04:48:37.599831 sendto(3, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", 32, MSG_DONTWAIT|MSG_NOSIGNAL, {sa_family=AF_INET, sin_port=htons(4000), sin_addr=inet_addr("172.16.0.12")}, 16) = 32
^C

04:48:37.599754 recvfrom(3, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", 32, MSG_NOSIGNAL, {sa_family=AF_INET, sin_port=htons(4824), sin_addr=inet_addr("172.16.0.11")}, [16]) = 32
04:48:37.599806 recvfrom(3, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", 32, MSG_NOSIGNAL, {sa_family=AF_INET, sin_port=htons(4824), sin_addr=inet_addr("172.16.0.11")}, [16]) = 32
04:48:37.599856 recvfrom(3, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", 32, MSG_NOSIGNAL, {sa_family=AF_INET, sin_port=htons(4824), sin_addr=inet_addr("172.16.0.11")}, [16]) = 32
^C

Normally you need to play with sendmmsg(), mmap and friends when you want to achieve multiple Mpps per core, not just to approach that number.

I'm seeing that you took care of getting rid of iptables so it cannot be the reason for your poor performance. Are you sure you're not using a lib or framework which abstracts your socket and does a lot of crap below instead of doing what you ask it to do (send or receive packets) ?

It seems to me all the tuning and optimizations you had to do were needed to workaround the root cause of the slowdown.
