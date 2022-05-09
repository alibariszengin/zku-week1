#!/bin/bash

cd contracts/circuits

mkdir RangeProof

if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "powersOfTau28_hez_final_10.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_10.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

echo "Compiling RangeProof.circom..."

# compile circuit

circom RangeProof.circom --r1cs --wasm --sym -o RangeProof
snarkjs r1cs info RangeProof/RangeProof.r1cs

# Start a new zkey and make a contribution

snarkjs groth16 setup RangeProof/RangeProof.r1cs powersOfTau28_hez_final_10.ptau RangeProof/circuit_0000.zkey
snarkjs zkey contribute RangeProof/circuit_0000.zkey RangeProof/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey RangeProof/circuit_final.zkey RangeProof/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier RangeProof/circuit_final.zkey ../RangeProof.sol

cd RangeProof
node RangeProof_js/generate_witness.js RangeProof_js/RangeProof.wasm ./input.json ./output.wtns
snarkjs groth16 prove ./circuit_final.zkey ./output.wtns ./proof.json ./public.json
snarkjs groth16 verify verification_key.json public.json proof.json

cd ../..

cmd /k