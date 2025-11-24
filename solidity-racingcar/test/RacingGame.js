// test/racingGame.js

const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("CarRacingGame Functionality", function () {
    let CarRacingGame;
    let RandomMoveLogic;
    let BlockNumberMoveLogicFactory;
    let carRacingGame;
    let randomMoveLogic;

    // 테스트 환경 설정 (각 테스트 케이스 실행 전에 실행됨)
    beforeEach(async function () {
        // 1. Logic Contracts 가져오기
        RandomMoveLogic = await ethers.getContractFactory("RandomMoveLogic");
        BlockNumberMoveLogicFactory = await ethers.getContractFactory("BlockNumberMoveLogic"); 

        // 2. RandomMoveLogic 배포 및 주입용 주소 확보
        randomMoveLogic = await RandomMoveLogic.deploy();
        const randomLogicAddress = await randomMoveLogic.getAddress();
        
        // 3. Main Contract 가져오기 및 주소 주입하여 배포
        CarRacingGame = await ethers.getContractFactory("CarRacingGame");
        carRacingGame = await CarRacingGame.deploy(randomLogicAddress);
        await carRacingGame.waitForDeployment();
    });

    describe("ValidationLibrary Constraints", function () {
        const VALID_NAMES = ["pobi", "woni", "jun"];
        const VALID_TRY_COUNT = 5;

        // NameValidatorTest
        
        it("NameValidatorTest: 모든 이름이 5자 이하일 때 통과한다.", async function () {
            await expect(carRacingGame.startRace(VALID_NAMES, VALID_TRY_COUNT))
                .to.not.be.reverted; 
        });

        it("NameValidatorTest: 이름이 6자 이상이면 예외가 발생한다.", async function () {
            const longNames = ["pobi", "sixname"];
            await expect(carRacingGame.startRace(longNames, VALID_TRY_COUNT))
                .to.be.revertedWith("Name cannot exceed 5 characters");
        });

        it("NameValidatorTest: 이름이 중복될 경우 예외가 발생한다.", async function () {
            const duplicateNames = ["pobi", "woni", "pobi"];
            await expect(carRacingGame.startRace(duplicateNames, VALID_TRY_COUNT))
                .to.be.revertedWith("Duplicate car name found");
        });

        it("NameValidatorTest: 자동차 이름은 10개까지 가능하며, 11개는 예외를 발생시킨다.", async function () {
            const tooManyNames = ["a1", "a2", "a3", "a4", "a5", "a6", "a7", "a8", "a9", "a10", "a11"]; 
            const validNames = ["b1", "b2", "b3", "b4", "b5", "b6", "b7", "b8", "b9", "b10"];

            await expect(carRacingGame.startRace(validNames, VALID_TRY_COUNT))
                .to.not.be.reverted;

            await expect(carRacingGame.startRace(tooManyNames, VALID_TRY_COUNT))
                .to.be.revertedWith("Car count cannot exceed 10");
        });

        it("NameValidatorTest: 유효한 이름이 하나도 없는 경우 (1개만 입력된 경우) 예외가 발생한다.", async function () {
            const oneName = ["pobi"];
            const noName = []; 

            await expect(carRacingGame.startRace(oneName, VALID_TRY_COUNT))
                .to.be.revertedWith("At least 2 cars are required");

            await expect(carRacingGame.startRace(noName, VALID_TRY_COUNT))
                .to.be.revertedWith("At least 2 cars are required");
        });

        // TryCountValidatorTest
        
        it("TryCountValidatorTest: 0 입력 시 예외가 발생한다.", async function () {
            await expect(carRacingGame.startRace(VALID_NAMES, 0))
                .to.be.revertedWith("Try count must be greater than 0");
        });
    });

    describe("Race Logic and Winner Determination", function () {
        let deterministicGame;
        
        beforeEach(async function () {
            // BlockNumberMoveLogic을 팩토리 변수로 사용
            const blockNumberLogic = await BlockNumberMoveLogicFactory.deploy();
            const blockNumberLogicAddress = await blockNumberLogic.getAddress();
            
            const deployedTx = await CarRacingGame.deploy(blockNumberLogicAddress);
            await deployedTx.waitForDeployment();
            
            deterministicGame = await ethers.getContractAt(
                "CarRacingGame", 
                blockNumberLogicAddress 
            );
            // NOTE: CarRacingGame의 주소를 사용(배포 순서 준수 확인) 
            const deployedGameAddress = await deployedTx.getAddress();
            
            deterministicGame = await ethers.getContractAt(
                "CarRacingGame", 
                deployedGameAddress
            );    
            });

        it("결정론적 로직 사용 시 모든 차가 동일하게 움직여 공동 우승한다.", async function () {
            // BlockNumberMoveLogic: 블록 번호가 짝수일 때만 전진
            const names = ["fast", "slow"];
            const tryCount = 4;
            
            // 모든 차가 동일하게 움직였으므로 공동 우승해야 함
            const tx = await deterministicGame.startRace(names, tryCount);
            const receipt = await tx.wait(); // 트랜잭션이 채굴될 때까지 대기

            // startRace 함수는 string memory를 반환
            const decodedResult = deterministicGame.interface.decodeFunctionResult("startRace", receipt.data)[0];

            expect(result).to.be.equal("fast, slow");
        });
    });
});