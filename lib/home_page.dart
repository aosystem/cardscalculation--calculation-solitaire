import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/scheduler.dart';

import 'package:cardscalculation/l10n/app_localizations.dart';
import 'package:cardscalculation/svg_precache.dart';
import 'package:cardscalculation/ad_manager.dart';
import 'package:cardscalculation/ad_banner_widget.dart';
import 'package:cardscalculation/audio_play.dart';
import 'package:cardscalculation/card_all.dart';
import 'package:cardscalculation/card_one.dart';
import 'package:cardscalculation/drag_animation.dart';
import 'package:cardscalculation/game.dart';
import 'package:cardscalculation/const_value.dart';
import 'package:cardscalculation/app_condition.dart';
import 'package:cardscalculation/theme_color.dart';
import 'package:cardscalculation/loading_screen.dart';
import 'package:cardscalculation/model.dart';
import 'package:cardscalculation/parse_locale_tag.dart';
import 'package:cardscalculation/setting_page.dart';
import 'package:cardscalculation/theme_mode_number.dart';
import 'package:cardscalculation/main.dart';


class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});
  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppCondition _appCondition = AppCondition();
  final CardAll _cardAll = CardAll();
  final Game _game = Game();
  final DragAnimation _dragAnimation = DragAnimation();
  bool _didPrecache = false;
  late AudioPlay _audioPlay;
  late AdManager _adManager;
  late ThemeColor _themeColor;
  bool _isReady = false;
  bool _isFirst = true;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  void _initState() async {
    _adManager = AdManager();
    _audioPlay = AudioPlay();
    _audioPlay.setSoundEnabled(Model.soundEnabled);
  }

  @override
  void dispose() {
    _adManager.dispose();
    _audioPlay.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _storeAppCanvasWidth(false);
    _onClickStartButton();
    if (!_didPrecache) {
      _didPrecache = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future<void>.delayed(const Duration(milliseconds: 250)).then((_) {
          if (mounted) {
            precacheSvgAssets(context);
            setState(() {
              _isReady = true;
            });
          }
        });
      });
    }
  }

  void _storeAppCanvasWidth(bool reDraw) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final BuildContext? context = _key.currentContext;
      final Size? size = context?.size;
      if (size == null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _storeAppCanvasWidth(reDraw);
          }
        });
        return;
      }
      final double sizeWidth = size.width;
      final double margin = sizeWidth * 0.025;
      final double w = sizeWidth - margin;
      final double h = size.height - margin - ConstValue.menuBarHeight;
      double appWidth = w;
      if (w / ConstValue.canvasAspectRatio > h) {
        appWidth = (h / (w / ConstValue.canvasAspectRatio)) * w;
      }
      _appCondition.setCanvasWidth(appWidth.floorToDouble());
      if (reDraw) {
        setState(() {});
      }
    });
  }

  void _onClickSetting() async {
    final updatedSettings = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingPage(),
      ),
    );
    if (updatedSettings != null) {
      if (mounted) {
        _audioPlay.setSoundEnabled(Model.soundEnabled);
        final mainState = context.findAncestorStateOfType<MainAppState>();
        if (mainState != null) {
          mainState
            ..locale = parseLocaleTag(Model.languageCode)
            ..themeMode = ThemeModeNumber.numberToThemeMode(Model.themeNumber)
            ..setState(() {});
          setState(() {
            _isFirst = true;
          });
        }
      }
    }
  }

  void _onClickStartButton() {
    _audioPlay.playSoundStart();
    _cardAll.cardsShuffle();
    setState(() {
      _handOut();
    });
  }

  void _onClickRetryButton() {
    _audioPlay.playSoundRetry();
    setState(() {
      _handOut();
    });
  }

  void _onClickUndoButton() {
    _audioPlay.playSoundBack();
    setState(() {
      _game.historyUndo();
    });
  }

  void _handOut() {
    final List<CardOne> cards = _cardAll.getCards();
    _game.init();
    List<bool> aceSets = [false,false,false,false];
    for (int i = 0; i < 52; i++) {
      final CardOne card = cards[i];
      final int cardNum = card.getNum();
      if (aceSets[0] == false && cardNum == 1) {
        _game.cardAce[0].add(card);
        aceSets[0] = true;
      } else if (aceSets[1] == false && cardNum == 2) {
        _game.cardAce[1].add(card);
        aceSets[1] = true;
      } else if (aceSets[2] == false && cardNum == 3) {
        _game.cardAce[2].add(card);
        aceSets[2] = true;
      } else if (aceSets[3] == false && cardNum == 4) {
        _game.cardAce[3].add(card);
        aceSets[3] = true;
      } else if (i == 51) {
        _game.cardOpen.add(card);
      } else {
        _game.cardClose.add(card);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return LoadingScreen();
    }
    if (_isFirst) {
      _isFirst = false;
      _themeColor = ThemeColor(themeNumber: Model.themeNumber, context: context);
    }
    _storeAppCanvasWidth(false);
    return Scaffold(
      key: _key,
      appBar: null,
      backgroundColor: _themeColor.mainBackColor,
      body: SafeArea(
        child: OrientationBuilder(builder: (context, orientation) {
          _storeAppCanvasWidth(true);
          return SafeArea(
            child: Center(
              child: Column(
                children: [
                  _menuBar(),
                  Expanded(
                    child: Container(
                      color: _themeColor.mainBackColor,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: ConstValue.canvasAspectRatio,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: _themeColor.mainBackColor,
                            child: _boxCanvas(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
              ),
            )
          );
        })
      ),
      bottomNavigationBar: AdBannerWidget(adManager: _adManager)
    );
  }

  Widget _menuBar() {
    return Container(
      height: ConstValue.menuBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(color: _themeColor.mainBackColor),
      child: Row(
        children: <Widget> [
          _startButton(),
          const SizedBox(width: 8),
          _retryButton(),
          const SizedBox(width: 8),
          _undoButton(),
          const Expanded(
            child: SizedBox(width: 8),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: _themeColor.mainForeColor),
            tooltip: AppLocalizations.of(context)!.setting,
            onPressed: _onClickSetting,
          )
        ],
      ),
    );
  }

  ElevatedButton _startButton() {
    return ElevatedButton(
      onPressed: _onClickStartButton,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: _themeColor.mainBackColor,
        side: BorderSide(width: 1, color: _themeColor.mainForeColor),
        padding: const EdgeInsets.all(8.0),
      ),
      child: Text(AppLocalizations.of(context)!.start,
        style: TextStyle(color: _themeColor.mainForeColor)
      ),
    );
  }

  ElevatedButton _retryButton() {
    return ElevatedButton(
      onPressed: _onClickRetryButton,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: _themeColor.mainBackColor,
        side: BorderSide(width: 1, color: _themeColor.mainForeColor),
        padding: const EdgeInsets.all(8.0),
      ),
      child: Text(AppLocalizations.of(context)!.retry,
        style: TextStyle(color: _themeColor.mainForeColor),
      ),
    );
  }

  ElevatedButton _undoButton() {
    return ElevatedButton(
      onPressed: _onClickUndoButton,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: _themeColor.mainBackColor,
        side: BorderSide(width: 1, color: _themeColor.mainForeColor),
        padding: const EdgeInsets.all(8.0),
      ),
      child: Text(AppLocalizations.of(context)!.undo,
        style: TextStyle(color: _themeColor.mainForeColor),
      ),
    );
  }

  Widget _boxCanvas() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double canvasWidth = constraints.maxWidth;
        final double widthCardGap = (canvasWidth / 67).floorToDouble();
        final double widthCardNum = widthCardGap * 5;
        final double widthCardOne = widthCardGap * 10;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RepaintBoundary(child: StepNumbers(column: 0, width: widthCardNum, activeIndex: _game.getCardAce()[0].length - 1, themeColor: _themeColor)),
                Container(width: widthCardGap),
                Stack(children: _cardAceImage(0,widthCardOne)),
                Container(width: widthCardGap),
                RepaintBoundary(child: StepNumbers(column: 1, width: widthCardNum, activeIndex: _game.getCardAce()[1].length - 1, themeColor: _themeColor)),
                Container(width: widthCardGap),
                Stack(children: _cardAceImage(1,widthCardOne)),
                Container(width: widthCardGap),
                RepaintBoundary(child: StepNumbers(column: 2, width: widthCardNum, activeIndex: _game.getCardAce()[2].length - 1, themeColor: _themeColor)),
                Container(width: widthCardGap),
                Stack(children: _cardAceImage(2,widthCardOne)),
                Container(width: widthCardGap),
                RepaintBoundary(child: StepNumbers(column: 3, width: widthCardNum, activeIndex: _game.getCardAce()[3].length - 1, themeColor: _themeColor)),
                Container(width: widthCardGap),
                Stack(children: _cardAceImage(3,widthCardOne)),
              ],
            ),
            Container(height: widthCardGap * 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(children: _cardCloseImage(widthCardOne)),
                Container(width: widthCardGap),
                Stack(children: _cardOpenImage(widthCardOne)),
                Container(width: widthCardGap * 3),
                Stack(children: _cardStageImage(0,widthCardOne)),
                Container(width: widthCardGap),
                Stack(children: _cardStageImage(1,widthCardOne)),
                Container(width: widthCardGap),
                Stack(children: _cardStageImage(2,widthCardOne)),
                Container(width: widthCardGap),
                Stack(children: _cardStageImage(3,widthCardOne)),
              ],
            ),
          ],
        );
      },
    );
  }

  List<Widget> _cardAceImage(int index, double widthCardOne) {
    final double cardHeight = widthCardOne / 360 * 540;
    bool isAceCardJoin(int index, CardOne dragCard) {
      final List<List<CardOne>> cardAce = _game.getCardAce();
      final int cardAceLength = cardAce[index].length;
      if (cardAceLength >= 14) {
        return false;
      }
      final int nextNum = Game.joinNumberInts[index][cardAceLength - 1];
      final int dragNum = dragCard.getNum();
      if (dragNum == nextNum) {
        return true;
      }
      return false;
    }
    final List<List<CardOne>> cardAce = _game.getCardAce();
    final List<Container> containerArray = [];
    for (int y = 0; y < cardAce[index].length; y++) {
      final String cardImg = cardAce[index][y].getImg();
      final double marginTop = (y <= 1) ? 0 : (y - 1) * (widthCardOne * 0.35);
      final Container container = Container(
        margin: EdgeInsets.only(top: marginTop),
        child: SvgPicture.asset(
          cardImg,
          width: widthCardOne,
          excludeFromSemantics: true,
        ),
      );
      containerArray.add(container);
    }
    final double marginTop = (cardAce[index].length <= 1) ? 0 : (cardAce[index].length - 1) * (widthCardOne * 0.35);
    final Container containerDragArea = Container(
      margin: EdgeInsets.only(top: marginTop),
      child: DragTarget<CardOne>(
        builder: (context, accepted, rejected) {
          return SizedBox(
            width: widthCardOne,
            height: cardHeight,
          );
        },
        onWillAcceptWithDetails: (details) {
          return isAceCardJoin(index, details.data);
        },
        onAcceptWithDetails: (details) {
          _game.cardMoveToAce(index, details.data);
          cardMoveFormCloseToOpen();
          if (_game.isComplete()) {
            _audioPlay.playSoundComplete();
          }
        },
      )
    );
    containerArray.add(containerDragArea);
    return containerArray;
  }
  List<Widget> _cardCloseImage(double widthCardOne) {
    final List<CardOne> cardClose = _game.getCardClose();
    final List<Container> containerArray = [];
    for (int y = 0; y < cardClose.length; y++) {
      final String cardImg = cardClose[y].getImg();
      final int cardNum = cardClose[y].getNum();
      final double marginTop = (y <= 1) ? 0 : (y - 1) * (widthCardOne * 0.05);
      final Container container = Container(
        margin: EdgeInsets.only(top: marginTop),
        child: SvgPicture.asset(
          (cardNum >= 1) ? ConstValue.imageBack : cardImg,
          width: widthCardOne,
          excludeFromSemantics: true,
        ),
      );
      containerArray.add(container);
    }
    return containerArray;
  }
  List<Widget> _cardOpenImage(double widthCardOne) {
    final List<CardOne> cardOpen = _game.getCardOpen();
    final List<Widget> containerArray = [];
    if (cardOpen.isNotEmpty) {
      final String cardImg = cardOpen[0].getImg();
      final Widget svgPicture = SvgPicture.asset(
        cardImg,
        width: widthCardOne,
        excludeFromSemantics: true,
      );
      containerArray.add(svgPicture);
    }
    if (cardOpen.length >= 2) {
      final String cardImg = cardOpen[1].getImg();
      final int cardIndex = cardOpen[1].getIndex();
      final AnimatedPositioned container = AnimatedPositioned(
        left: _dragAnimation.getX(cardIndex),
        top: _dragAnimation.getY(cardIndex),
        duration: Duration(milliseconds: _dragAnimation.getSpeed(cardIndex)),
        child: Draggable<CardOne>(
          data: cardOpen[1],
          onDragStarted: () {
            _audioPlay.playSoundSlide();
          },
          feedback: SvgPicture.asset(
            cardImg,
            width: widthCardOne,
            excludeFromSemantics: true,
          ),
          childWhenDragging: const SizedBox.shrink(),
          child: SvgPicture.asset(
            cardImg,
            width: widthCardOne,
            excludeFromSemantics: true,
          ),
          onDragUpdate: (details) {
            _dragAnimation.setSpeedOff(cardIndex);
            _dragAnimation.addX(cardIndex,details.delta.dx);
            _dragAnimation.addY(cardIndex,details.delta.dy);
          },
          onDragEnd: (details) {
            _dragAnimation.setSpeedOn(cardIndex);
            _dragAnimation.setX(cardIndex,0);
            _dragAnimation.setY(cardIndex,0);
          },
        ),
      );
      containerArray.add(container);
    }
    return containerArray;
  }
  List<Widget> _cardStageImage(int index, double widthCardOne) {
    final double cardHeight = widthCardOne / 360 * 540;
    final List<List<CardOne>> cardStage = _game.getCardStage();
    final List<Widget> containerArray = [];
    for (int y = 0; y < cardStage[index].length; y++) {
      final String cardImg = cardStage[index][y].getImg();
      final int cardIndex = cardStage[index][y].getIndex();
      double marginTop = 0;
      if (cardStage[index].length >= 13) {
        marginTop = (y <= 1) ? 0 : (y - 1) * (widthCardOne * 0.2);
      } else {
        marginTop = (y <= 1) ? 0 : (y - 1) * (widthCardOne * 0.35);
      }
      if (y != 0 && y == cardStage[index].length - 1) {
        final AnimatedPositioned container = AnimatedPositioned(
          left: _dragAnimation.getX(cardIndex),
          top: _dragAnimation.getY(cardIndex),
          duration: Duration(milliseconds: _dragAnimation.getSpeed(cardIndex)),
          child: Container(
            margin: EdgeInsets.only(top: marginTop),
            child: Draggable<CardOne>(
              data: cardStage[index][y],
              onDragStarted: () {
                _audioPlay.playSoundSlide();
              },
              feedback: SvgPicture.asset(
                cardImg,
                width: widthCardOne,
                excludeFromSemantics: true,
              ),
              childWhenDragging: const SizedBox.shrink(),
              child: SvgPicture.asset(
                cardImg,
                width: widthCardOne,
                excludeFromSemantics: true,
              ),
              onDragUpdate: (details) {
                _dragAnimation.setSpeedOff(cardIndex);
                _dragAnimation.addX(cardIndex,details.delta.dx);
                _dragAnimation.addY(cardIndex,details.delta.dy);
              },
              onDragEnd: (details) {
                _dragAnimation.setSpeedOn(cardIndex);
                _dragAnimation.setX(cardIndex,0);
                _dragAnimation.setY(cardIndex,0);
              },
            ),
          ),
        );
        containerArray.add(container);
      } else {
        final Container container = Container(
          margin: EdgeInsets.only(top: marginTop),
          child: SvgPicture.asset(
            cardImg,
            width: widthCardOne,
            excludeFromSemantics: true,
          ),
        );
        containerArray.add(container);
      }
    }
    double marginTop = 0;
    if (cardStage[index].length >= 13) {
      marginTop = (cardStage[index].length - 1) * (widthCardOne * 0.2);
    } else {
      marginTop = (cardStage[index].length - 1) * (widthCardOne * 0.35);
    }
    final Container containerDragArea = Container(
      margin: EdgeInsets.only(top: marginTop),
      child: DragTarget<CardOne>(
        builder: (context, accepted, rejected) {
          return SizedBox(
            width: widthCardOne,
            height: cardHeight,
          );
        },
        onWillAcceptWithDetails: (details) {
          return (details.data == _game.cardOpen.last) ? true : false;
        },
        onAcceptWithDetails: (details) {
          _game.cardMoveFromOpenToStage(index, details.data);
          cardMoveFormCloseToOpen();
        },
      ),
    );
    containerArray.add(containerDragArea);
    return containerArray;
  }
  void cardMoveFormCloseToOpen() {
    final List<CardOne> cardClose = _game.getCardClose();
    if (cardClose.length > 1) {
      _game.cardMoveFromCloseToOpen(cardClose.last);
    }
  }

}

class StepNumbers extends StatelessWidget {
  final int column;
  final double width;
  final int activeIndex;
  final ThemeColor themeColor;
  const StepNumbers({super.key, required this.column, required this.width, required this.activeIndex, required this.themeColor});

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = TextStyle(
      color: themeColor.colorStepNumberOffFore,
      fontSize: 15,
    );
    TextStyle onStyle = TextStyle(
      color: themeColor.colorStepNumberOnFore,
      fontSize: 15,
    );
    BoxDecoration offDeco = BoxDecoration(color: themeColor.colorStepNumberOffBack);
    BoxDecoration onDeco = BoxDecoration(color: themeColor.colorStepNumberOnBack);
    return DefaultTextStyle(
      style: defaultStyle,
      child: Column(
        children: List.generate(13, (x) {
          final bool isActive = x == activeIndex;
          return Container(
            width: width,
            decoration: isActive ? onDeco : offDeco,
            child: Text(
              Game.joinNumberStrings[column][x],
              textAlign: TextAlign.center,
              style: isActive ? onStyle : null,
            ),
          );
        }),
      ),
    );
  }
}
