import javax.swing.JOptionPane;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

String infixExpr = "3 + 5 * ( 2 - 8 ) / 4"; // 기본 예시 수식
String postfixExpr = "";
float result = 0;
boolean hasError = false;
String errorMessage = "";

void setup() {
  size(850, 520);
  surface.setTitle("Infix to Postfix Calculator & Evaluator");
  
  // 최초 실행 시 입력창 띄우기
  processExpression(infixExpr);
}

void draw() {
  background(25, 25, 35);
  
  // 타이틀
  fill(255);
  textSize(24);
  textAlign(CENTER, TOP);
  text("Processing Stack Infix to Postfix Calculator", width / 2, 30);
  
  // 안내 문구
  textSize(15);
  fill(180, 200, 220);
  text("Press 'ENTER' or 'I' key to enter a new expression", width / 2, 75);
  
  // 1. 중위 표기법 박스
  drawBox(50, 120, width - 100, 75, "1. Infix Expression (사용자 입력 수식):", infixExpr, color(50, 120, 200));
  
  // 2. 후위 표기법 박스
  drawBox(50, 215, width - 100, 75, "2. Postfix Expression (후위 표기법 변환 결과):", postfixExpr, color(50, 180, 120));
  
  // 3. 연산 결과 또는 에러 박스
  if (hasError) {
    drawBox(50, 310, width - 100, 85, "Evaluation Error (오류 발생):", errorMessage, color(220, 60, 60));
  } else {
    drawBox(50, 310, width - 100, 85, "3. Final Result (최종 계산 결과):", nf(result, 0, 4), color(140, 90, 220));
  }
  
  // 하단 도움말
  textSize(13);
  fill(130);
  textAlign(CENTER, BOTTOM);
  text("Supported: +, -, *, /, (), Multi-digit numbers. (예: 10 + 2 * (6 - 4))", width / 2, height - 20);
}

// 키 입력 이벤트: Enter나 i를 누르면 입력창 호출
void keyPressed() {
  if (keyCode == ENTER || key == 'i' || key == 'I') {
    requestInput();
  }
}

// 사용자 입력을 받아 수식 처리
void requestInput() {
  String input = JOptionPane.showInputDialog(null, 
    "수식을 입력하세요 (예: 3 + 5 * ( 2 - 8 ) / 4):", 
    "Infix Calculator Input", 
    JOptionPane.QUESTION_MESSAGE);
    
  if (input != null && !input.trim().isEmpty()) {
    infixExpr = input;
    processExpression(infixExpr);
  }
}

// 수식 변환 및 계산 실행 함수
void processExpression(String infix) {
  hasError = false;
  errorMessage = "";
  try {
    postfixExpr = infixToPostfix(infix);
    result = evaluatePostfix(postfixExpr);
  } catch (Exception e) {
    hasError = true;
    errorMessage = e.getMessage();
    postfixExpr = "Conversion / Syntax Error";
  }
}

// UI 박스 렌더링 헬퍼 함수
void drawBox(float x, float y, float w, float h, String label, String val, color c) {
  fill(40, 40, 55);
  stroke(c);
  strokeWeight(2);
  rect(x, y, w, h, 8);
  
  noStroke();
  fill(c);
  rect(x, y, 12, h, 8, 0, 0, 8); // 좌측 포인트 컬러 바
  
  textAlign(LEFT, CENTER);
  textSize(13);
  fill(160);
  text(label, x + 30, y + 22);
  
  textSize(18);
  fill(255);
  text(val, x + 30, y + 50);
}

// 수식을 토큰 단위(숫자와 연산자, 괄호)로 분리하는 토크나이저 (공백 유무 상관없이 동작)
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
  if (!numBuf.isEmpty()) {
    tokens.add(numBuf);
  }
  return tokens;
}

// 연산자 우선순위 판별
int precedence(char op) {
  if (op == '+' || op == '-') return 1;
  if (op == '*' || op == '/') return 2;
  return 0;
}

boolean isOperator(char c) {
  return c == '+' || c == '-' || c == '*' || c == '/';
}

// 1. 중위 표기법(Infix)을 후위 표기법(Postfix)으로 변환하는 함수 (Stack 활용)
String infixToPostfix(String s) {
  List<String> tokens = tokenize(s);
  Stack<String> stack = new Stack<>();
  List<String> output = new ArrayList<>();
  
  for (String token : tokens) {
    char c = token.charAt(0);
    
    // 숫자인 경우 출력 리스트에 추가
    if (Character.isDigit(c) || (token.length() > 1 && Character.isDigit(token.charAt(1)))) {
      output.add(token);
    } 
    // 여는 괄호 '(' 인 경우 스택에 푸시
    else if (c == '(') {
      stack.push(token);
    } 
    // 닫는 괄호 ')' 인 경우 '('가 나올 때까지 팝하여 출력에 추가
    else if (c == ')') {
      while (!stack.isEmpty() && !stack.peek().equals("(")) {
        output.add(stack.pop());
      }
      if (!stack.isEmpty() && stack.peek().equals("(")) {
        stack.pop(); // '(' 제거
      } else {
        throw new IllegalArgumentException("Mismatched parentheses (괄호 짝이 맞지 않습니다)");
      }
    } 
    // 연산자일 경우
    else if (isOperator(c)) {
      while (!stack.isEmpty() && precedence(stack.peek().charAt(0)) >= precedence(c)) {
        output.add(stack.pop());
      }
      stack.push(token);
    } else {
      throw new IllegalArgumentException("Invalid token: " + token);
    }
  }
  
  // 스택에 남은 연산자들 모두 팝
  while (!stack.isEmpty()) {
    if (stack.peek().equals("(")) {
      throw new IllegalArgumentException("Mismatched parentheses");
    }
    output.add(stack.pop());
  }
  
  return String.join(" ", output);
}

// 2. 후위 표기법(Postfix) 수식을 스택으로 계산하는 함수
float evaluatePostfix(String postfix) {
  if (postfix.isEmpty()) return 0;
  String[] tokens = postfix.split("\\s+");
  Stack<Float> stack = new Stack<>();
  
  for (String token : tokens) {
    if (token.isEmpty()) continue;
    char c = token.charAt(0);
    
    // 숫자인 경우 스택에 푸시
    if (Character.isDigit(c) || (token.length() > 1 && Character.isDigit(token.charAt(1)))) {
      stack.push(Float.parseFloat(token));
    } 
    // 연산자인 경우 스택에서 두 개의 피연산자를 팝하여 계산
    else if (isOperator(c)) {
      if (stack.size() < 2) throw new IllegalArgumentException("Invalid expression format");
      float b = stack.pop();
      float a = stack.pop();
      float res = 0;
      switch (c) {
        case '+': res = a + b; break;
        case '-': res = a - b; break;
        case '*': res = a * b; break;
        case '/': 
          if (b == 0) throw new ArithmeticException("Division by zero (0으로 나눌 수 없습니다)");
          res = a / b; 
          break;
      }
      stack.push(res);
    }
  }
  
  if (stack.size() != 1) throw new IllegalArgumentException("Invalid expression evaluation");
  return stack.pop();
}
