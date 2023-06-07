import 'package:eip_test/Pages/SubPage/ActionPage/list_action.dart';
import 'package:eip_test/Pages/SubPage/ReactionPage/list_reaction.dart';
import 'package:flutter/material.dart';

class MyActionReactionBottomButton extends StatelessWidget {
  const MyActionReactionBottomButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox(height: 12),
              SizedBox(
                width: 150.0,
                height: 50.0,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ListReactionPage()));
                  },
                  icon: const Icon(Icons.add),
                  label: const Text(
                    "Reaction",
                  ),
                ),
              ),
              SizedBox(
                width: 150.0,
                height: 50.0,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ListActionPage()));
                  },
                  icon: const Icon(Icons.add),
                  label: const Text(
                    "Action",
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
