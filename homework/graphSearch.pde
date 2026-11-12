import java.util.*;

// 노드(정점) 클래스 정의
class Node {
  int id;
  float x, y;
  ArrayList<Node> neighbors;
  boolean visited;
  
  Node(int id, float x, float y) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.neighbors = new ArrayList<Node>();
    this.visited = false;
  }
}

ArrayList<Node> nodes;
ArrayList<Edge> edges;

// 간선 클래스 정의 (탐색 상태 추가)
class Edge {
  Node a, b;
  boolean isTraversed = false; 
  boolean isCurrent = false;   
  
  Edge(Node a, Node b) {
    this.a = a;
    this.b = b;
  }
}

// 탐색 제어 변수 (기본 스탠스: CUSTOM)
String algorithm = "BFS"; 
String mode = "CUSTOM";   
boolean isSearching = false; // 탐색 진행 중 여부
boolean isFinished = false;  // 탐색 완료 여부

// BFS용 큐, DFS용 스택, 방문 순서 기록 리스트
ArrayList<Node> bfsQueue;
ArrayList<Node> dfsStack;
ArrayList<Integer> visitOrder;
Node currentNode = null;

// 폰트 객체 선언
PFont koreanFont;

void setup() {
  size(800, 680);
  
  // 운영체제별 한글 폰트 설정 (Windows: 맑은 고딕, Mac: AppleGothic 등)
  koreanFont = createFont("Malgun Gothic", 16);
  textFont(koreanFont);
  
  textAlign(CENTER, CENTER);
  generateGraph();
}

void draw() {
  background(30, 30, 40);
  
  // 1. 간선(엣지) 그리기 (상태에 따라 색상 다르게 표시)
  for (Edge e : edges) {
    if (e.isCurrent) {
      stroke(255, 120, 50); // 현재 탐색 중인 간선: 주황/빨간색
      strokeWeight(4);
    } else if (e.isTraversed) {
      stroke(100, 200, 100); // 방문 완료된 정점들을 잇는 간선: 초록색
      strokeWeight(2);
    } else {
      stroke(100, 100, 120); // 미방문 간선: 기본 회색
      strokeWeight(2);
    }
    line(e.a.x, e.a.y, e.b.x, e.b.y);
  }
  
  // 2. 노드(정점) 그리기
  noStroke();
  for (Node n : nodes) {
    if (n == currentNode) {
      fill(255, 100, 100); // 현재 방문 중인 노드: 빨간색
      stroke(255, 200, 200);
      strokeWeight(3);
    } else if (n.visited) {
      fill(100, 200, 100); // 방문 완료된 노드: 초록색
      noStroke();
    } else {
      fill(70, 130, 180); // 미방문 노드: 파란색
      noStroke();
    }
    
    ellipse(n.x, n.y, 40, 40);
    
    fill(255);
    noStroke();
    textSize(14);
    text(n.id, n.x, n.y);
  }
  
  // 3. 탐색 진행 (애니메이션 효과 - isSearching이 true일 때만 동작)
  if (isSearching && frameCount % 30 == 0) {
    stepSearch();
  }
  
  // 4. 상단 안내 텍스트 출력
  fill(255);
  textAlign(LEFT, CENTER);
  textSize(16);
  text("현재 알고리즘: " + algorithm + "  |  모드: " + mode, 30, 30);
  
  // 5. 하단 방문 순서 및 조작법 출력
  textAlign(CENTER, CENTER);
  textSize(13);
  
  String orderStr = "방문 순서: ";
  for (int i = 0; i < visitOrder.size(); i++) {
    orderStr += visitOrder.get(i);
    if (i < visitOrder.size() - 1) {
      orderStr += " -> ";
    }
  }
  text(orderStr, width / 2, height - 90);
  
  // 안내 문구 출력 (상태에 따라 문구 변경)
  fill(255, 200, 100);
  if (isFinished) {
    text("[P] 탐색 완료! 다시 재생하려면 P를 누르세요", width / 2, height - 60);
  } else if (isSearching) {
    text("[P] 탐색 재생 중...", width / 2, height - 60);
  } else {
    text("[P] 탐색 재생 시작", width / 2, height - 60);
  }
  
  fill(180, 180, 200);
  text("[스페이스바] BFS / DFS 전환   |   [R] 랜덤 그래프 모드로 전환", width / 2, height - 35);
  text("[C] 직접 입력(Custom) 그래프 새로고침", width / 2, height - 12);
}

// 키 입력 이벤트
void keyPressed() {
  if (key == 'p' || key == 'P') {
    if (isFinished) {
      // 탐색이 끝난 상태에서 P를 누르면 초기화 후 다시 재생
      resetSearch();
      isSearching = true;
    } else {
      isSearching = true; // 대기 상태에서 P를 누르면 탐색 시작
    }
  } else if (key == 'r' || key == 'R') {
    mode = "RANDOM";
    generateGraph();
  } else if (key == 'c' || key == 'C') {
    mode = "CUSTOM";
    generateGraph();
  } else if (key == ' ') {
    if (algorithm.equals("BFS")) {
      algorithm = "DFS";
    } else {
      algorithm = "BFS";
    }
    resetSearch();
  }
}

// 그래프 생성 관리 함수
void generateGraph() {
  nodes = new ArrayList<Node>();
  edges = new ArrayList<Edge>();
  
  if (mode.equals("RANDOM")) {
    generateRandomGraph();
  } else if (mode.equals("CUSTOM")) {
    generateCustomGraph();
  }
  
  resetSearch();
}

