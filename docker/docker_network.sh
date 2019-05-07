ln -s /var/run/docker/netns  /var/run/netns
echo creating test1 and test2
docker run --rm --network none  --name test1 k8s_demo sleep 100000 &
docker run --rm --network none  --name test2 k8s_demo sleep 100000 &

sleep 1

test1=$(docker inspect --format '{{.State.Pid}}' test1)
test2=$(docker inspect --format '{{.State.Pid}}' test2)

echo pid of test1 and test1 are ${test1} ${test2}

echo creating veth for test1

ip link add veth${test1} type veth peer name ${test1}
test1_netns=$(basename `docker inspect test1|grep netns|awk '{print $2}'|tr -d '",'`)
brctl addif cb0 veth${test1}
ip link set ${test1} netns ${test1_netns}
ip netns exec ${test1_netns}  ip addr add 192.168.100.100/24 dev ${test1}

ip link set veth${test1} up
ip netns exec ${test1_netns}  ip link set ${test1} up
ip netns exec ${test1_netns}  ip link set lo up

echo creating veth for test2

ip link add veth${test2} type veth peer name ${test2}
test2_netns=$(basename `docker inspect test2|grep netns|awk '{print $2}'|tr -d '",'`)
brctl addif cb0 veth${test2}
ip link set ${test2} netns ${test2_netns}
ip netns exec ${test2_netns}  ip addr add 192.168.100.200/24 dev ${test2}

ip link set veth${test2} up
ip netns exec ${test2_netns}  ip link set ${test2} up
ip netns exec ${test2_netns}  ip link set lo up
