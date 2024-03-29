//
// OnboardingManager.swift
//
// Created by SAP Business Technology Platform (BTP) SDK for iOS Assistant application on 04/06/18
//

import SAPCommon
import SAPFiori
import SAPFioriFlows
import SAPFoundation
import WebKit

protocol OnboardingManagerDelegate {
    /// Called either when Onboarding or Restoring is successfully executed.
    func onboarded(onboardingContext: OnboardingContext)
    
    /// Called when Onboarding is about to start - needed by OfflineOData initialization
    func onboardingContextCreated(onboardingContext: OnboardingContext, onboarding: Bool)
}

class OnboardingManager {
    
    // MARK: - Singleton
    
    static let shared = OnboardingManager()
    private init() {}
    
    // MARK: - Properties
    
    private let logger = Logger.shared(named: "OnbardingManager")
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let presentationDelegate = ModalUIViewControllerPresenter()
    private var credentialStore: CompositeCodableStoring!
    private var state: State = .onboarding
    
    private let authPath = ServiceConfiguration.getTimesheetServiceConnectionId()
    private let scpAppId = ServiceConfiguration.getScpAppId()
    private var onboardingContext: OnboardingContext?
    
    var delegate: OnboardingManagerDelegate?
    
    /// Steps executed during Onboarding.
    private var onboardingSteps: [OnboardingStep] {
        return [
            self.configuredWelcomeScreenStep(),
            CompositeStep(steps: SAPcpmsDefaultSteps.configuration),
            self.configuredOAuth2AuthenticationStep(),
            CompositeStep(steps: SAPcpmsDefaultSteps.settingsDownload),
            CompositeStep(steps: SAPcpmsDefaultSteps.applyDuringOnboard),
            self.configuredUserConsentStep(),
            self.configuredStoreManagerStep(),
        ]
    }
    
    /// Steps executed during Restoring.
    private var restoringSteps: [OnboardingStep] {
        return [
            self.configuredStoreManagerStep(),
            self.configuredWelcomeScreenStep(),
            CompositeStep(steps: SAPcpmsDefaultSteps.configuration),
            self.configuredOAuth2AuthenticationStep(),
            CompositeStep(steps: SAPcpmsDefaultSteps.applyDuringRestore),
        ]
    }
    
    // MARK: - Steps
    
    // WelcomeScreenStep
    private func configuredWelcomeScreenStep() -> WelcomeScreenStep {
        let discoveryConfigurationTransformer = DiscoveryServiceConfigurationTransformer(applicationID: scpAppId, authenticationPath: authPath)
        let welcomeScreenStep = WelcomeScreenStep(transformer: discoveryConfigurationTransformer, providers: [FileConfigurationProvider()])
        
        welcomeScreenStep.welcomeScreenCustomizationHandler = { welcomeStepUI in
            welcomeStepUI.headlineLabel.text = "Offline Timesheet Sample App"
            welcomeStepUI.detailLabel.text = NSLocalizedString("keyWelcomeScreenMessage",
                                                               value: "This application demonstrates the extensibility of a S/4 HANA Cloud System with offline capabilities",
                                                               comment: "XMSG: Message on WelcomeScreen")
            welcomeStepUI.primaryActionButton.titleLabel?.text = NSLocalizedString("keyWelcomeScreenStartButton",
                                                                                   value: "Start",
                                                                                   comment: "XBUT: Title of start button on WelcomeScreen")
            welcomeStepUI.isDemoModeAvailable = false
        }
        return welcomeScreenStep
    }
    
