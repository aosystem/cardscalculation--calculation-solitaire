class CardOne {
  final int _mark;
  final int _num;
  final String _img;
  const CardOne(this._mark, this._num, this._img);
  int getMark() {
    return _mark;
  }
  String getColor() {
    if (_mark == 0 || _mark == 2) {
      return 'BLACK';
    }
    if (_mark == 1 || _mark == 3) {
      return 'RED';
    }
    return '';
  }
  int getNum() {
    return _num;
  }
  String getImg() {
    return _img;
  }
  int getIndex() {
    int index = _mark * 13 + _num;
    if (index < 0) {
      return 0;
    }
    return index;
  }
}
