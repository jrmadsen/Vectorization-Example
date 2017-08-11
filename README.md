# Vectorization-Example

A short little example of using intrinsics for vectorization

Required:

   1) GCC C++-11 compiler (>= version 4.7)
   2) Support for AVX and AVX2
   3) CMake (>= version 3.1.3)
    
Compile and Run:

       $ mkdir build
       $ cd build
       $ cmake ..
       $ make
       $ ./intrin-autovec

        ... will report the timing of intrinsics SIMD vs. whatever auto-vectorization the compiler does ...
    
       $ ./intrin-ompsimd

        ... will report the timing of intrinsics SIMD vs. OpenMP SIMD ...

My results:

    Build flags: (CPU: Intel Core i7-6500U CPU @ 2.50GHz with AVX-512 capabilities)
        -Wall -fopt-info-vec-optimized -msse2 -msse3 -mssse3 -msse4.1 -mavx -mavx2 -mfma -O3 -DNDEBUG -ftree-vectorize -ftree-loop-vectorize
    
    intrinsics vs. OpenMP:

            Number of steps: 1000000000...
                     intrin (double):  pi with 1000000000 steps is (5.00e+08, ... , 5.00e+08)  in [ 5.260 wall, 5.250 user + 0.000 system = 5.250 CPU [seconds] ( 99.8%) ]
                      array (double):  pi with 1000000000 steps is (5.00e+08, ... , 5.00e+08)  in [ 7.060 wall, 7.070 user + 0.000 system = 7.070 CPU [seconds] (100.1%) ]
               Relative compute time:  (7.06s - 5.26s)/(5.26s) * 100 = 34.22%

                     intrin (tv_vec):  pi with 1000000000 steps is (1.67e+08, ... , 1.67e+08)  in [ 9.410 wall, 9.410 user + 0.000 system = 9.410 CPU [seconds] (100.0%) ]
                    array (tv_array):  pi with 1000000000 steps is (1.67e+08, ... , 1.67e+08)  in [ 10.890 wall, 10.890 user + 0.000 system = 10.890 CPU [seconds] (100.0%) ]
               Relative compute time:  (10.89s - 9.41s)/(9.41s) * 100 = 15.73%

                Notes: 
                - intrinsics ~34% faster than OpenMP SIMD for += double operation
                - intrinsics ~16% faster than OpenMP SIMD for += array operation
          
    intrinsics vs. compiler optimizations (declaring highest GCC optimization -O3) :

        Number of steps: 1000000000...
                     intrin (double):  pi with 1000000000 steps is (5.00e+08, ... , 5.00e+08)  in [ 5.280 wall, 5.240 user + 0.000 system = 5.240 CPU [seconds] ( 99.2%) ]
                      array (double):  pi with 1000000000 steps is (5.00e+08, ... , 5.00e+08)  in [ 17.590 wall, 17.570 user + 0.000 system = 17.570 CPU [seconds] ( 99.9%) ]
               Relative compute time:  (17.59s - 5.28s)/(5.28s) * 100 = 233.14%

                     intrin (tv_vec):  pi with 1000000000 steps is (1.67e+08, ... , 1.67e+08)  in [ 9.750 wall, 9.740 user + 0.000 system = 9.740 CPU [seconds] ( 99.9%) ]
                    array (tv_array):  pi with 1000000000 steps is (1.67e+08, ... , 1.67e+08)  in [ 35.660 wall, 35.670 user + 0.000 system = 35.670 CPU [seconds] (100.0%) ]
               Relative compute time:  (35.66s - 9.75s)/(9.75s) * 100 = 265.74%
               
                 Notes:
                 - intrinsics ~233% faster than compiler auto-vectorization for += double operation
                 - intrinsics ~266% faster than compiler auto-vectorization for += array operation


