# Automated mask generation for PIV image analysis based on pixel intensity statistics
This matlab script was generated based on the paper ["Automated mask generation for PIV image analysis based on pixel intensity statistics"](https://link.springer.com/article/10.1007/s00348-017-2357-3) from Masullo and Theunissen.

Use the script *run.m* to load the images into memory and automatically find the mask. The method implemented in this code is slightly different from the one described in the paper. While the probability matrix is generated in the same way, the thresholding is performed using k-means rather than Otsu's threshold. This function requires the *Statistics and Machine Learning Toolbox*.

Please reference this paper if used in your work:
```
@Article{Masullo2017,
author="Masullo, Alessandro
and Theunissen, Raf",
title="Automated mask generation for PIV image analysis based on pixel intensity statistics",
journal="Experiments in Fluids",
year="2017",
month="May",
day="23",
volume="58",
number="6",
pages="70",
issn="1432-1114",
doi="10.1007/s00348-017-2357-3",
url="https://doi.org/10.1007/s00348-017-2357-3"
}
```

### Abstract
The measurement of displacements near the vicinity of surfaces involves advanced PIV algorithms requiring accurate knowledge of object boundaries. These data typically come in the form of a logical mask, generated manually or through automatic algorithms. The automatic detection of masks usually necessitates special features or reference points such as bright lines, high contrast objects, and sufficiently observable coherence between pixels. These are, however, not always present in experimental images necessitating a more robust and general approach. In this work, the authors propose a novel method for the automatic detection of static image regions which do not contain relevant information for the estimation of particle image displacements and can consequently be excluded or masked out. The method does not require any a priori knowledge of the static objects (i.e., contrast, brightness, or strong features) as it exploits statistical information from multiple PIV images. Based on the observation that the temporal variation in light intensity follows a completely different distribution for flow regions and object regions, the method utilizes a normality test and an automatic thresholding method on the retrieved probability to identify regions to be masked. The method is assessed through a Monte Carlo simulation with synthetic images and its performance under realistic imaging conditions is proven based on three experimental test cases.


