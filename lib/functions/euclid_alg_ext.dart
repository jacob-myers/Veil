import 'package:tuple/tuple.dart';

/// Runs the Extended Euclidean Algorithm to find the greatest common divisor
/// (gcd) of two numbers. And x and y where gcd = num1 * x + num2 * y.
Tuple3<int, int, int> euclidAlgExt(int num1, int num2) {
  if (num1 == 0) {
    return Tuple3(num2, 0, 1);
  }

  var ret = euclidAlgExt(num2 % num1, num1);
  int x = ret.item3 - (num2/num1).floor() * ret.item2;
  int y = ret.item2;

  return Tuple3(ret.item1, x, y);
}

void main () {
  print(euclidAlgExt(12345, 11111));
  print(euclidAlgExt(35, 15));
  print(euclidAlgExt(100, 9));
}