    // UserConsentStep
    private func configuredUserConsentStep() -> UserConsentStep {
        // Content consists of two forms - a single page form first and then a multi page form
        
        // Content for the single page form
        let spTitle = "Data Privacy"
        let spText = "Detailed text about how data privacy pertains to this app and why it is important for the user to enable this functionality"
        let spActionTitle = "Learn more about Data Privacy"
        
        var spPageContent = UserConsentPageContent()
        spPageContent.title = spTitle
        spPageContent.actionTitle = spActionTitle
        spPageContent.body = spText
        let spFormContent = UserConsentFormContent(version: "one", isRequired: true, pages: [spPageContent])
        
        // Content for the multi Page form
        let mpTitle1 = "Data Privacy"
        let mpText1 = "Detailed text about how data privacy pertains to this app and why it is important for the user to enable this functionality"
        let mpActionTitle1 = "Learn more about Data Privacy"
        var mpPageContent1 = UserConsentPageContent()
        mpPageContent1.title = mpTitle1
        mpPageContent1.actionTitle = mpActionTitle1
        mpPageContent1.body = mpText1
        
        let mpTitle2 = "Security"
        let mpText2 = "Detailed text about how data privacy pertains to this app and why it is important for the user to enable this functionality"
        let mpActionTitle2 = "Learn more about Data Privacy"
        var mpPageContent2 = UserConsentPageContent()
        mpPageContent2.title = mpTitle2
        mpPageContent2.actionTitle = mpActionTitle2
        mpPageContent2.body = mpText2
        
        let mpTitle3 = "Consent"
        let mpText3 = "Detailed text about how data privacy pertains to this app and why it is important for the user to enable this functionality"
        let mpActionTitle3 = "Learn more about Data Privacy"
        var mpPageContent3 = UserConsentPageContent()
        mpPageContent3.title = mpTitle3
        mpPageContent3.actionTitle = mpActionTitle3
        mpPageContent3.body = mpText3
        
        let mpFormContent = UserConsentFormContent(version: "one", isRequired: true, pages: [mpPageContent1, mpPageContent2, mpPageContent3])
        return UserConsentStep(userConsentFormsContent: [spFormContent, mpFormContent])
    }
    // OAuth2AuthenticationStep
    private func configuredOAuth2AuthenticationStep() -> OAuth2AuthenticationStep {
        let presenter = FioriWKWebViewPresenter(webViewDelegate: self)
        let oAuth2AuthenticationStep = OAuth2AuthenticationStep(presenter: presenter)        
        return oAuth2AuthenticationStep
    }
    
    // StoreManagerStep
    private func configuredStoreManagerStep() -> StoreManagerStep {
        let step = StoreManagerStep()
        // Don’t use a local default passcode policy, but load passcode policy from server. If passcode policy is disabled on the server, the app won’t be protected with a passcode
        step.defaultPasscodePolicy = nil
        return step
    }
    
    // MARK: - Onboarding
    
    /// Starts Onboarding or Restoring flow.
    /// - Note: This function changes the `rootViewController` to a splash screen before starting the flow.
    /// The `rootViewController` is expected to be switched back by the caller.
    func onboardOrRestore() {
        // Set the spalsh screen
        let splashViewController = FUIInfoViewController.createSplashScreenInstanceFromStoryboard()
        self.appDelegate.window!.rootViewController = splashViewController
        self.presentationDelegate.setSplashScreen(splashViewController)
        self.presentationDelegate.animated = true
        
        self.onboardOrRestoreWithoutSplashScreen()
    }
    
    /// Starts Onboarding or Restoring flow without displaying a splash screen.
    /// - Note: Should be called when the application screen is already hidden,
    /// for example after `onboardOrRestore` has already been called, like in case of reseting.
    private func onboardOrRestoreWithoutSplashScreen() {
        self.state = .onboarding
        var context = OnboardingContext(presentationDelegate: presentationDelegate)
        
        // Check if we have an existing onboardingID
        if let onboardingID = self.onboardingID {
            self.logger.info("Restoring...")
            
            self.delegate?.onboardingContextCreated(onboardingContext: context, onboarding: false)
            self.onboardingContext = context
            context.onboardingID = onboardingID
            OnboardingFlowController.restore(on: self.restoringSteps, context: context, completionHandler: self.restoreCompleted)
        } else {
            self.logger.info("Onboarding...")
            
            self.delegate?.onboardingContextCreated(onboardingContext: context, onboarding: true)
            OnboardingFlowController.onboard(on: self.onboardingSteps, context: context, completionHandler: self.onboardingCompleted)
        }
    }
    
    /// Resets the Onboarding flow and than calls `onboardOrRestoreWithoutSplashScreen` to start a new flow.
    private func resetOnboarding() {
        self.logger.info("Resetting...")
        
        guard let onboardingID = self.onboardingID else {
            self.clearUserData()
            self.onboardOrRestoreWithoutSplashScreen()
            return
        }
        
        let context = OnboardingContext(onboardingID: onboardingID)
        OnboardingFlowController.reset(on: self.restoringSteps, context: context) {
            self.clearUserData()
            
            self.onboardingID = nil
            self.onboardOrRestoreWithoutSplashScreen()
        }
    }
    
    // MARK: - Completion Handlers
    
    private func onboardingCompleted(_ result: OnboardingResult) {
        switch result {
        case let .success(context):
            self.logger.info("Successfully onboarded.")
            self.finalizeOnboarding(context)
            
        case let .failed(error):
            self.logger.error("Onboarding failed!", error: error)
            self.clearUserData()
            self.onboardFailed(error)
        @unknown default: FUIToastMessage.show(message: "Could not Onboard")
        }
    }
    
    private func restoreCompleted(_ result: OnboardingResult) {
        switch result {
        case let .success(context):
            self.logger.info("Successfully restored.")
            self.finalizeOnboarding(context)
            
        case let .failed(error):
            self.logger.error("Restoring failed!", error: error)
            self.restoreFailed(error)
        @unknown default: FUIToastMessage.show(message: "Could not Onboard")
        }
    }
    
