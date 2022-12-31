import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake_game/snake_game/constants.dart';
import 'package:snake_game/snake_game/snake_functions.dart';

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  @override
  void initState() {
    createSnake();
    super.initState();
  }

  void createSnake() {
    for (var i = 0; i < 5; i++) {
      snakePosition.add(i);
    }
  }

  void startGame() {
    isGameRunning = true;
    timer = Timer.periodic(
      const Duration(milliseconds: 150),
      (timer) {
        moveSnake();
        isGameOver();
      },
    );
  }

  void moveSnake() {
    switch (snakeDirection) {
      case SnakeDirection.right:
        if (snakePosition.last % rowSize == rowSize - 1) {
          snakePosition.add(snakePosition.last + 1 - rowSize);
        } else {
          snakePosition.add(snakePosition.last + 1);
        }
        break;
      case SnakeDirection.left:
        if (snakePosition.last % rowSize == 0) {
          snakePosition.add(snakePosition.last - 1 + rowSize);
        } else {
          snakePosition.add(snakePosition.last - 1);
        }
        break;
      case SnakeDirection.up:
        if (snakePosition.last < rowSize) {
          snakePosition.add(snakePosition.last - rowSize + totalBoxGridCount);
        } else {
          snakePosition.add(snakePosition.last - rowSize);
        }
        break;
      case SnakeDirection.down:
        if (snakePosition.last > totalBoxGridCount - rowSize) {
          snakePosition.add(snakePosition.last + rowSize - totalBoxGridCount);
        } else {
          snakePosition.add(snakePosition.last + rowSize);
        }
        break;
    }

    if (snakePosition.last == foodPosition) {
      onEatFood();
    } else {
      snakePosition.remove(snakePosition.first);
    }

    setState(() {});
  }

  void onEatFood() {
    score++;
    while (snakePosition.contains(foodPosition)) {
      foodPosition = Random().nextInt(totalBoxGridCount - 1);
    }
  }

  void isGameOver() {
    snakeBodyPosition.addAll(snakePosition);
    snakeBodyPosition.remove(snakePosition.last);
    if (snakeBodyPosition.contains(snakePosition.last)) {
      timer.cancel();
      HapticFeedback.mediumImpact();
      isGameRunning = false;
      resetGame();
    }
    snakeBodyPosition = [];
    setState(() {});
  }

  void resetGame() {
    if (score > highScore) {
      highScore = score;
    }
    score = 0;
    snakeDirection = SnakeDirection.right;
    snakePosition = [];
    snakeBodyPosition = [];
    createSnake();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0 && snakeDirection != SnakeDirection.left) {
          snakeDirection = SnakeDirection.right;
        } else if (details.delta.dx < 0 &&
            snakeDirection != SnakeDirection.right) {
          snakeDirection = SnakeDirection.left;
        }
        setState(() {});
      },
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 0 && snakeDirection != SnakeDirection.up) {
          snakeDirection = SnakeDirection.down;
        } else if (details.delta.dy < 0 &&
            snakeDirection != SnakeDirection.down) {
          snakeDirection = SnakeDirection.up;
        }
        setState(() {});
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
              "Snake Game",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            elevation: 8,
            centerTitle: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Expanded(
                  flex: 6,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: totalBoxGridCount,
                    // ignore: prefer_const_constructors
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: rowSize,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemBuilder: (context, index) {
                      if (foodPosition == index) {
                        return const Food();
                      } else if (snakePosition.contains(index)) {
                        return const Snake();
                      } else {
                        return Box(
                          index: index,
                        );
                      }
                    },
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Score: $score ",
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "HI : $highScore ",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: isGameRunning
                      ? const SizedBox()
                      : ElevatedButton(
                          onPressed: () {
                            startGame();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          child: const Text("Start"),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
