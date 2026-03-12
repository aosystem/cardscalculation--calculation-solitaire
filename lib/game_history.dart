import 'package:cardscalculation/card_one.dart';

class GameHistory {
  List<CardMoveRecord> history = [];
  GameHistory() {
    init();
  }
  void init() {
    history = [];
  }
  void historyPush(CardOne moveCard, int moveFromArea, int moveFromColumn, int moveToArea, int moveToColumn) {
    history.add(CardMoveRecord(moveCard, moveFromArea, moveFromColumn, moveToArea, moveToColumn));
  }
  CardMoveRecord? historyPop() {
    if (history.isEmpty) {
      return null;
    }
    CardMoveRecord cardMoveRecord = history[history.length - 1];
    history.removeLast();
    return cardMoveRecord;
  }
  int getLength() {
    return history.length;
  }
}

class CardMoveRecord {
  late CardOne cardOne;
  late int fromArea;
  late int fromColumn;
  late int toArea;
  late int toColumn;
  CardMoveRecord(CardOne moveCard, int moveFromArea, int moveFromColumn, int moveToArea, int moveToColumn) {
    cardOne = moveCard;
    fromArea = moveFromArea;
    fromColumn = moveFromColumn;
    toArea = moveToArea;
    toColumn = moveToColumn;
  }
  CardOne getCard() {
    return cardOne;
  }
  int getFromArea() {
    return fromArea;
  }
  int getFromColumn() {
    return fromColumn;
  }
  int getToArea() {
    return toArea;
  }
  int getToColumn() {
    return toColumn;
  }
}
