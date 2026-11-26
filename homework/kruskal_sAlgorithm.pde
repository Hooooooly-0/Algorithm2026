import java.util.Collections;
import java.util.ArrayList;

int numNodes = 12;          // 정점(노드)의 개수
ArrayList<Node> nodes;      // 정점 리스트
ArrayList<Edge> edges;      // 모든 간선 리스트
ArrayList<Edge> mstEdges;   // MST에 포함된 간선 리스트

int[] parent;               // Union-Find용 부모 배열
int currentEdgeIndex = 0;   // 현재 검사 중인 간선 인덱스
Edge checkingEdge = null;   // 현재 화면에 강조 표시할 간선
boolean isComplete = false; // 알고리즘 완료 여부
int totalWeight = 0;        // MST 총 가중치

void setup() {
  size(800, 600);
  textAlign(CENTER, CENTER);

  // 시스템 폰트 중 한글 지원 폰트 자동 선택
  String[] fontList = PFont.list();
  String koreanFontName = null;
  String[] candidates = {"Malgun Gothic", "AppleGothic", "NanumGothic", "Noto Sans KR", "Gulim", "Dotum"};

  for (String cand : candidates) {
    for (String f : fontList) {
      if (f.equalsIgnoreCase(cand)) {
        koreanFontName = f;
        break;
      }
    }
    if (koreanFontName != null) break;
  }

  if (koreanFontName != null) {
    PFont font = createFont(koreanFontName, 16, true);
    textFont(font);
  }

  initGraph();
}

// 그래프 초기화 및 랜덤 생성
void initGraph() {
  nodes = new ArrayList<Node>();
  edges = new ArrayList<Edge>();
  mstEdges = new ArrayList<Edge>();
  currentEdgeIndex = 0;
  checkingEdge = null;
  isComplete = false;
  totalWeight = 0;

  // 1. 겹치지 않게 랜덤한 위치에 정점 생성
  for (int i = 0; i < numNodes; i++) {
    PVector pos;
    boolean valid;
    do {
      valid = true;
      pos = new PVector(random(80, width - 80), random(100, height - 80));
      for (Node n : nodes) {
        if (PVector.dist(pos, n.pos) < 90) { // 최소 거리 유지
          valid = false;
          break;
        }
      }
    } while (!valid);
    nodes.add(new Node(i, pos));
  }

  // 2. 적당한 거리의 정점끼리 연결하여 간선 생성 (가중치는 두 점 사이의 거리)
  for (int i = 0; i < numNodes; i++) {
    for (int j = i + 1; j < numNodes; j++) {
      float d = PVector.dist(nodes.get(i).pos, nodes.get(j).pos);
      if (d < 260) { // 연결 최대 거리 제한
        int weight = int(d / 10); // 보기 편하도록 거리를 10으로 나눈 정수 가중치
        edges.add(new Edge(nodes.get(i), nodes.get(j), weight));
      }
    }
  }

  // 모든 정점이 최소 1개 이상의 간선을 가지도록 보장 (고립 노드 방지)
  for (int i = 0; i < numNodes; i++) {
    boolean hasEdge = false;
    for (Edge e : edges) {
      if (e.u.id == i || e.v.id == i) {
        hasEdge = true;
        break;
      }
    }
    if (!hasEdge) {
      // 가장 가까운 정점과 강제 연결
      Node closest = null;
      float minDist = Float.MAX_VALUE;
      for (int j = 0; j < numNodes; j++) {
        if (i == j) continue;
        float d = PVector.dist(nodes.get(i).pos, nodes.get(j).pos);
        if (d < minDist) {
          minDist = d;
          closest = nodes.get(j);
        }
      }
      edges.add(new Edge(nodes.get(i), closest, int(minDist / 10)));
    }
  }

  // 3. 크루스칼 알고리즘 핵심: 간선을 가중치 오름차순으로 정렬
  Collections.sort(edges);

  // 4. Union-Find 배열 초기화
  parent = new int[numNodes];
  for (int i = 0; i < numNodes; i++) {
    parent[i] = i;
  }
}

void draw() {
  background(30, 34, 42);

  // 1. 기본 전체 간선 그리기 (회색)
  for (Edge e : edges) {
    e.display(color(80, 85, 95), 1.5, true);
  }

  // 2. MST에 선택된 간선 그리기 (초록색)
  for (Edge e : mstEdges) {
    e.display(color(46, 204, 113), 4, false);
  }

  // 3. 현재 검사 중인 간선 강조 (노란색: 선택됨 / 빨간색: 사이클 발생으로 기각)
  if (checkingEdge != null && !isComplete) {
    if (checkingEdge.accepted) {
      checkingEdge.display(color(241, 196, 15), 5, false);
    } else {
      checkingEdge.display(color(231, 76, 60), 3, false);
    }
  }

  // 4. 정점(노드) 그리기
  for (Node n : nodes) {
    n.display();
  }

  // 5. 상단 UI 텍스트 표시
  drawUI();
}

