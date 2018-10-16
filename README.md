# chronuxGPU
Chronux 2.12 package with support for GPU (to speed up the computations)

The code includes a simple modification of the Chronux package (http://chronux.org/) 
to use GPU for power and coherence computations involving continuous and point binned signals.

MATLAB's GPU support should be correctly configured, and a global variable CHRONUXGPU should be set to true.

See (and run) test\GPUSpeedupTest.m for further details. 
