// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Define a interface para um token ERC20
interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    // Eventos para Transferência e Aprovação
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// Implementa a interface do token ERC20
contract DIOCoin is IERC20 {
    // Nome do token
    string public constant name = "DIO Coin";
    // Símbolo do token
    string public constant symbol = "DIO";
    // Casas decimais usadas pelo token
    uint8 public constant decimals = 18;

    // Mapeamento de endereços para seus respectivos saldos
    mapping (address => uint256) balances;

    // Mapeamento de permissões de transferência de tokens
    mapping (address => mapping (address => uint256)) allowed;

    // Quantidade total de tokens emitidos
    uint256 totalSupply_ = 10 ether;

    // Construtor que atribui todo o fornecimento inicial ao criador do contrato
    constructor() {
        balances[msg.sender] = totalSupply_;
    }

    // Função que retorna o total de tokens emitidos
    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    // Função que retorna o saldo de um proprietário de token
    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    // Função para transferir tokens para um endereço específico
    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= numTokens;
        balances[receiver] += numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    // Função para aprovar um endereço para gastar um número específico de tokens
    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    // Função que retorna o número de tokens que um proprietário permitiu a um delegado gastar
    function allowance(address owner, address delegate) public override view returns (uint256) {
        return allowed[owner][delegate];
    }

    // Função para transferir tokens de um endereço para outro, desde que a permissão tenha sido concedida
    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner], "Insufficient balance");
        require(numTokens <= allowed[owner][msg.sender], "Allowance exceeded");

        balances[owner] -= numTokens;
        allowed[owner][msg.sender] -= numTokens;
        balances[buyer] += numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}
