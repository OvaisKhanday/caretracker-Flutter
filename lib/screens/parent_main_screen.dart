import 'package:caretracker/screens/parent_tracking_screen.dart';
import 'package:caretracker/widgets/button_widgets.dart';
import 'package:caretracker/widgets/svg_widgets.dart';
import 'package:caretracker/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

class ParentMainScreen extends StatefulWidget {
  const ParentMainScreen({super.key});

  @override
  State<ParentMainScreen> createState() => _ParentMainScreenState();
}

class _ParentMainScreenState extends State<ParentMainScreen> {
  final busSvgAssetName = 'assets/svgs/bus.svg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        schoolNameWidget(schoolName: 'Apple Bird School'),
        const SizedBox(height: 12),
        titleTextWidget(title: 'welcome'),
        titleTextWidget(title: 'Ovais Ahmad Khanday'),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
          child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  titleTextWidget(title: 'child 1 name goes here'),
                  const SizedBox(height: 6),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                          ),
                          child: Text('female'),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: Text('12th'),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: Text('789'),
                        )
                      ]),
                  const SizedBox(height: 24),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 12),
                        Expanded(
                            child:
                                Center(child: bigBusNoTextWidget(busNo: '24'))),
                        Expanded(
                            child: svgHeadlineWidget(
                                context: context,
                                assetName: busSvgAssetName,
                                height: 60)),
                        Expanded(
                            child: Center(
                                child: titleTextWidget(title: 'JK08H4848')))
                      ]),
                  const SizedBox(height: 6),
                  titleTextWidget(title: 'Driver goes here'),
                  phoneIconWithNumber(phone: '4578962136'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                      style: ButtonStyle(
                        padding: const MaterialStatePropertyAll(
                            EdgeInsets.fromLTRB(60, 12, 60, 12)),
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.primary),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ParentTrackingScreen()));
                      },
                      child: Text(
                        'track',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      )),
                ],
              )),
        ),
        const SizedBox(height: 12),
        smallButtonWidget(
            context: context,
            icon: Icons.refresh_rounded,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            iconColor: Theme.of(context).colorScheme.onSecondary,
            onPressed: () {}),
        const SizedBox(height: 12),
        logoutButtonWidget(
            context: context,
            buttonText: 'logout',
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    )));
  }
}
