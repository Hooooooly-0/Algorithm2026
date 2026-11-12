void setup() {
  size(400, 400); // 프로세싱 실행을 위한 최소한의 창 (시각적 그리드는 그리1지 않음)
  
  int n = 4; // 기본 n값 지정
  int[][] grid = new int[3][n];
  
  println("랜덤으로 생성된 3 x " + n + " 배열 (값 범위: -10 ~ 9 정수):");
  
  // 1. 배열을 random(-10, 10) 정수로 채우기
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < n; j++) {
      grid[i][j] = (int)random(-10, 10);
    }
  }
  
  // 2. 생성된 배열 출력
  printGrid(grid);
  
  // 3. DP를 이용한 최대 가중치 계산 및 출력
  solvePebbleDP(grid, n);
}

// 배열을 보기 좋게 출력하는 함수
void printGrid(int[][] grid) {
  int rows = grid.length;
  int cols = grid[0].length;
  
  for (int i = 0; i < rows; i++) {
    print("[ ");
    for (int j = 0; j < cols; j++) {
      print(nf(grid[i][j], 3) + " "); // 자릿수를 맞춰 예쁘게 출력
    }
    println(" ]");
  }
  println();
}

// 3 x n 조약돌 문제 동적 프로그래밍 해결 함수
void solvePebbleDP(int[][] grid, int n) {
  // 3행에서 선택할 수 있는 유효한 패턴 (행 인덱스 기준)
  // 비트마스크 또는 인덱스 조합으로 표현: 
  // 0: 아무것도 안 고름
  // 1: 0번 행 선택
  // 2: 1번 행 선택
  // 3: 2번 행 선택
  // 4: 0번, 2번 행 동시 선택 (서로 인접하지 않으므로 가능)
  
  // 각 패턴별 행 조합 정의 (0-indexed)
  int[][] patterns = {
    {},       // 0: 선택 없음
    {0},      // 1: 첫 번째 행
    {1},      // 2: 두 번째 행
    {2},      // 3: 세 번째 행
    {0, 2}    // 4: 첫 번째와 세 번째 행 동시 선택
  };
  
  int numPatterns = patterns.length;
  
  // dp[j][p]: j번째 열에서 p번째 패턴을 선택했을 때의 최대 누적 가중치
  int[][] dp = new int[n][numPatterns];
  
  // 첫 번째 열(j = 0) 초기화
  for (int p = 0; p < numPatterns; p++) {
    int sum = 0;
    for (int row : patterns[p]) {
      sum += grid[row][0];
    }
    dp[0][p] = sum;
  }
  
  // 두 번째 열부터 마지막 열까지 DP 테이블 채우기
  for (int j = 1; j < n; j++) {
    for (int p = 0; p < numPatterns; p++) {
      // 현재 열(j)에서 p번째 패턴을 선택했을 때의 조약돌 가중치 합
      int currentVal = 0;
      for (int row : patterns[p]) {
        currentVal += grid[row][j];
      }
      
      int maxPrev = -999999;
      
      // 이전 열(j-1)에서 올 수 있는 호환 가능한 패턴 찾기
      // 조건: 가로로 인접한 칸에 동시에 조약돌을 놓을 수 없음
      for (int prevP = 0; prevP < numPatterns; prevP++) {
        if (isCompatible(patterns[p], patterns[prevP])) {
          if (dp[j - 1][prevP] > maxPrev) {
            maxPrev = dp[j - 1][prevP];
          }
        }
      }
      
      dp[j][p] = currentVal + maxPrev;
    }
  }
  
  // 마지막 열에서 얻을 수 있는 최대값 찾기
  int maxTotal = -999999;
  for (int p = 0; p < numPatterns; p++) {
    if (dp[n - 1][p] > maxTotal) {
      maxTotal = dp[n - 1][p];
    }
  }
  
  println("=== 결과 ===");
  println("조약돌 배치로 얻을 수 있는 최대 가중치 합: " + maxTotal);
}

// 두 패턴이 가로 방향으로 인접해 충돌하는지 검사 (겹치는 행이 있으면 안 됨)
boolean isCompatible(int[] p1, int[] p2) {
  for (int r1 : p1) {
    for (int r2 : p2) {
      if (r1 == r2) {
        return false; // 같은 행을 동시에 선택했으므로 충돌 발생
      }
    }
  }
  return true;
}
