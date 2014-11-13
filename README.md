RSAlert
=======

A Swift class that shows an UIAlertView or UIAlertController depending on iOS version.

You can use it on both iOS 7 and iOS 8, it will choose the good way to show an alert.

It also bring block to standard UIAlertView ;)

### How to use
*Swift*
``` Swift
  let alert = Alert(title: "A great title", message: "And of course a nice message")
  alert.addAction(title: "ok", style: .Cancel, handler: {(index: Int) -> Void in
      println("Action \(index)")
  })
  alert.tintColor = Colors.boddyBlue()
  alert.show(onViewController: self)
```

*Objective-C*
``` Objective-C
  Alert *alert = [[Alert alloc] initWithTitle:@"A great title" message:@"And of course a nice message"];
  alert.tintColor = [Colors boddyBlue];
  [alert addActionWithTitle:@"Action" style:UIAlertActionStyleDestructive handler:^(NSInteger index) {
      NSLog(@"action %d",index);
  }];
  [alert showOnViewController:self];
```
