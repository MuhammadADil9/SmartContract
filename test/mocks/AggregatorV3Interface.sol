//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract MockV3{
    uint256 public constant version = 4;

    uint256 public decimals;
    int256 public latestAnswer;
    uint256 public latestTimestamp;
    uint256 public latestRound;

    mapping(uint256 => int256) public getAnswer;
    mapping(uint256 => uint256) public getTimestamp;
    mapping(uint256 => uint256 )private getStartedAt;

constructor(uint256 decimal,int256 initialAnswer){
    decimals = decimal;
    updateAnswer(initialAnswer);
}

function updateAnswer(int256 initial) public{
    latestAnswer = initial;
    latestTimestamp = block.timestamp;
    latestRound++;
    getAnswer[latestRound]=initial;
    getTimestamp[latestRound] = block.timestamp;
    getStartedAt[latestRound]=block.timestamp;    
} 

function updateRoundData(
    uint256 roundID,
    int256 answer,
    uint256 timestamp,
    uint256 startedat
)public{
    latestRound = roundID;
    latestAnswer = answer;
    latestTimestamp = timestamp;
    getAnswer[latestRound]=answer;
    getTimestamp[latestRound] = timestamp;
    getStartedAt[latestRound] = startedat; 
}

function latestRoundData()
external view returns(
    uint256 roundId,
    int256 answer,
    uint256 startedAt,
    uint256 updatedAt,
    uint256 answeredRound

){
    return(
        latestRound,
        getAnswer[latestRound],
        getStartedAt[latestRound],
        getTimestamp[latestRound],
        latestRound
    );
}

}
