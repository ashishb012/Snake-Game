import 'dart:async';
import 'dart:math';

const int totalBoxGridCount = 500;

const int rowSize = 20;

int foodPosition = Random().nextInt(totalBoxGridCount - 1);

int score = 0;

int highScore = 0;

bool isGameRunning = false;

List<int> snakePosition = [];

List<int> snakeBodyPosition = [];

late Timer timer;

enum SnakeDirection {
  up,
  down,
  left,
  right,
}

SnakeDirection snakeDirection = SnakeDirection.right;
