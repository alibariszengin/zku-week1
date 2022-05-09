pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib-matrix/circuits/matMul.circom";// hint: you can use more than one templates in circomlib-matrix to help you
include "../../node_modules/circomlib-matrix/circuits/matSub.circom";
include "../../node_modules/circomlib-matrix/circuits/matElemSum.circom";
template SystemOfEquations(n) { // n is the number of variables in the system of equations
    signal input x[n]; // this is the solution to the system of equations
    signal input A[n][n]; // this is the coefficient matrix
    signal input b[n]; // this are the constants in the system of equations
    signal output out; // 1 for correct solution, 0 for incorrect solution

    // [bonus] insert your code here
    component matMultip = matMul(n, n, 1);

    for(var i=0; i<n; i++){
        for(var j=0; j<n; j++){
            matMultip.a[i][j] <== A[i][j];
        }
        matMultip.b[i][0] <== x[i];
    }

   component matSubs = matSub(3,1);

   
   for(var i=0; i<n; i++){
        
        matSubs.a[i][0] <== matMultip.out[i][0];
        matSubs.b[i][0] <== b[i];
        
   }
    
   component matrixSum = matElemSum(n, 1);
   for(var i=0; i<n; i++){
        
        matrixSum.a[i][0] <== matSubs.out[i][0];
        
   }

   component isZero = IsZero();
   isZero.in <== matrixSum.out;

   out  <== isZero.out;
}

component main {public [A, b]} = SystemOfEquations(3);