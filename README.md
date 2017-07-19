# intrin

A short little example of using intrinsics for vectorization

Required:

   1) GCC C++-11 compiler (>= version 4.7)
   2) Support for SSE2
   3) CMake (>= version 3.1.3)
    
Compile and Run:

   	$ mkdir build
   	$ cd build
   	$ cmake ..
   	$ make
   	$ ./intrin

    ... will report the timing of intrinsics SIMD vs. OpenMP SIMD ...

   	$ cmake -DUSE_OPENMP=OFF ..
   	$ make
   	$ ./intrin

    ... will report the timing of intrinsics SIMD vs. whatever auto-vectorization the compiler does ...

My results:

	Build flags: (CPU: Intel Core i7-6500U CPU @ 2.50GHz with AVX-512 capabilities)
		-Wall -fopt-info-vec-optimized -msse2 -msse3 -mssse3 -msse4.1 -mavx -mavx2 -O3 -DNDEBUG -ftree-vectorize -ftree-loop-vectorize
	
	intrinsics vs. OpenMP:

		Number of steps: 1000000000...
			 intrin (double):  pi with 1000000000 steps is (5.00e+08, ... , 5.00e+08)  in [ 5.090 wall, 5.090 user + 0.000 system = 5.090 CPU [seconds] (100.0%) ]
			  array (double):  pi with 1000000000 steps is (5.00e+08, ... , 5.00e+08)  in [ 6.970 wall, 6.970 user + 0.000 system = 6.970 CPU [seconds] (100.0%) ]
			 intrin (tv_vec):  pi with 1000000000 steps is (1.67e+08, ... , 1.67e+08)  in [ 9.520 wall, 9.510 user + 0.000 system = 9.510 CPU [seconds] ( 99.9%) ]
			array (tv_array):  pi with 1000000000 steps is (1.67e+08, ... , 1.67e+08)  in [ 11.860 wall, 11.860 user + 0.000 system = 11.860 CPU [seconds] (100.0%) ]

		Notes: 
			- intrinsics ~37% faster than OpenMP SIMD for += double operation
			- intrinsics ~25% faster than OpenMP SIMD for += array operation
		  
	intrinsics vs. compiler optimizations (declaring highest GCC optimization -O3 and :

		Number of steps: 1000000000...
             intrin (double):  pi with 1000000000 steps is (5.00e+08, ... , 5.00e+08)  in [ 5.170 wall, 5.170 user + 0.000 system = 5.170 CPU [seconds] (100.0%) ]
              array (double):  pi with 1000000000 steps is (5.00e+08, ... , 5.00e+08)  in [ 17.510 wall, 17.430 user + 0.010 system = 17.440 CPU [seconds] ( 99.6%) ]
             intrin (tv_vec):  pi with 1000000000 steps is (1.67e+08, ... , 1.67e+08)  in [ 9.760 wall, 9.720 user + 0.010 system = 9.730 CPU [seconds] ( 99.7%) ]
            array (tv_array):  pi with 1000000000 steps is (1.67e+08, ... , 1.67e+08)  in [ 31.980 wall, 31.970 user + 0.000 system = 31.970 CPU [seconds] (100.0%) ]

		Notes:
			- intrinsics ~239% faster than compiler auto-vectorization for += double operation
			- intrinsics ~228% faster than compiler auto-vectorization for += array operation


