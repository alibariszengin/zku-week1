const fs = require("fs");
const solidityRegex = /pragma solidity \^\d+\.\d+\.\d+/

const verifierRegex = /contract Verifier/

let content = fs.readFileSync("./contracts/HelloWorldVerifier.sol", { encoding: 'utf-8' });
let bumped = content.replace(solidityRegex, 'pragma solidity ^0.8.0');
bumped = bumped.replace(verifierRegex, 'contract HelloWorldVerifier');

fs.writeFileSync("./contracts/HelloWorldVerifier.sol", bumped);

// [assignment] add your own scripts below to modify the other verifier contracts you will build during the assignment

let contentGroth = fs.readFileSync("./contracts/Multiplier3Groth-Verifier.sol", { encoding: 'utf-8' });
let bumpedGroth = contentGroth.replace(solidityRegex, 'pragma solidity ^0.8.0');
bumpedGroth = bumpedGroth.replace(verifierRegex, 'contract Multiplier3GrothVerifier');

fs.writeFileSync("./contracts/Multiplier3Groth-Verifier.sol", bumpedGroth);

let content_plonk = fs.readFileSync("./contracts/Multiplier3_plonk-Verifier.sol", { encoding: 'utf-8' });
let bumped_plonk = content_plonk.replace(solidityRegex, 'pragma solidity ^0.8.0');
bumped_plonk = bumped_plonk.replace(verifierRegex, 'contract PlonkVerifier');

fs.writeFileSync("./contracts/Multiplier3_plonk-Verifier.sol", bumped_plonk);