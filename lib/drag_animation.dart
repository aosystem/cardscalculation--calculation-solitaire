class DragAnimation {
  List<double> dx = List.generate(53, (i)=>0);
  List<double> dy = List.generate(53, (i)=>0);
  List<int> speed = List.generate(53, (i)=>0);
  void setX(int i, double num) {
    dx[i] = num;
  }
  void setY(int i, double num) {
    dy[i] = num;
  }
  void addX(int i, double num) {
    dx[i] += num;
  }
  void addY(int i, double num) {
    dy[i] += num;
  }
  double getX(int i) {
    return dx[i];
  }
  double getY(int i) {
    return dy[i];
  }
  void setSpeedOff(int i) {
    speed[i] = 0;
  }
  void setSpeedOn(int i) {
    speed[i] = 200;
    Future.delayed(Duration(milliseconds: speed[i]), () {
      speed[i] = 0;
    });
  }
  int getSpeed(int i) {
    return speed[i];
  }
}