void drawUI() {
  fill(255);
  textAlign(LEFT, TOP);
  textSize(16);
  text("Kruskal's Algorithm (Minimum Spanning Tree)", 20, 20);
  
  textSize(13);
  fill(200);
  text("[Click / Space]: 다음 단계 진행   |   [R]: 새 랜덤 그래프 생성   |   [A]: 자동 완료", 20, 48);

  textAlign(RIGHT, TOP);
  textSize(15);
  if (isComplete) {
    fill(46, 204, 113);
    text("완료! 총 가중치(Total Weight): " + totalWeight, width - 20, 20);
  } else {
    fill(241, 196, 15);
    text("진행 중... 현재 MST 가중치: " + totalWeight + " (" + mstEdges.size() + "/" + (numNodes - 1) + ")", width - 20, 20);
  }
  textAlign(CENTER, CENTER); // 원상복구
}

// 크루스칼 알고리즘 한 단계 실행
void stepKruskal() {
  if (isComplete) return;

  // 간선을 모두 확인했거나, (정점 수 - 1)개의 간선을 찾으면 종료
  if (currentEdgeIndex >= edges.size() || mstEdges.size() == numNodes - 1) {
    isComplete = true;
    checkingEdge = null;
    return;
  }

  checkingEdge = edges.get(currentEdgeIndex);
  currentEdgeIndex++;

  int rootU = find(checkingEdge.u.id);
  int rootV = find(checkingEdge.v.id);

  // 두 정점의 루트가 다르면 사이클이 생기지 않으므로 MST에 추가
  if (rootU != rootV) {
    union(rootU, rootV);
    mstEdges.add(checkingEdge);
    totalWeight += checkingEdge.weight;
    checkingEdge.accepted = true;
  } else {
    // 사이클이 발생하므로 버림
    checkingEdge.accepted = false;
  }

  // 방금 추가한 간선으로 MST가 완성되었는지 체크
  if (mstEdges.size() == numNodes - 1) {
    isComplete = true;
  }
}

// Union-Find: 루트 노드 찾기
int find(int i) {
  if (parent[i] == i) return i;
  return parent[i] = find(parent[i]); // 경로 압축
}

// Union-Find: 두 집합 합치기
void union(int root1, int root2) {
  parent[root1] = root2;
}

// 마우스 클릭 시 한 단계 진행
void mousePressed() {
  stepKruskal();
}

// 키보드 조작
void keyPressed() {
  if (key == ' ') {
    stepKruskal();
  } else if (key == 'r' || key == 'R') {
    initGraph();
  } else if (key == 'a' || key == 'A') {
    while (!isComplete) {
      stepKruskal();
    }
  }
}

// ==========================================
// 클래스 정의 (Node, Edge)
// ==========================================

class Node {
  int id;
  PVector pos;

  Node(int id, PVector pos) {
    this.id = id;
    this.pos = pos;
  }

  void display() {
    stroke(255);
    strokeWeight(2);
    fill(52, 152, 219);
    ellipse(pos.x, pos.y, 32, 32);

    fill(255);
    textSize(13);
    text(id, pos.x, pos.y - 1);
  }
}

class Edge implements Comparable<Edge> {
  Node u, v;
  int weight;
  boolean accepted = false;

  Edge(Node u, Node v, int weight) {
    this.u = u;
    this.v = v;
    this.weight = weight;
  }

  void display(color c, float weightStroke, boolean showWeight) {
    stroke(c);
    strokeWeight(weightStroke);
    line(u.pos.x, u.pos.y, v.pos.x, v.pos.y);

    if (showWeight) {
      float midX = (u.pos.x + v.pos.x) / 2;
      float midY = (u.pos.y + v.pos.y) / 2;
      
      // 가중치 숫자 배경 박스 (가독성용)
      noStroke();
      fill(30, 34, 42, 220);
      rectMode(CENTER);
      rect(midX, midY, 22, 16, 4);

      fill(180);
      textSize(11);
      text(weight, midX, midY - 1);
    }
  }

  // 가중치 기준 오름차순 정렬을 위한 비교 메서드
  @Override
  int compareTo(Edge other) {
    return this.weight - other.weight;
  }
}
