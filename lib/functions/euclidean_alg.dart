/// Runs the Euclidean algorithm to find the greatest common divisor (gcd) of
/// two numbers. Order does not matter.
int euclidAlg(int num1, int num2) {

  int r = num1 % num2;
  if (r == 0) {
    return num2;
  }
  return euclidAlg(num2, r);
}

void main () {
  print(euclidAlg(11111, 12345));
  print(euclidAlg(100, 9));
  print(euclidAlg(60, 21));
}