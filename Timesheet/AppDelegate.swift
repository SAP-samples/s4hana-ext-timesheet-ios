//
// AppDelegate.swift
// Timesheet
//
// Created by SAP Business Technology Platform (BTP) SDK for iOS Assistant application on 27/04/18
//

import SAPFiori
import SAPFioriFlows
import SAPFoundation
import SAPOData
import SAPCommon

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, OnboardingManagerDelegate {
        var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Set a FUIInfoViewController as the rootViewController, since there it is none set in the Main.storyboard
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = FUIInfoViewController.createSplashScreenInstanceFromStoryboard()

        UINavigationBar().applyFioriStyle()

        UINavigationBar.appearance().shadowImage = UIImage()
        
        Logger.root.add(handler: ConsoleLogHandler())

        OnboardingManager.shared.delegate = self
        OnboardingManager.shared.onboardOrRestore()

        return true
    }

    // To only support portrait orientation during onboarding
    func application(_: UIApplication, supportedInterfaceOrientationsFor _: UIWindow?) -> UIInterfaceOrientationMask {
        switch OnboardingFlowController.presentationState {
        case .onboarding, .restoring:
            return .portrait
        default:
            return .allButUpsideDown
        }
    }

    // Delegate to OnboardingManager.
    func applicationDidEnterBackground(_: UIApplication) {
        OnboardingManager.shared.applicationDidEnterBackground()
    }

    // Delegate to OnboardingManager.
    func applicationWillEnterForeground(_: UIApplication) {
        OnboardingManager.shared.applicationWillEnterForeground()
    }
    
    // Onboarding delegagte
    
    func onboardingContextCreated(onboardingContext: OnboardingContext, onboarding: Bool) {
        
    }
    
    func onboarded(onboardingContext: OnboardingContext) {
        TimeSheetAppServiceFactory.initSharedInstance(sapUrlSession: onboardingContext.sapURLSession)
        self.setRootViewController()
    }

    private func setRootViewController() {
        DispatchQueue.main.async {
            let vc = ViewControllerFactory.createTimesheetViewController()
            let nvc = UINavigationController(navigationBarClass: FUINavigationBar.self, toolbarClass: nil)
            self.window!.rootViewController = nvc
            nvc.viewControllers = [vc]
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        ServiceFactory.getOfflineService().closeOfflineStore()
    }

}
