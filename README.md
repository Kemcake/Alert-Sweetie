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
  alert.show(onViewController: self, completion: { () -> Void in 
      println("Alert shown")
  })
```

*Objective-C*
``` ObjC
  Alert *alert = [[Alert alloc] initWithTitle:@"A great title" message:@"And of course a nice message"];
  alert.tintColor = [Colors boddyBlue];
  [alert addActionWithTitle:@"Action" style:UIAlertActionStyleDestructive handler:^(NSInteger index) {
      NSLog(@"action %d",index);
  }];
  [alert showOnViewController:self completion:^() {
      NSLog(@"Alert shown");
  }];
```

**You can also use the `show()`method that choose the rootViewController as presenter**

### One more thing

We sometimes need to handle errors, here's a good way. You just have to add strings like this :`Error<#code>` in localized strings to support error translation

```Swift
  let error:NSError?
  Alert.showWithError(error)
```

