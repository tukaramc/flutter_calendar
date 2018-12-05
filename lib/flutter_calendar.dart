import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:intl/intl.dart';
import 'package:flutter_calendar/calendar_tile.dart';
import 'package:date_utils/date_utils.dart';
import 'package:cuecladapp/utils/themeColor.dart';
import 'package:cuecladapp/modified_files/date_picker.dart';

////////////  C:\flutter\.pub-cache\hosted\pub.dartlang.org\flutter_calendar-0.0.4\lib

typedef DayBuilder(BuildContext context, DateTime day);

class Calendar extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<Tuple2<DateTime, DateTime>> onSelectedRangeChange;
  final bool isExpandable;
  final DayBuilder dayBuilder;
  final bool showChevronsToChangeRange;
  final bool showTodayAction;
  final bool showCalendarPickerIcon;
  final String calendarImagePath;

  Calendar({
    this.onDateSelected,
    this.onSelectedRangeChange,
    this.isExpandable: false,
    this.dayBuilder,
    this.showTodayAction: true,
    this.showChevronsToChangeRange: true,
    this.showCalendarPickerIcon: true,
    this.calendarImagePath,
  });

  @override
  _CalendarState createState() => new _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final calendarUtils = new Utils();
  DateTime today = new DateTime.now();
  List<DateTime> selectedMonthsDays;
  Iterable<DateTime> selectedWeeksDays;
  DateTime _selectedDate;
  Tuple2<DateTime, DateTime> selectedRange;
  String currentMonth;
  bool isExpanded = false;
  String displayMonth;

  DateTime get selectedDate => _selectedDate;

  void initState() {
    super.initState();
    selectedMonthsDays = Utils.daysInMonth(today);
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(today);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(today);
    selectedWeeksDays =
        Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
            .toList()
            .sublist(0, 7);
    _selectedDate = today;
    displayMonth = Utils.formatMonth(Utils.firstDayOfWeek(today));
  }

  Widget get nameAndIconRow {
    var leftInnerIcon;
    var rightInnerIcon;
    var leftOuterIcon;
    var rightOuterIcon;

    if (widget.showCalendarPickerIcon) {
      rightInnerIcon = new InkWell(
        onTap: () {
          selectDateFromPicker();
        },
        ////// chetan changed calendar icon
        child: new Container(
          padding: EdgeInsets.only(top: 15.0,right: 10.0),
          child: new Image.asset(
            widget.calendarImagePath,
            color: Color(0xFFffffff).withOpacity(0.70),
            height: 21.0,
            width: 21.0,
          ),
        ),
      );
      /*  new IconButton(
        onPressed: () => selectDateFromPicker(),
        icon: new Icon(Icons.calendar_today,
            color: CueCladThemeUIColor.appBarIconColor),
      ); */
    } else {
      rightInnerIcon = new Container();
    }

    if (widget.showChevronsToChangeRange) {
      /* leftOuterIcon = new IconButton(
        onPressed: isExpanded ? previousMonth : previousWeek,
        icon: new Icon(Icons.chevron_left,color: Colors.white),
      ); */
      /* rightOuterIcon = new IconButton(
        onPressed: isExpanded ? nextMonth : nextWeek,
        icon: new Icon(Icons.chevron_right,color: Colors.white),
      ); */
    } else {
      leftOuterIcon = new Container();
      rightOuterIcon = new Container();
    }

    if (widget.showTodayAction) {
      leftInnerIcon = new InkWell(
        child: new Text('', style: new TextStyle(color: Colors.white)),
        onTap: resetToToday,
      );
    } else {
      leftInnerIcon = new Container();
    }

    return new Row(
      children: [
        new Stack(
          children: <Widget>[
            /////////Chetan  Add Next/Previous Button
            new Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                ////////  get previous day from selected day /////
                child: new Container(
                    width: 250.0,
                    child: new Stack(
                      children: <Widget>[
                        new Container(
                          margin: const EdgeInsets.only(top: 2.0),
                          alignment: Alignment.centerLeft,
                          child: new IconButton(
                            onPressed: () {
                              setState(() {
                                var firstDateOfNewMonth =
                                Utils.firstDayOfMonth(_selectedDate);
                                if (1 < _selectedDate.day) {
                                  _selectedDate =
                                      _selectedDate.add(Duration(days: -1));
                                  handleSelectedDateAndUserCallback(
                                      _selectedDate);
                                } else {
                                  var getpreviousMonth =
                                  Utils.previousMonth(_selectedDate);
                                  _selectedDate =
                                      Utils.lastDayOfMonth(getpreviousMonth);
                                  handleSelectedDateAndUserCallback(
                                      _selectedDate);
                                }
                              });
                            },
                            icon: new Icon(Icons.chevron_left,
                                color: Colors.white),
                          ),
                        ),

                        /////////////  get next day of selected day //////
                        new Container(
                          margin: const EdgeInsets.only(top: 2.0),
                          alignment: Alignment.centerRight,
                          child: new IconButton(
                            onPressed: () {
                              setState(() {
                                var lastDateOfNewMonth =
                                Utils.lastDayOfMonth(_selectedDate);
                                print(
                                    "last day ********* ${lastDateOfNewMonth}");
                                if (lastDateOfNewMonth.day >
                                    _selectedDate.day) {
                                  _selectedDate =
                                      _selectedDate.add(Duration(days: 1));
                                  handleSelectedDateAndUserCallback(
                                      _selectedDate);
                                } else {
                                  var getNextMonth =
                                  Utils.nextMonth(_selectedDate);
                                  _selectedDate =
                                      Utils.firstDayOfMonth(getNextMonth);
                                  handleSelectedDateAndUserCallback(
                                      _selectedDate);
                                }
                              });
                            },
                            icon: new Icon(Icons.chevron_right,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ))),
            new Container(
              margin: const EdgeInsets.only(top: 15.0),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              child: new Text(
                _selectedDate.day.toString() +
                    " " +
                    new DateFormat('yMMMM').format(_selectedDate).toString(),
                style: new TextStyle(
                  fontSize: 20.0,
                  color: CueCladThemeUIColor.appBarIconColor,
                ),
              ),
            ),
            new Container(
                width: MediaQuery.of(context).size.width,
                child: new Container(
                  margin: const EdgeInsets.fromLTRB(0.0, 2.0, 16.0, 0.0),
                  alignment: Alignment.bottomRight,
                  child: rightInnerIcon ?? new Container(),
                ))
            // rightOuterIcon ?? new Container(),
          ],
        )
      ],
    );
  }

  Widget get calendarGridView {
    return new Container(
      child: new GestureDetector(
        onHorizontalDragStart: (gestureDetails) => beginSwipe(gestureDetails),
        onHorizontalDragUpdate: (gestureDetails) =>
            getDirection(gestureDetails),
        onHorizontalDragEnd: (gestureDetails) => endSwipe(gestureDetails),
        child: new GridView.count(
          shrinkWrap: true,
          crossAxisCount: 7,
          childAspectRatio: 1.5,
          mainAxisSpacing: 0.0,
          padding: new EdgeInsets.only(bottom: 0.0),
          children: calendarBuilder(),
        ),
      ),
    );
  }

  List<Widget> calendarBuilder() {
    List<Widget> dayWidgets = [];
    List<DateTime> calendarDays =
    isExpanded ? selectedMonthsDays : selectedWeeksDays;

    Utils.weekdays.forEach(
          (day) {
        dayWidgets.add(
          new CalendarTile(
            isDayOfWeek: true,
            dayOfWeek: day,
          ),
        );
      },
    );

    bool monthStarted = false;
    bool monthEnded = false;

    calendarDays.forEach(
          (day) {
        if (monthStarted && day.day == 01) {
          monthEnded = true;
        }

        if (Utils.isFirstDayOfMonth(day)) {
          monthStarted = true;
        }

        if (this.widget.dayBuilder != null) {
          dayWidgets.add(
            new CalendarTile(
              child: this.widget.dayBuilder(context, day),
            ),
          );
        } else {
          dayWidgets.add(
            new CalendarTile(
              onDateSelected: () => handleSelectedDateAndUserCallback(day),
              date: day,
              dateStyles: configureDateStyle(monthStarted, monthEnded),
              isSelected: Utils.isSameDay(selectedDate, day),
            ),
          );
        }
      },
    );
    return dayWidgets;
  }

  TextStyle configureDateStyle(monthStarted, monthEnded) {
    TextStyle dateStyles;
    if (isExpanded) {
      dateStyles = monthStarted && !monthEnded
          ? new TextStyle(color: Colors.black)
          : new TextStyle(color: Colors.black38);
    } else {
      dateStyles = new TextStyle(color: Colors.black);
    }
    return dateStyles;
  }

  Widget get expansionButtonRow {
    if (widget.isExpandable) {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(Utils.fullDayFormat(selectedDate)),
          new IconButton(
            iconSize: 20.0,
            padding: new EdgeInsets.all(0.0),
            onPressed: toggleExpanded,
            icon: isExpanded
                ? new Icon(Icons.arrow_drop_up)
                : new Icon(Icons.arrow_drop_down),
          ),
        ],
      );
    } else {
      return new Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[nameAndIconRow, expansionButtonRow],
      ),
    );
  }

  void resetToToday() {
    today = new DateTime.now();
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(today);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(today);

    setState(() {
      _selectedDate = today;
      selectedWeeksDays =
          Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList();
      displayMonth = Utils.formatMonth(Utils.firstDayOfWeek(today));
    });

    _launchDateSelectionCallback(today);
  }

  void nextMonth() {
    setState(() {
      today = Utils.nextMonth(today);
      var firstDateOfNewMonth = Utils.firstDayOfMonth(today);
      var lastDateOfNewMonth = Utils.lastDayOfMonth(today);
      updateSelectedRange(firstDateOfNewMonth, lastDateOfNewMonth);
      selectedMonthsDays = Utils.daysInMonth(today);
      displayMonth = Utils.formatMonth(Utils.firstDayOfWeek(today));
    });
  }

  void previousMonth() {
    setState(() {
      today = Utils.previousMonth(today);
      var firstDateOfNewMonth = Utils.firstDayOfMonth(today);
      var lastDateOfNewMonth = Utils.lastDayOfMonth(today);
      updateSelectedRange(firstDateOfNewMonth, lastDateOfNewMonth);
      selectedMonthsDays = Utils.daysInMonth(today);
      displayMonth = Utils.formatMonth(Utils.firstDayOfWeek(today));
    });
  }

  void nextWeek() {
    setState(() {
      today = Utils.nextWeek(today);
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(today);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(today);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeeksDays =
          Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList()
              .sublist(0, 7);
      displayMonth = Utils.formatMonth(Utils.firstDayOfWeek(today));
    });
  }

  void previousWeek() {
    setState(() {
      today = Utils.previousWeek(today);
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(today);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(today);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeeksDays =
          Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList()
              .sublist(0, 7);
      displayMonth = Utils.formatMonth(Utils.firstDayOfWeek(today));
    });
  }

  void updateSelectedRange(DateTime start, DateTime end) {
    selectedRange = new Tuple2<DateTime, DateTime>(start, end);
    if (widget.onSelectedRangeChange != null) {
      widget.onSelectedRangeChange(selectedRange);
    }
  }

  Future<Null> selectDateFromPicker() async {
    DateTime selected = await showDatePicker1(
      context: context,
      initialDate: _selectedDate ?? new DateTime.now(),
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );

    if (selected != null) {
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(selected);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(selected);

      setState(() {
        _selectedDate = selected;
        selectedWeeksDays =
            Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
                .toList();
        selectedMonthsDays = Utils.daysInMonth(selected);
        displayMonth = Utils.formatMonth(Utils.firstDayOfWeek(selected));
      });

      _launchDateSelectionCallback(selected);
    }
  }

  var gestureStart;
  var gestureDirection;
  void beginSwipe(DragStartDetails gestureDetails) {
    gestureStart = gestureDetails.globalPosition.dx;
  }

  void getDirection(DragUpdateDetails gestureDetails) {
    if (gestureDetails.globalPosition.dx < gestureStart) {
      gestureDirection = 'rightToLeft';
    } else {
      gestureDirection = 'leftToRight';
    }
  }

  void endSwipe(DragEndDetails gestureDetails) {
    if (gestureDirection == 'rightToLeft') {
      if (isExpanded) {
        nextMonth();
      } else {
        nextWeek();
      }
    } else {
      if (isExpanded) {
        previousMonth();
      } else {
        previousWeek();
      }
    }
  }

  void toggleExpanded() {
    if (widget.isExpandable) {
      setState(() => isExpanded = !isExpanded);
    }
  }

  void handleSelectedDateAndUserCallback(DateTime day) {
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(day);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(day);
    setState(() {
      _selectedDate = day;
      selectedWeeksDays =
          Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList();
    });
    _launchDateSelectionCallback(day);
  }

  void _launchDateSelectionCallback(DateTime day) {
    if (widget.onDateSelected != null) {
      widget.onDateSelected(day);
    }
  }
}

class ExpansionCrossFade extends StatelessWidget {
  final Widget collapsed;
  final Widget expanded;
  final bool isExpanded;

  ExpansionCrossFade({this.collapsed, this.expanded, this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return new Flexible(
      flex: 1,
      child: new AnimatedCrossFade(
        firstChild: collapsed,
        secondChild: expanded,
        firstCurve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.decelerate,
        crossFadeState:
        isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}