// 1. 랜덤 그래프 생성 함수
void generateRandomGraph() {
  int numNodes = int(random(6, 11)); // 6~10개의 노드 생성
  float centerX = width / 2;
  float centerY = height / 2 - 20;
  float radius = 180;
  
  for (int i = 0; i < numNodes; i++) {
    float angle = map(i, 0, numNodes, 0, TWO_PI) + random(-0.2, 0.2);
    float r = radius + random(-30, 30);
    float x = centerX + cos(angle) * r;
    float y = centerY + sin(angle) * r;
    nodes.add(new Node(i, x, y));
  }
  
  for (int i = 0; i < numNodes; i++) {
    int next = (i + 1) % numNodes;
    connectNodes(nodes.get(i), nodes.get(next));
    
    for (int j = i + 2; j < numNodes; j++) {
      if (random(1) < 0.4) {
        connectNodes(nodes.get(i), nodes.get(j));
      }
    }
  }
}

// 2. [직접 입력] 커스텀 그래프 생성 함수
void generateCustomGraph() {
  int[][] customEdges = {
    {0, 1},
    {0, 2},
    {1, 2},
    {2, 3},
    {2, 4}
  };
  
  int maxNodeId = 0;
  for (int i = 0; i < customEdges.length; i++) {
    if (customEdges[i][0] > maxNodeId) maxNodeId = customEdges[i][0];
    if (customEdges[i][1] > maxNodeId) maxNodeId = customEdges[i][1];
  }
  int numNodes = maxNodeId + 1;
  
  float centerX = width / 2;
  float centerY = height / 2 - 20;
  float radius = 160;
  
  for (int i = 0; i < numNodes; i++) {
    float angle = map(i, 0, numNodes, 0, TWO_PI);
    float x = centerX + cos(angle) * radius;
    float y = centerY + sin(angle) * radius;
    nodes.add(new Node(i, x, y));
  }
  
  for (int i = 0; i < customEdges.length; i++) {
    int u = customEdges[i][0];
    int v = customEdges[i][1];
    if (u < nodes.size() && v < nodes.size()) {
      connectNodes(nodes.get(u), nodes.get(v));
    }
  }
}

void connectNodes(Node a, Node b) {
  if (!a.neighbors.contains(b)) {
    a.neighbors.add(b);
    b.neighbors.add(a);
    edges.add(new Edge(a, b));
  }
}

// 간선 객체를 찾아 반환하는 헬퍼 함수
Edge findEdge(Node a, Node b) {
  for (Edge e : edges) {
    if ((e.a == a && e.b == b) || (e.a == b && e.b == a)) {
      return e;
    }
  }
  return null;
}

// 탐색 초기화
void resetSearch() {
  for (Node n : nodes) {
    n.visited = false;
  }
  for (Edge e : edges) {
    e.isTraversed = false;
    e.isCurrent = false;
  }
  
  bfsQueue = new ArrayList<Node>();
  dfsStack = new ArrayList<Node>();
  visitOrder = new ArrayList<Integer>();
  currentNode = null;
  
  if (nodes.size() > 0) {
    Node startNode = nodes.get(0);
    if (algorithm.equals("BFS")) {
      bfsQueue.add(startNode);
    } else {
      dfsStack.add(startNode);
    }
  }
  isSearching = false; 
  isFinished = false;  // 초기화 시 완료 상태도 해제
}

// 한 단계씩 탐색 진행
void stepSearch() {
  // 이전 단계의 '현재 탐색 중'인 간선 효과 초기화
  for (Edge e : edges) {
    e.isCurrent = false;
  }

  if (algorithm.equals("BFS")) {
    if (bfsQueue.isEmpty()) {
      isSearching = false;
      isFinished = true; // 탐색 완료 플래그 설정
      currentNode = null;
      return;
    }
    
    currentNode = bfsQueue.remove(0);
    if (!currentNode.visited) {
      currentNode.visited = true;
      visitOrder.add(currentNode.id);
      
      for (Node neighbor : currentNode.neighbors) {
        Edge e = findEdge(currentNode, neighbor);
        if (!neighbor.visited && !bfsQueue.contains(neighbor)) {
          bfsQueue.add(neighbor);
          if (e != null) {
            e.isCurrent = true;     
            e.isTraversed = true;
          }
        } else {
          if (e != null && neighbor.visited) {
            e.isTraversed = true;   
          }
        }
      }
    }
  } 
  else if (algorithm.equals("DFS")) {
    if (dfsStack.isEmpty()) {
      isSearching = false;
      isFinished = true; // 탐색 완료 플래그 설정
      currentNode = null;
      return;
    }
    
    currentNode = dfsStack.remove(dfsStack.size() - 1);
    if (!currentNode.visited) {
      currentNode.visited = true;
      visitOrder.add(currentNode.id);
      
      for (int i = currentNode.neighbors.size() - 1; i >= 0; i--) {
        Node neighbor = currentNode.neighbors.get(i);
        Edge e = findEdge(currentNode, neighbor);
        if (!neighbor.visited && !dfsStack.contains(neighbor)) {
          dfsStack.add(neighbor);
          if (e != null) {
            e.isCurrent = true;     
            e.isTraversed = true;
          }
        } else {
          if (e != null && neighbor.visited) {
            e.isTraversed = true;
          }
        }
      }
    }
  }
}
