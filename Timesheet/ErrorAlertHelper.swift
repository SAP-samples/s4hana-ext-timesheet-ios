import Foundation
import UIKit
import SAPOData

class ErrorAlertHelper {
    
    public static func showCouldNotFetchDataError(_ error: Error?, presentingViewController: UIViewController?) {
        guard let error = error, let presentingViewController = presentingViewController else {
            return
        }
        
        let alert = ErrorAlertHelper.createErrorAlertForDataFetchError(error: error)
        presentingViewController.present(alert, animated: true)
    }
    
    public static func showCouldNotUploadOfflineStoreError(_ error: Error?, presentingViewController: UIViewController?) {
        guard let error = error, let presentingViewController = presentingViewController else {
            return
        }
        
        let alert = ErrorAlertHelper.createErrorAlertForOfflineStoreUpload(error: error)
        presentingViewController.present(alert, animated: true)
    }
    
    public static func showCouldNotCreateTaskError(_ error: Error?, presentingViewController: UIViewController?) {
        guard let error = error, let presentingViewController = presentingViewController else {
            return
        }
        
        let alert = ErrorAlertHelper.createErrorAlertForTaskCreation(error: error)
        presentingViewController.present(alert, animated: true)
    }
    
    public static func showCouldNotOpenOfflineStoreError(_ error: Error?, presentingViewController: UIViewController?) {
        guard let error = error, let presentingViewController = presentingViewController else {
            return
        }
        
        let alert = ErrorAlertHelper.createErrorAlertForOpeningOfflineStore(error: error)
        presentingViewController.present(alert, animated: true)
    }
    
    public static func createErrorAlertForOfflineStoreUpload(error: Error?) -> UIAlertController {
        if let alert = tryToCreateAlertWithErrorMessageFromError(error: error) {
            return alert
        }
        else {
            return createGenericOfflineUploadError()
        }
    }
    
    public static func createErrorAlertForTaskCreation(error: Error?) -> UIAlertController {
        if let alert = tryToCreateAlertWithErrorMessageFromError(error: error) {
            return alert
        }
        else {
            return createGenericTaskCreationError()
        }
    }
    
    public static func createErrorAlertForDataFetchError(error: Error?) -> UIAlertController {
        if let alert = tryToCreateAlertWithErrorMessageFromError(error: error) {
            return alert
        }
        else {
            return createGenericDataFetchError()
        }
    }
    
    public static func createErrorAlertForOpeningOfflineStore(error: Error?) -> UIAlertController {
        if let alert = tryToCreateAlertWithErrorMessageFromError(error: error) {
            return alert
        }
        else {
            return createGenericOfflineStoreOpenError()
        }
    }
    
    private static func tryToCreateAlertWithErrorMessageFromError(error: Error?) -> UIAlertController? {
        if (error as? DataNetworkError) != nil {
            return createNetworkIssueErrorAlert()
        }
        else if let errorMessage = (error as? DataServiceError)?.response?.message {
            return createAlert(withErrorMessage: errorMessage)
        }
        else if let errorMessage = error?.localizedDescription {
            return createAlert(withErrorMessage: errorMessage)
        }
        
        return nil
    }
    
    private static func createNetworkIssueErrorAlert() -> UIAlertController {
        let title = NSLocalizedString("dataFetchNetworkErrorTitle", value: "Network Error", comment: "Title of the network error alert")
        let message = NSLocalizedString("dataFetchNetworkErrorMessage", value: "A network related error occured. Please check you network connection and try again.", comment: "Message of the network error alert")
        
        return SimpleAlertBuilder()
            .title(title)
            .message(message)
            .build()
    }
    
    private static func createGenericDataFetchError() -> UIAlertController {
        let title = NSLocalizedString("dataFetchGenericErrorTitle", value: "Error", comment: "Title of the error alert which shows the user that a data fetch operation failed")
        let message = NSLocalizedString("dataFetchGenericErrorMessage", value: "Could not fetch data. Please try again later.", comment: "Message of the error alert which shows the user that a data fetch operation failed")
        
        return SimpleAlertBuilder()
            .title(title)
            .message(message)
            .build()
    }
    
    private static func createGenericOfflineUploadError() -> UIAlertController {
        let title = NSLocalizedString("offlineUploadGenericErrorTitle", value: "Error", comment: "Title of the error alert which shows the user that the offline upload operation failed")
        let message = NSLocalizedString("offlineUploadGenericErrorMessage", value: "Could not upload offline store.", comment: "Message of the error alert which shows the user that the offline upload operation failed")
        
        return SimpleAlertBuilder()
            .title(title)
            .message(message)
            .build()
    }
    
    private static func createGenericTaskCreationError() -> UIAlertController {
        let title = NSLocalizedString("taskCreationGenericErrorTitle", value: "Error", comment: "Title of the error alert which shows the user that the task creation failed")
        let message = NSLocalizedString("taskCreationGenericErrorMessage", value: "Could not create task.", comment: "Message of the error alert which shows the user that the task creation failed")
        
        return SimpleAlertBuilder()
            .title(title)
            .message(message)
            .build()
    }
    
    private static func createGenericOfflineStoreOpenError() -> UIAlertController {
        let title = NSLocalizedString("openingOfflineStoreGenericErrorTitle", value: "Error", comment: "Title of the error alert which shows the user that opening the offline store failed")
        let message = NSLocalizedString("openingOfflineStoreGenericErrorMessage", value: "Could not open the offline store.", comment: "Message of the error alert which shows the user that opening the offline store failed")
        
        return SimpleAlertBuilder()
            .title(title)
            .message(message)
            .build()
    }
    
    private static func createAlert(withErrorMessage errorMessage: String) -> UIAlertController {
        let title = NSLocalizedString("errorTitleKey", value: "Error", comment: "Generic error alert title")
        let message = errorMessage
        
        return SimpleAlertBuilder()
            .title(title)
            .message(message)
            .build()
    }
    
}
