import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
   if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
      }

    GeneratedPluginRegistrant.register(with: self)
            UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*30))
      
      NotificationCenter.default.addObserver(
          forName: UIApplication.userDidTakeScreenshotNotification,
          object: nil,
          queue: .main) { notification in
              self.alertWithAction(title: "Screen Shot", message: "Screen shots not allowed!", actionTitle: "OK", completion: {
                  UIApplication.shared.windows.first?.rootViewController?.view.isHidden = false
              })
      }
      NotificationCenter.default.addObserver(
          forName: UIScreen.capturedDidChangeNotification,
          object: nil,
          queue: .main) { notification in
              let isCaptured = UIScreen.main.isCaptured
              if isCaptured {
                  self.alertWithAction(title: "Screen Record", message: "Screen records not allowed please close it and resume!", actionTitle: "OK", completion: {
                      //
                  })
              } else {
                  UIApplication.shared.windows.first?.rootViewController?.view.isHidden = false

              }
      }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func alertWithAction (title: String, message: String, actionTitle: String, completion: @escaping () -> () ) {
        UIApplication.shared.windows.first?.rootViewController?.view.isHidden = true
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { action in
            completion()
        }
        alert.addAction(action)
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
  // <Add>
    override func applicationWillResignActive(
      _ application: UIApplication
    ) {
      self.window.isHidden = true;
    }
    override func applicationDidBecomeActive(
      _ application: UIApplication
    ) {
      self.window.isHidden = false;
    }

}
