import javax.swing.JOptionPane;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

// 단계별 정보를 저장하는 클래스
class StepInfo {
  String token;
  List<String> stackSnapshot;
  List<String> outputSnapshot;
  String actionDesc;
  
  StepInfo(String token, List<String> stack, List<String> output, String desc) {
    this.token = token;
    this.stackSnapshot = new ArrayList<>(stack);
    this.outputSnapshot = new ArrayList<>(output);
    this.actionDesc = desc;
  }
}

String infixExpr = "3 + 5 * ( 2 - 8 ) / 4";
List<StepInfo> steps = new ArrayList<>();
int currentStepIndex = 0;
float finalResult = 0;
boolean hasError = false;
String errorMessage = "";

PFont koreanFont;

void setup() {
  size(900, 650);
  surface.setTitle("Infix to Postfix Step-by-Step Stack Visualizer");
  
  koreanFont = createFont("Malgun Gothic", 16);
  textFont(koreanFont);
  
  processExpression(infixExpr);
}

void draw() {
  background(20, 20, 30);
  textFont(koreanFont);
  
  // 1. 타이틀 및 안내
  fill(255);
  textSize(22);
  textAlign(CENTER, TOP);
  text("Stack Visualizer: Infix to Postfix Conversion", width / 2, 20);
  
  textSize(14);
  fill(160, 180, 200);
  text("[RIGHT / SPACE]: 다음 단계   |   [LEFT]: 이전 단계   |   [ENTER / I]: 새로운 수식 입력", width / 2, 52);
  
  // 2. 현재 입력된 중위 수식 표시
  drawInfoBox(40, 90, width - 80, 50, "입력된 중위 수식 (Infix):", infixExpr, color(70, 130, 200));
  
  // 현재 단계 정보 가져오기
  if (steps.isEmpty()) return;
  StepInfo current = steps.get(currentStepIndex);
  
  // 3. 메인 시각화 영역 (좌: 스택 상태 / 우: 출력(Postfix) 및 설명)
  float midY = 160;
  float contentH = 340;
  
  // -- [좌측] 스택 시각화 박스 --
  float stackX = 40;
  float stackW = 320;
  drawPanel(stackX, midY, stackW, contentH, "스택 상태 (Stack - 바닥에서 꼭대기 순)");
  
  List<String> stk = current.stackSnapshot;
  float boxH = 40;
  float startY = midY + contentH - 60;
  for (int i = 0; i < stk.size(); i++) {
    float y = startY - (i * (boxH + 8));
    fill(90, 70, 180);
    stroke(140, 120, 240);
    strokeWeight(2);
    rect(stackX + 30, y, stackW - 60, boxH, 6);
    
    fill(255);
    textSize(18);
    textAlign(CENTER, CENTER);
    text(stk.get(i), stackX + stackW / 2, y + boxH / 2);
  }
  if (stk.isEmpty()) {
    fill(120);
    textSize(15);
    textAlign(CENTER, CENTER);
    text("(스택이 비어 있음)", stackX + stackW / 2, midY + contentH / 2);
  }
  
  // -- [우측] 현재 토큰, 출력 결과, 설명 박스 --
  float rightX = 380;
  float rightW = width - 420;
  drawPanel(rightX, midY, rightW, contentH, "시뮬레이션 진행 상황 및 출력");
  
  fill(200, 220, 255);
  textSize(15);
  textAlign(LEFT, TOP);
  text("현재 읽은 토큰 (Current Token):", rightX + 30, midY + 45);
  
  fill(255, 200, 80);
  textSize(22);
  text(current.token.isEmpty() ? "(시작 대기)" : current.token, rightX + 260, midY + 40);
  
  fill(200, 220, 255);
  textSize(15);
  text("동작 설명 (Action Description):", rightX + 30, midY + 95);
  
  // [수정됨] 텍스트가 박스를 넘어가지 않도록 너비와 높이를 지정하여 자동 줄 바꿈 적용
  fill(240);
  textSize(14);
  text(current.actionDesc, rightX + 30, midY + 125, rightW - 60, 60);
  
  // 후위 표기법 진행 상황
  fill(200, 220, 255);
  textSize(15);
  text("후위 표기법 변환 결과 (Postfix Output):", rightX + 30, midY + 205);
  
  fill(80, 220, 150);
  textSize(18);
  text(String.join(" ", current.outputSnapshot), rightX + 30, midY + 235);
  
  // 4. 하단 상태바 (진행 단계 표시)
  fill(40, 40, 55);
  noStroke();
  rect(40, 520, width - 80, 50, 8);
  
  fill(255);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("진행 단계: " + (currentStepIndex + 1) + " / " + steps.size() + 
       (currentStepIndex == steps.size() - 1 ? " [변환 완료]" : ""), width / 2, 545);
       
  // 최종 계산 결과 (모든 단계가 끝났을 때만)
  if (currentStepIndex == steps.size() - 1 && !hasError) {
    textSize(14);
    fill(180, 140, 255);
    textAlign(RIGHT, CENTER);
    text("계산 결과: " + nf(finalResult, 0, 4), width - 70, 545);
  }
}

// 키 입력 처리
void keyPressed() {
  if (keyCode == RIGHT || key == ' ') {
    if (currentStepIndex < steps.size() - 1) {
      currentStepIndex++;
    }
  } else if (keyCode == LEFT) {
    if (currentStepIndex > 0) {
      currentStepIndex--;
    }
  } else if (keyCode == ENTER || key == 'i' || key == 'I') {
    requestInput();
  }
}

