import 'dart:math';

double getRandomDouble(double min, double max) {
  var random = Random();
  return min + random.nextDouble() * (max - min);
}

int getRandomInt(int min, int max) {
  var random = Random();
  return min + random.nextInt(max - min);
}
