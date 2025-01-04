import time
import torch

device_cpu = torch.device("cpu")
device_mps = torch.device("mps") if torch.backends.mps.is_available() else device_cpu

# Example tensor operation
x = torch.randn(1000, 1000)
y = torch.randn(1000, 1000)

# CPU Benchmark
start = time.time()
for _ in range(1000):
    z = torch.mm(x, y)
print("CPU Time:", time.time() - start)

# MPS Benchmark
x = x.to(device_mps)
y = y.to(device_mps)
start = time.time()
for _ in range(1000):
    z = torch.mm(x, y)
print("MPS Time:", time.time() - start)