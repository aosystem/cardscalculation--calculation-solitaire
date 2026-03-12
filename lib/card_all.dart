import 'package:cardscalculation/card_one.dart';

class CardAll {
  static final List<CardOne> cards = [
    const CardOne(0,1,'assets/image/s1.svg'),
    const CardOne(0,2,'assets/image/s2.svg'),
    const CardOne(0,3,'assets/image/s3.svg'),
    const CardOne(0,4,'assets/image/s4.svg'),
    const CardOne(0,5,'assets/image/s5.svg'),
    const CardOne(0,6,'assets/image/s6.svg'),
    const CardOne(0,7,'assets/image/s7.svg'),
    const CardOne(0,8,'assets/image/s8.svg'),
    const CardOne(0,9,'assets/image/s9.svg'),
    const CardOne(0,10,'assets/image/s10.svg'),
    const CardOne(0,11,'assets/image/s11.svg'),
    const CardOne(0,12,'assets/image/s12.svg'),
    const CardOne(0,13,'assets/image/s13.svg'),
    const CardOne(1,1,'assets/image/h1.svg'),
    const CardOne(1,2,'assets/image/h2.svg'),
    const CardOne(1,3,'assets/image/h3.svg'),
    const CardOne(1,4,'assets/image/h4.svg'),
    const CardOne(1,5,'assets/image/h5.svg'),
    const CardOne(1,6,'assets/image/h6.svg'),
    const CardOne(1,7,'assets/image/h7.svg'),
    const CardOne(1,8,'assets/image/h8.svg'),
    const CardOne(1,9,'assets/image/h9.svg'),
    const CardOne(1,10,'assets/image/h10.svg'),
    const CardOne(1,11,'assets/image/h11.svg'),
    const CardOne(1,12,'assets/image/h12.svg'),
    const CardOne(1,13,'assets/image/h13.svg'),
    const CardOne(2,1,'assets/image/c1.svg'),
    const CardOne(2,2,'assets/image/c2.svg'),
    const CardOne(2,3,'assets/image/c3.svg'),
    const CardOne(2,4,'assets/image/c4.svg'),
    const CardOne(2,5,'assets/image/c5.svg'),
    const CardOne(2,6,'assets/image/c6.svg'),
    const CardOne(2,7,'assets/image/c7.svg'),
    const CardOne(2,8,'assets/image/c8.svg'),
    const CardOne(2,9,'assets/image/c9.svg'),
    const CardOne(2,10,'assets/image/c10.svg'),
    const CardOne(2,11,'assets/image/c11.svg'),
    const CardOne(2,12,'assets/image/c12.svg'),
    const CardOne(2,13,'assets/image/c13.svg'),
    const CardOne(3,1,'assets/image/d1.svg'),
    const CardOne(3,2,'assets/image/d2.svg'),
    const CardOne(3,3,'assets/image/d3.svg'),
    const CardOne(3,4,'assets/image/d4.svg'),
    const CardOne(3,5,'assets/image/d5.svg'),
    const CardOne(3,6,'assets/image/d6.svg'),
    const CardOne(3,7,'assets/image/d7.svg'),
    const CardOne(3,8,'assets/image/d8.svg'),
    const CardOne(3,9,'assets/image/d9.svg'),
    const CardOne(3,10,'assets/image/d10.svg'),
    const CardOne(3,11,'assets/image/d11.svg'),
    const CardOne(3,12,'assets/image/d12.svg'),
    const CardOne(3,13,'assets/image/d13.svg'),
  ];
  void cardsShuffle() {
    cards.shuffle();
  }
  List<CardOne> getCards() {
    return cards;
  }
}
