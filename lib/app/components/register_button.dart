import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback onPressed;
  RegisterButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: const EdgeInsets.symmetric(vertical: 12.0),
        child: new Material(
            elevation: 5.0,
            child: new MaterialButton(
                color: Theme.of(context).primaryColor,
                height: 42.0,
                child: new Text(
                    'Create New Account',
                    style: new TextStyle(
                        color: Colors.white
                    )
                ),
                onPressed: onPressed
            )
        )
    );
  }

}