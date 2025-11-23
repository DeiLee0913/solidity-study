const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SOLID Calculator System", function () {
  let calculator;
  let resultStore;
  let adder;

  // 모든 테스트 케이스 실행 전에 배포를 새로 수행합니다.
  beforeEach(async function () {
    // 1. 의존성 컨트랙트 배포 (Adder, ResultStorage)
    const AdderFactory = await ethers.getContractFactory("Adder");
    adder = await AdderFactory.deploy();

    const ResultStoreFactory = await ethers.getContractFactory("ResultStorage");
    resultStore = await ResultStoreFactory.deploy();

    // 2. 메인 컨트랙트 배포 (Dependency Injection)
    // 생성자에 Adder와 Store의 주소를 넘겨줍니다.
    const CalculatorFactory = await ethers.getContractFactory("Calculator");
    calculator = await CalculatorFactory.deploy(
      await resultStore.getAddress(), 
      await adder.getAddress()
    );
  });

  describe("1. 기본 연산 (Pure Calculation)", function () {
    it("기본 쉼표(,) 구분자로 덧셈이 가능해야 한다", async function () {
      const input = "1,2,3";
      // calculate는 view 함수이므로 가스비 없이 결과만 즉시 리턴
      const result = await calculator.calculate(input);
      expect(result).to.equal(6);
    });

    it("기본 세미콜론(;) 구분자로 덧셈이 가능해야 한다", async function () {
      const input = "1;2;3";
      const result = await calculator.calculate(input);
      expect(result).to.equal(6);
    });

    it("쉼표와 세미콜론이 섞여 있어도 동작해야 한다", async function () {
      const input = "1,2;3";
      const result = await calculator.calculate(input);
      expect(result).to.equal(6);
    });

    it("빈 문자열이 입력되면 0을 반환해야 한다", async function () {
      const result = await calculator.calculate("");
      expect(result).to.equal(0);
    });
  });

  describe("2. 커스텀 구분자 (Custom Delimiter)", function () {
    it("커스텀 구분자(// + \\n)를 인식하고 계산해야 한다", async function () {
      // 주의: 자바스크립트 문자열에서 백슬래시는 두 번(\\) 써야 이스케이프 됩니다.
      // Solidity 입력: "//;\n1;2;3"
      const input = "//;\n1;2;3";
      const result = await calculator.calculate(input);
      expect(result).to.equal(6);
    });

    it("특수문자 커스텀 구분자도 처리해야 한다", async function () {
      const input = "//!@\n1!@2!@3";
      const result = await calculator.calculate(input);
      expect(result).to.equal(6);
    });
  });

  describe("3. 저장소 연동 (Integration with ResultStore)", function () {
    it("계산 후 결과가 ResultStore에 저장되어야 한다", async function () {
      const input = "10,20,30";
      
      // 1. 트랜잭션 실행 (calculateAndStore)
      const tx = await calculator.calculateAndStore(input);
      await tx.wait(); // 블록에 담길 때까지 대기

      // 2. Calculator를 통해 결과 조회
      const storedValue = await calculator.getResult();
      expect(storedValue).to.equal(60);

      // 3. (검증 강화) ResultStore 컨트랙트에서 직접 조회해도 같은 값이어야 한다
      const directValue = await resultStore.getResult();
      expect(directValue).to.equal(60);
    });

    it("여러 번 계산 시 덮어쓰기가 되어야 한다", async function () {
      await calculator.calculateAndStore("1,1"); // 2
      await calculator.calculateAndStore("5,5"); // 10
      
      const finalValue = await calculator.getResult();
      expect(finalValue).to.equal(10);
    });
  });

  describe("4. 예외 처리 (Error Handling)", function () {
    it("숫자가 아닌 문자가 포함되면 revert 되어야 한다", async function () {
      // a는 숫자가 아니므로 _parseUint에서 에러 발생 예상
      await expect(
        calculator.calculate("1,2,a")
      ).to.be.revertedWith("IllegalArgumentException: Input token contains non-digit characters.");
    });

    it("커스텀 구분자 형식이 잘못되면(\\n 누락) revert 되어야 한다", async function () {
      // //로 시작했으나 \n이 없는 경우
      await expect(
        calculator.calculate("//;")
      ).to.be.revertedWith("Invalid input format for custom delimiter: '\\n' is missing.");
    });
  });
});