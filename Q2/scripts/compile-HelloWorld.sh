#!/bin/bash

cd contracts/circuits

mkdir HelloWorld

if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "powersOfTau28_hez_final_10.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_10.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

echo "Compiling HelloWorld.circom..."

# compile circuit

circom HelloWorld.circom --r1cs --wasm --sym -o HelloWorld
snarkjs r1cs info HelloWorld/HelloWorld.r1cs

# Start a new zkey and make a contribution

snarkjs groth16 setup HelloWorld/HelloWorld.r1cs powersOfTau28_hez_final_10.ptau HelloWorld/circuit_0000.zkey
snarkjs zkey contribute HelloWorld/circuit_0000.zkey HelloWorld/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey HelloWorld/circuit_final.zkey HelloWorld/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier HelloWorld/circuit_final.zkey ../HelloWorldVerifier.sol

cd HelloWorld
#-node HelloWorld_js/generate_witness.js HelloWorld_js/HelloWorld.wasm ./input.json ./output.wtns
#node witness_calculator.js output.wtns ../input.json
#snarkjs proof --witness output.wtns --provingkey ../circuit_final.zkey
#-snarkjs groth16 prove ./circuit_final.zkey ./output.wtns ./proof.json ./public.json
#cd HelloWorld
#snarkjs calculatewitness --wasm HelloWorld_js/HelloWorld.wasm --input input.json

#-snarkjs groth16 verify verification_key.json public.json proof.json

cd ../..

cmd /k