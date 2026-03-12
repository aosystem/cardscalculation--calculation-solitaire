import 'package:cardscalculation/card_one.dart';
import 'package:cardscalculation/game_history.dart';
import 'package:cardscalculation/const_value.dart';

class Game {
  static const List<List<String>> joinNumberStrings = [
    ['A','2','3','4','5','6','7','8','9','10','J','Q','K'],
    ['2','4','6','8','10','Q','A','3','5','7','9','J','K'],
    ['3','6','9','Q','2','5','8','J','A','4','7','10','K'],
    ['4','8','Q','3','7','J','2','6','10','A','5','9','K'],
  ];
  static const List<List<int>> joinNumberInts = [
    [1,2,3,4,5,6,7,8,9,10,11,12,13],
    [2,4,6,8,10,12,1,3,5,7,9,11,13],
    [3,6,9,12,2,5,8,11,1,4,7,10,13],
    [4,8,12,3,7,11,2,6,10,1,5,9,13],
  ];
  //
  final CardOne cardOneBlank = const CardOne(-1, 0, ConstValue.imageBlank);
  List<List<CardOne>> cardAce = [[],[],[],[]];
  List<CardOne> cardClose = [];
  List<CardOne> cardOpen = [];
  List<List<CardOne>> cardStage = [
    [],[],[],[],
  ];
  final GameHistory gameHistory = GameHistory();
  Game() {
    init();
  }
  void init() {
    cardAce = [
      [cardOneBlank],
      [cardOneBlank],
      [cardOneBlank],
      [cardOneBlank],
    ];
    cardClose = [cardOneBlank];
    cardOpen = [cardOneBlank];
    cardStage = [
      [cardOneBlank],
      [cardOneBlank],
      [cardOneBlank],
      [cardOneBlank],
    ];
    gameHistory.init();
  }
  List<List<CardOne>> getCardAce() {
    return cardAce;
  }
  List<CardOne> getCardClose() {
    return cardClose;
  }
  List<CardOne> getCardOpen() {
    return cardOpen;
  }
  List<List<CardOne>> getCardStage() {
    return cardStage;
  }
  void cardMoveFromCloseToOpen(CardOne dragCard) {
    if (cardClose.length > 1 && cardOpen.length == 1) {
      cardClose.removeLast();
      cardOpen.add(dragCard);
      gameHistory.historyPush(dragCard, ConstValue.areaClose, 0, ConstValue.areaOpen, 0);
      return;
    }
  }
  void cardMoveToAce(int column, CardOne dragCard) {
    if (dragCard == cardOpen.last) {
      cardOpen.removeLast();
      cardAce[column].add(dragCard);
      gameHistory.historyPush(dragCard, ConstValue.areaOpen, 0, ConstValue.areaAce, column);
      return;
    }
    for (int x = 0; x < 4; x++) {
      if (cardStage[x][cardStage[x].length - 1] == dragCard) {
        cardStage[x].removeLast();
        cardAce[column].add(dragCard);
        gameHistory.historyPush(dragCard, ConstValue.areaStage, x, ConstValue.areaAce, column);
        return;
      }
    }
  }
  void cardMoveFromOpenToStage(int column, CardOne dragCard) {
    cardOpen.removeLast();
    cardStage[column].add(dragCard);
    gameHistory.historyPush(dragCard, ConstValue.areaOpen, 0, ConstValue.areaStage, column);
  }
  void historyUndo() {
    CardMoveRecord? cardMoveRecord = gameHistory.historyPop();
    if (cardMoveRecord == null) {
      return;
    }
    final CardOne cardOne = cardMoveRecord.getCard();
    final int fromArea = cardMoveRecord.getFromArea();
    final int fromColumn = cardMoveRecord.getFromColumn();
    final int toArea = cardMoveRecord.getToArea();
    final int toColumn = cardMoveRecord.getToColumn();
    if (toArea == ConstValue.areaOpen) {
      cardOpen.removeLast();
    } else if (toArea == ConstValue.areaAce) {
      cardAce[toColumn].removeLast();
    } else if (toArea == ConstValue.areaStage) {
      cardStage[toColumn].removeLast();
    }
    if (fromArea == ConstValue.areaClose) {
      cardClose.add(cardOne);
      historyUndo();
    } else if (fromArea == ConstValue.areaOpen) {
      cardOpen.add(cardOne);
    } else if (fromArea == ConstValue.areaStage) {
      cardStage[fromColumn].add(cardOne);
    }
  }
  bool isComplete() {
    return (cardAce[0].length == 14 && cardAce[1].length == 14 && cardAce[2].length == 14 && cardAce[3].length == 14) ? true : false;
  }
}
