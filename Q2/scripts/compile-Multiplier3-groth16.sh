#!/bin/bash

# [assignment] create your own bash script to compile Multipler3.circom modeling after compile-HelloWorld.sh below
cd contracts/circuits
mkdir Multiplier3Groth

if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "powersOfTau28_hez_final_10.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_10.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

echo "Compiling Multiplier3.circom..."
circom Multiplier3.circom --r1cs --wasm --sym -o Multiplier3Groth
echo "circom done"
snarkjs r1cs info Multiplier3Groth/Multiplier3.r1cs
echo "snarkjs done "
# Start a new zkey and make a contribution

snarkjs groth16 setup Multiplier3Groth/Multiplier3.r1cs powersOfTau28_hez_final_10.ptau Multiplier3Groth/circuit_0000.zkey
snarkjs zkey contribute Multiplier3Groth/circuit_0000.zkey Multiplier3Groth/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey Multiplier3Groth/circuit_final.zkey Multiplier3Groth/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier Multiplier3Groth/circuit_final.zkey ../Multiplier3Groth-Verifier.sol

cd Multiplier3Groth
node Multiplier3_js/generate_witness.js Multiplier3_js/Multiplier3.wasm ./input.json ./output.wtns
snarkjs groth16 prove ./circuit_final.zkey ./output.wtns ./proof.json ./public.json
snarkjs groth16 verify verification_key.json public.json proof.json
snarkjs zkey export soliditycalldata ./public.json ./proof.json
cd ../..

cmd /k