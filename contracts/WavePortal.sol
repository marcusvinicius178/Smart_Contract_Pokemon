// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    
    uint256 totalUsers;
    uint256 private seed;
    
    event NewJoin(address indexed from, uint256 timestamp, string message);
    
    struct Join {
        address joiner; // Endereço do usuário que juntou no pokemon journey
        string message; // Mensagem que o usuário envio
        uint256 timestamp; // Data/hora de quando o usuário ingressou
        
    }
    
    Join[] joiners;

        /*
     * Este é um endereço => uint mapping, o que significa que eu posso associar o endereço com um número!
     * Neste caso, armazenarei o endereço com o últimoo horário que o usuário tchauzinhou.
     */
    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("Contract built");
        /*
         * Define a semente inicial
         */
        seed = (block.timestamp + block.difficulty) % 100;
    }
    
    function getNewUsers(string memory _message) public {
        /*
         * Precisamos garantir que o valor corrente de timestamp é ao menos 15 minutos maior que o último timestamp armazenado
         */
        require(
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            "Espere 15m"
        );

        /*
         * Atualiza o timestamp atual do usuário
         */
        lastWavedAt[msg.sender] = block.timestamp;

    	totalUsers +=1;
    	console.log("%s has joined PokeFanatics! Sent a message %s", msg.sender, _message);
    	
    	joiners.push(Join(msg.sender, _message, block.timestamp));
        
        /*
         * Gera uma nova semente para o próximo usuário que acenar
         */
        seed = (block.difficulty + block.timestamp + seed) % 100;

        if (seed <= 50) {
            console.log("%s Won!", msg.sender);

            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to get more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Falhou em sacar dinheiro do contrato.");
        }
    	
    	emit NewJoin(msg.sender, block.timestamp, _message);

    }
    
    function getAllJoiners() public view returns (Join[] memory) {
    	return joiners;
    }

    function getTotalNewUsers() public view returns (uint256) {
    	console.log("We have a total of %d of PokeFanatic users", totalUsers);
    	return totalUsers;
    }
}
