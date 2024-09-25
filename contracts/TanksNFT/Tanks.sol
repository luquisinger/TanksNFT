// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// Importando o ERC721 da OpenZeppelin
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Tanks is ERC721 {

    struct Tank {  // Renomeado para evitar conflito com o nome do contrato
        string name;
        uint level;
        string img;
    }

    Tank[] public tanks;
    address public gameOwner;

    constructor() ERC721("Tanks", "TK") {
        gameOwner = msg.sender;
    }

    modifier onlyOwner(uint _tankId) {
        require(ownerOf(_tankId) == msg.sender, "Apenas o dono pode batalhar com esse Tank");
        _;
    }

    function battle(uint _attackingTank, uint _defendingTank) public onlyOwner(_attackingTank) {
        Tank storage attacker = tanks[_attackingTank];
        Tank storage defender = tanks[_defendingTank];

        if (attacker.level >= defender.level) {
            attacker.level += 2;
            defender.level += 1;
        } else {
            attacker.level += 1;
            defender.level += 2;
        }
    }

    function createNewTank(string memory _name, address _to, string memory _img) public {
        require(msg.sender == gameOwner, "Apenas o dono pode mintar novos Tanks");
        uint id = tanks.length;  // Corrigido "lenght" para "length"
        tanks.push(Tank(_name, 1, _img));
        _safeMint(_to, id);
    }
}
