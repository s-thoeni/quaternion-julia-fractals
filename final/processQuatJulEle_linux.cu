/**
 * @file pctdemo_processMandelbrotElement.cu
 * 
 * CUDA code to calculate the Mandelbrot Set on a GPU.
 * 
 * Copyright 2011 The MathWorks, Inc.
 */

/** Work out which piece of the global array this thread should operate on */ 
__device__ size_t calculateGlobalIndex() {
    // Which block are we?
    size_t const globalBlockIndex = blockIdx.x + blockIdx.y * gridDim.x;
    // Which thread are we within the block?
    size_t const localThreadIdx = threadIdx.x + blockDim.x * threadIdx.y;
    // How big is each block?
    size_t const threadsPerBlock = blockDim.x*blockDim.y;
    // Which thread are we overall?
    return localThreadIdx + globalBlockIndex*threadsPerBlock;

}

/** The actual Mandelbrot algorithm for a single location */ 
__device__ unsigned int doIterations( double const xPart0, 
                                      double const yPart0,
                                      double const zPart0,
                                      double const wPart0,
                                      double const cx,
                                      double const cy,
                                      double const cz,
                                      double const cw,
                                      unsigned int const maxIters ) {
    // Initialise: z = z0
    double xPart = xPart0;
    double yPart = yPart0;
    double zPart = zPart0;
    double wPart = wPart0;
    unsigned int count = 0;
    // Loop until escape
    while ( ( count <= maxIters )
            && ((xPart*xPart + yPart*yPart + zPart*zPart + wPart*wPart) <= 16.0) ) {
        ++count;
        // Update: z = z*z + z0;
        double const oldXPart = xPart;
        double const oldYPart = yPart;
        double const oldZPart = zPart;
        double const oldWPart = wPart;
        // Quat mult and add constant
        xPart = oldXPart*oldXPart-oldYPart*oldYPart-oldZPart*oldZPart-oldWPart*oldWPart + cx;
        yPart = oldXPart*oldYPart+oldYPart*oldXPart-oldZPart*oldWPart+oldWPart*oldZPart + cy;
        zPart = oldXPart*oldZPart+oldYPart*oldWPart+oldZPart*oldXPart-oldWPart*oldYPart + cz;
        wPart = oldXPart*oldWPart-oldYPart*oldZPart+oldZPart*oldYPart+oldWPart*oldXPart + cw;
        //xPart = xPart*xPart - yPart*yPart + xPart0;
        //yPart = 2.0*oldRealPart*yPart + yPart0;
    }
    return count;
}


/** Main entry point.
 * Works out where the current thread should read/write to global memory
 * and calls doIterations to do the actual work.
 */
__global__ void processMandelbrotElement( 
                      double * out, 
                      const double * x, 
                      const double * y,
                      const double * z,
                      const double * w,
                      const double cx,
                      const double cy,
                      const double cz,
                      const double cw,                      
                      const unsigned int maxIters, 
                      const unsigned int numel ) {
    // Work out which thread we are
    size_t const globalThreadIdx = calculateGlobalIndex();

    // If we're off the end, return now
    if (globalThreadIdx >= numel) {
        return;
    }
    
    // Get our X and Y coords
    double const xPart0 = x[globalThreadIdx];
    double const yPart0 = y[globalThreadIdx];
    double const zPart0 = z[globalThreadIdx];
    double const wPart0 = w[globalThreadIdx];

    // Run the itearations on this location
    unsigned int const count = doIterations( xPart0, yPart0, zPart0, wPart0, cx, cy, cz, cw, maxIters );
    out[globalThreadIdx] =  double( count  );
}
