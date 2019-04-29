echo creating test1 and test2 network namespace
ip netns add test1
ip netns add test2
ls /var/run/netns

ip link add test1-eth0 type veth peer name test2-eth0

ip link set test1-eth0 netns test1
ip link set test2-eth0 netns test2

ip netns exec test1 ip link set test1-eth0 name eth0
ip netns exec test2 ip link set test2-eth0 name eth0

ip netns exec test1 ip link set eth0 up 
ip netns exec test1 ip link set lo up 

ip netns exec test2 ip link set eth0 up 
ip netns exec test2 ip link set lo up 

ip netns exec test1 ip addr add 192.168.100.100/24 dev eth0
ip netns exec test2 ip addr add 192.168.100.200/24 dev eth0

ip netns exec test1 ping 192.168.100.200 -c 5

ip netns del test1
ip netns del test2