    private func finalizeOnboarding(_ context: OnboardingContext) {
        self.state = .running
        
        self.credentialStore = context.credentialStore
        self.onboardingID = context.onboardingID
        
        self.presentationDelegate.clearSplashScreen()
        self.presentationDelegate.animated = false
        
        self.delegate?.onboarded(onboardingContext: context)
    }
    
    // MARK: - Error Handlers
    
    private func onboardFailed(_ error: Error) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        var title: String!
        var message: String!
        
        title = NSLocalizedString("keyErrorLogonProcessFailedTitle",
                                      value: "Failed to logon!",
                                      comment: "XTIT: Title of alert message about logon process failure.")
        message = error.localizedDescription

        let retryTitle = NSLocalizedString("keyRetryButtonTitle", value: "Retry", comment: "XBUT: Title of Retry button.")
        alertController.addAction(UIAlertAction(title: retryTitle, style: .default) { _ in
            // There is no need to call reset in case onboarding fails, since it is called by the SDK.
            self.onboardOrRestore()
        })
        
        // Set title and message
        alertController.title = title
        alertController.message = message
        
        // Present the alert
        OperationQueue.main.addOperation({
            ModalUIViewControllerPresenter.topPresentedViewController()?.present(alertController, animated: true)
        })
    }
    
    private func restoreFailed(_ error: Error) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        var title: String!
        var message: String!
        
        switch error {
        case StoreManagerError.cancelPasscodeEntry:
            fallthrough
        case StoreManagerError.skipPasscodeSetup:
            fallthrough
        case StoreManagerError.resetPasscode:
            self.resetOnboarding()
            return
            
        case StoreManagerError.passcodeRetryLimitReached:
            title = NSLocalizedString("keyErrorPasscodeRetryLimitReachedTitle",
                                      value: "Passcode Retry Limit Reached!",
                                      comment: "XTIT: Title of alert action that the passcode retry limit has been reached.")
            message = NSLocalizedString("keyErrorPasscodeRetryLimitReachedMessage",
                                        value: "Reached the maximum number of retries. Application should be reset.",
                                        comment: "XMSG: Message that the application shall be reseted because the passcode retry limit has been reached.")
            
            let resetActionTitle = NSLocalizedString("keyResetButtonTitle", value: "Reset", comment: "XBUT: Reset button title.")
            alertController.addAction(UIAlertAction(title: resetActionTitle, style: .destructive) { _ in
                self.resetOnboarding()
            })
            
        default:
            title = NSLocalizedString("keyErrorLogonProcessFailedTitle",
                                      value: "Failed to logon!",
                                      comment: "XTIT: Title of alert message about logon process failure.")
            message = error.localizedDescription
            
            let retryTitle = NSLocalizedString("keyRetryButtonTitle", value: "Retry", comment: "XBUT: Title of Retry button.")
            alertController.addAction(UIAlertAction(title: retryTitle, style: .default) { _ in
                self.onboardOrRestore()
            })
            
            let resetActionTitle = NSLocalizedString("keyResetButtonTitle", value: "Reset", comment: "XBUT: Reset button title.")
            alertController.addAction(UIAlertAction(title: resetActionTitle, style: .destructive) { _ in
                self.resetOnboarding()
            })
        }
        
        // Set title and message
        alertController.title = title
        alertController.message = message
        
        // Present the alert
        OperationQueue.main.addOperation({
            ModalUIViewControllerPresenter.topPresentedViewController()?.present(alertController, animated: true)
        })
    }
    
    /// Clears any locally stored user data.
    private func clearUserData() {
        // Currently we only have to clear the shared URLCache and the shared HTTPCookieStorage,
        // but you might want to clear more data.
        URLCache.shared.removeAllCachedResponses()
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
    }
}

// MARK: - Managing the OnboardingID

extension OnboardingManager {
    private enum UserDefaultsKeys {
        static let onboardingId = "keyOnboardingID"
    }
    
    private var onboardingID: UUID? {
        get {
            guard let storedOnboardingID = UserDefaults.standard.string(forKey: UserDefaultsKeys.onboardingId),
                let onboardingID = UUID(uuidString: storedOnboardingID) else {
                    // There is no OnboardingID stored yet
                    return nil
            }
            return onboardingID
        }
        
        set {
            if let newOnboardingID = newValue {
                // If non-nil value is set, store it in UserDefaults
                UserDefaults.standard.set(newOnboardingID.uuidString, forKey: UserDefaultsKeys.onboardingId)
            } else {
                // If nil value is set, clear previous from UserDefaults
                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.onboardingId)
            }
        }
    }
}

