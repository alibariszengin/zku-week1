const fs = require("fs");
const solidityRegex = /pragma solidity \^\d+\.\d+\.\d+/

const verifierRegex = /contract Verifier/

let content = fs.readFileSync("./contracts/SystemOfEquationsVerifier.sol", { encoding: 'utf-8' });
let bumped = content.replace(solidityRegex, 'pragma solidity ^0.8.0');
bumped = bumped.replace(verifierRegex, 'contract SystemOfEquationsVerifier');

fs.writeFileSync("./contracts/SystemOfEquationsVerifier.sol", bumped);

let contentLess = fs.readFileSync("./contracts/LessThan10.sol", { encoding: 'utf-8' });
let bumpedLess = contentLess.replace(solidityRegex, 'pragma solidity ^0.8.0');
bumpedLess = bumpedLess.replace(verifierRegex, 'contract LessThan10Verifier');

fs.writeFileSync("./contracts/LessThan10.sol", bumpedLess);

let contentRange = fs.readFileSync("./contracts/RangeProof.sol", { encoding: 'utf-8' });
let bumpedRange = contentRange.replace(solidityRegex, 'pragma solidity ^0.8.0');
bumpedRange = bumpedRange.replace(verifierRegex, 'contract RangeProofVerifier');

fs.writeFileSync("./contracts/RangeProof.sol", bumpedRange);