// 사용자 입력 처리
void requestInput() {
  String input = JOptionPane.showInputDialog(null, 
    "새로운 중위 표기법 수식을 입력하세요:", 
    "Infix Calculator Input", 
    JOptionPane.QUESTION_MESSAGE);
    
  if (input != null && !input.trim().isEmpty()) {
    infixExpr = input;
    processExpression(infixExpr);
  }
}

// 수식 분석 및 단계별 스냅샷 생성
void processExpression(String infix) {
  hasError = false;
  steps.clear();
  currentStepIndex = 0;
  
  try {
    List<String> tokens = tokenize(infix);
    Stack<String> stack = new Stack<>();
    List<String> output = new ArrayList<>();
    
    steps.add(new StepInfo("-", stack, output, "변환 대기 중 (우측 화살표 [>] 키를 눌러 시작하세요)"));
    
    for (String token : tokens) {
      char c = token.charAt(0);
      
      if (Character.isDigit(c) || (token.length() > 1 && Character.isDigit(token.charAt(1)))) {
        output.add(token);
        steps.add(new StepInfo(token, stack, output, "숫자이므로 출력(Postfix) 리스트에 추가합니다."));
      } 
      else if (c == '(') {
        stack.push(token);
        steps.add(new StepInfo(token, stack, output, "여는 괄호 '(' 이므로 스택에 푸시합니다."));
      } 
      else if (c == ')') {
        while (!stack.isEmpty() && !stack.peek().equals("(")) {
          output.add(stack.pop());
        }
        if (!stack.isEmpty() && stack.peek().equals("(")) {
          stack.pop();
          steps.add(new StepInfo(token, stack, output, "닫는 괄호 ')'를 만나 '('가 나올 때까지 팝하여 출력에 추가합니다."));
        } else {
          throw new IllegalArgumentException("괄호 짝이 맞지 않습니다.");
        }
      } 
      else if (isOperator(c)) {
        while (!stack.isEmpty() && precedence(stack.peek().charAt(0)) >= precedence(c)) {
          output.add(stack.pop());
        }
        stack.push(token);
        steps.add(new StepInfo(token, stack, output, "연산자 '" + token + "'보다 우선순위가 높거나 같은 스택의 연산자들을 팝한 후 푸시합니다."));
      } else {
        throw new IllegalArgumentException("유효하지 않은 토큰: " + token);
      }
    }
    
    while (!stack.isEmpty()) {
      if (stack.peek().equals("(")) {
        throw new IllegalArgumentException("괄호 짝이 맞지 않습니다.");
      }
      output.add(stack.pop());
      steps.add(new StepInfo("(완료)", stack, output, "스택에 남은 잔여 연산자를 모두 팝하여 출력에 추가합니다."));
    }
    
    finalResult = evaluatePostfix(String.join(" ", output));
    
  } catch (Exception e) {
    hasError = true;
    errorMessage = e.getMessage();
    steps.add(new StepInfo("오류", new Stack<>(), new ArrayList<>(), "오류 발생: " + errorMessage));
  }
}

void drawPanel(float x, float y, float w, float h, String title) {
  fill(30, 30, 45);
  stroke(60, 60, 80);
  strokeWeight(2);
  rect(x, y, w, h, 8);
  
  fill(180, 200, 220);
  textSize(14);
  textAlign(LEFT, CENTER);
  text(title, x + 20, y + 22);
  
  stroke(60, 60, 80);
  line(x, y + 40, x + w, y + 40);
}

void drawInfoBox(float x, float y, float w, float h, String label, String val, color c) {
  fill(35, 35, 50);
  stroke(c);
  strokeWeight(2);
  rect(x, y, w, h, 8);
  
  noStroke();
  fill(c);
  rect(x, y, 10, h, 8, 0, 0, 8);
  
  textAlign(LEFT, CENTER);
  textSize(12);
  fill(150);
  text(label, x + 25, y + 16);
  
  textSize(16);
  fill(255);
  text(val, x + 25, y + 36);
}

List<String> tokenize(String s) {
  List<String> tokens = new ArrayList<>();
  String numBuf = "";
  for (int i = 0; i < s.length(); i++) {
    char c = s.charAt(i);
    if (Character.isWhitespace(c)) continue;
    if (Character.isDigit(c) || c == '.') {
      numBuf += c;
    } else {
      if (!numBuf.isEmpty()) {
        tokens.add(numBuf);
        numBuf = "";
      }
      tokens.add(String.valueOf(c));
    }
  }
  if (!numBuf.isEmpty()) tokens.add(numBuf);
  return tokens;
}

int precedence(char op) {
  if (op == '+' || op == '-') return 1;
  if (op == '*' || op == '/') return 2;
  return 0;
}

boolean isOperator(char c) {
  return c == '+' || c == '-' || c == '*' || c == '/';
}

float evaluatePostfix(String postfix) {
  if (postfix.isEmpty()) return 0;
  String[] tokens = postfix.split("\\s+");
  Stack<Float> stack = new Stack<>();
  for (String token : tokens) {
    if (token.isEmpty()) continue;
    char c = token.charAt(0);
    if (Character.isDigit(c) || (token.length() > 1 && Character.isDigit(token.charAt(1)))) {
      stack.push(Float.parseFloat(token));
    } else if (isOperator(c)) {
      float b = stack.pop();
      float a = stack.pop();
      float res = 0;
      switch (c) {
        case '+': res = a + b; break;
        case '-': res = a - b; break;
        case '*': res = a * b; break;
        case '/': res = a / b; break;
      }
      stack.push(res);
    }
  }
  return stack.pop();
}
