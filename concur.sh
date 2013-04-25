(
    echo $((5*4)) >> /tmp/$$
)&

(
    echo $((3+2)) >> /tmp/$$
)&

(
    echo $((6-2)) >> /tmp/$$
)&

wait
awk '{ sum += $1 } END { print sum}' /tmp/$$
