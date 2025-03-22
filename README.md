Pytorch implementation (using pretrained weights) of:

    Color image demosaicking via deep residual learning,
    Tan, Runjie and Zhang, Kai and Zuo, Wangmeng and Zhang, Lei
    2017 IEEE International Conference on Multimedia and Expo (ICME)

based on [CDM-CNN](https://github.com/csrjtan/CDM-CNN)



Output on Apple MacBookPro13M2 8 GB:
```
/V/d/D/g/g/cdm_cnn>./do.sh '/Volumes/tmp/IMGP0085.DNG' 1 1 3.10      21.562s (main|●) 12:53
3.10.16 (main, Dec  3 2024, 17:27:57) [Clang 16.0.0 (clang-1600.0.26.4)]
     PyTorch version: 2.6.0
       NumPy version: 2.2.4
        tqdm version: 4.67.1
scikit-image version: 0.25.2
 hdf5storage version: 0.1.19
/Volumes/tmp/
IMGP0085
.DNG
Loading Pentax K10D image from /Volumes/tmp/IMGP0085.DNG ...
Scaling with darkness 0, saturation 4095, and
multipliers 1.423581 1.070826 1.000000 1.070826
Building histograms...
Writing data to /Volumes/tmp/IMGP0085.tiff ...
20070125_1518
/Volumes/tmp/20070125_1518_IMGP0085__'dcraw_-v_-T_-d_-4'__'python3.10_cdmcnn.py_--gpu_--linear_input_--offset_x=1_--offset_y=1'.tiff
Loading Matconvnet weights
downloading pretrained model - using cached model: /Volumes/dev/Documents/git.repos/github/cdm_cnn/cached_CDM-CNN_model_10.pt
Using mps backend for acceleration.
Crop 48
uint16
  - Input is linear, mapping to sRGB for processing
  - offset x
  - offset y
  - formatting mosaick
Start demosaick
mps:0
Start
Net finished
Before sync
Finished sync
Time  6858 ms
Finished demosaick
Prepared R and M
Cropping
  - remove offset x
  - remove offset y
  - Input is linear, mapping output back from sRGB
  - raw image without groundtruth, bypassing metric
out
Time  8859 ms
    1 image files updated

```