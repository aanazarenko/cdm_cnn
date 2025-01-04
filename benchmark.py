import time
import torch

# Define devices
device_cpu = torch.device("cpu")
device_mps = torch.device("mps") if torch.backends.mps.is_available() else device_cpu
device_cuda = torch.device("cuda") if torch.cuda.is_available() else device_cpu

# Example tensor operation
x = torch.randn(1000, 1000)
y = torch.randn(1000, 1000)

# CPU Benchmark
start = time.time()
for _ in range(1000):
    z = torch.mm(x, y)
print("CPU Time:", time.time() - start)

# MPS Benchmark
if device_mps != device_cpu:
    x_mps = x.to(device_mps)
    y_mps = y.to(device_mps)
    start = time.time()
    for _ in range(1000):
        z = torch.mm(x_mps, y_mps)
    print("MPS Time:", time.time() - start)

# CUDA Benchmark
if device_cuda != device_cpu:
    x_cuda = x.to(device_cuda)
    y_cuda = y.to(device_cuda)
    start = time.time()
    for _ in range(1000):
        z = torch.mm(x_cuda, y_cuda)
    print("CUDA Time:", time.time() - start)