// MARK: - Handling application put to background

extension OnboardingManager {
    private enum State {
        /// Application is either in the Onboarding or Restoring state.
        case onboarding
        /// Application is running in the foreground.
        case running
        /// Application is locked in the background.
        case locked
        /// Application has brought to the front to unlock.
        case unlocking
    }
    
    private var shouldLock: Bool {
        return self.state == .running
    }
    
    /// Handle application put to the background. Displays a lockscreen if the application can be locked to hide any sensitive information.
    func applicationDidEnterBackground() {
        guard self.shouldLock else {
            return
        }
        
        self.lockApplication()
    }
    
    /// Displays a view to hide sensitive information.
    private func lockApplication() {
        self.logger.info("Locking the application.")
        self.state = .locked
        
        // Present the SnapshotScreen
        let snapshotViewController = SnapshotViewController()
        guard let topViewController = ModalUIViewControllerPresenter.topPresentedViewController() else {
            fatalError("Could not present the SnapshotScreen to hide sensitive inforamtion.")
        }
        topViewController.present(snapshotViewController, animated: false)
    }
    
    private var shouldUnlock: Bool {
        return self.state == .locked
    }
    
    /// Handle application brought to foreground. If applicable, displays the unlock screen.
    func applicationWillEnterForeground() {
        guard self.shouldUnlock else {
            return
        }
        
        self.unlockApplication()
    }
    
    /// Present the unlock screen.
    private func unlockApplication() {
        self.logger.info("Unlocking the application.")
        guard let onboardingID = self.onboardingID else {
            self.logger.error("OnboardingID is required to unlock.")
            return
        }
        
        self.state = .unlocking
        
        // Dismiss SnapshotScreen
        guard let topViewController = ModalUIViewControllerPresenter.topPresentedViewController() else {
            self.logger.error("Could not find top ViewController for unlocking.")
            return
        }
        
        topViewController.dismiss(animated: false) {
            // Present the SplashScreen
            let splashViewController = FUIInfoViewController.createSplashScreenInstanceFromStoryboard()
            self.presentationDelegate.present(splashViewController) { error in
                if let error = error {
                    fatalError("Could not present SplashScreen, terminating the app to hide sensitive information. \(error)")
                }
                self.presentationDelegate.setSplashScreen(splashViewController)
                
                // Calling StoreManagerStep for passcode validation. This will display the PasscodeScreen.
                let context = OnboardingContext(onboardingID: onboardingID, credentialStore: self.credentialStore, presentationDelegate: self.presentationDelegate)
                StoreManagerStep().restore(context: context, completionHandler: self.unlockCompleted)
            }
        }
    }
    
    private func unlockCompleted(_ result: OnboardingResult) {
        switch result {
        case .success:
            self.state = .running
            // Dissmiss the SplashScreen, the PasscodeScreen is automatically dismissed.
            OperationQueue.main.addOperation {
                self.presentationDelegate.dismiss { _ in } // Passing an empty completionHandler
            }
            
        case let .failed(error):
            self.unlockFailed(error)
        @unknown default: FUIToastMessage.show(message: "Could not Onboard")
        }
    }
    
    private func unlockFailed(_ error: Error) {
        let title = NSLocalizedString("keyFailedToUnlockTitle", value: "Failed to unlock!", comment: "XTIT: Failed to unlock alert title.")
        let alertViewController = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        
        let resetActionTitle = NSLocalizedString("keyResetButtonTitle", value: "Reset", comment: "XBUT: Reset button title.")
        alertViewController.addAction(UIAlertAction(title: resetActionTitle, style: .destructive) { _ in
            self.resetOnboarding()
        })
        
        OperationQueue.main.addOperation {
            ModalUIViewControllerPresenter.topPresentedViewController()?.present(alertViewController, animated: true)
        }
    }
}

// MARK: - SAPWKNavigationDelegate

// The WKWebView occasionally returns an NSURLErrorCancelled error if a redirect happens too fast.
// In case of OAuth with SAP's identity provider (IDP) we do not treat this as an error.
extension OnboardingManager: SAPWKNavigationDelegate {
    func webView(_: WKWebView, handleFailed _: WKNavigation!, withError error: Error) -> Error? {
        if self.isCancelledError(error) {
            return nil
        }
        return error
    }
    
    func webView(_: WKWebView, handleFailedProvisionalNavigation _: WKNavigation!, withError error: Error) -> Error? {
        if self.isCancelledError(error) {
            return nil
        }
        return error
    }
    
    private func isCancelledError(_ error: Error) -> Bool {
        let nsError = error as NSError
        return nsError.domain == NSURLErrorDomain &&
            nsError.code == NSURLErrorCancelled
    }
}
