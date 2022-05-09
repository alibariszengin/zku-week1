#!/bin/bash

# [assignment] create your own bash script to compile Multipler3.circom using PLONK below

cd contracts/circuits
mkdir Multiplier3_plonk

if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "powersOfTau28_hez_final_10.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_10.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

echo "Compiling Multiplier3.circom..."
circom Multiplier3.circom --r1cs --wasm --sym -o Multiplier3_plonk
echo "circom done"
snarkjs r1cs info Multiplier3_plonk/Multiplier3.r1cs
echo "snarkjs done "
# Start a new zkey and make a contribution

snarkjs plonk setup Multiplier3_plonk/Multiplier3.r1cs powersOfTau28_hez_final_10.ptau Multiplier3_plonk/circuit_final.zkey
echo "contribute start"
#snarkjs zkey contribute Multiplier3_plonk/circuit_0000.zkey Multiplier3_plonk/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
echo "contribute done"
snarkjs zkey export verificationkey Multiplier3_plonk/circuit_final.zkey Multiplier3_plonk/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier Multiplier3_plonk/circuit_final.zkey ../Multiplier3_plonk-Verifier.sol
cd Multiplier3_plonk
node Multiplier3_js/generate_witness.js Multiplier3_js/Multiplier3.wasm ./input.json ./output.wtns
snarkjs plonk prove ./circuit_final.zkey ./output.wtns ./proof.json ./public.json
snarkjs plonk verify verification_key.json public.json proof.json
snarkjs zkey export soliditycalldata ./public.json ./proof.json > ./call.txt
cd ../..

cmd /k