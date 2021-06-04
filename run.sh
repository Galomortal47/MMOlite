for i in {1..64}; do
    ./MMOlite.x86_64 -client 45.76.247.182 1909 "abc${i}" &
done