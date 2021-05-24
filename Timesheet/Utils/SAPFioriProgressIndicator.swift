//
// SAPFioriLoadingIndicator.swift
// Timesheet
//
// Created by SAP Business Technology Platform (BTP) SDK for iOS Assistant application on 27/04/18
//

import Foundation
import SAPFiori

protocol SAPFioriProgressIndicator: class {
    var loadingIndicator: FUIModalProcessingIndicatorView? { get set }
}

extension SAPFioriProgressIndicator where Self: UIViewController {
    func showFioriLoadingIndicator(_ message: String = "") {
        OperationQueue.main.addOperation({
            self.loadingIndicator = FUIModalProcessingIndicator.show(inView: self.view)
        })
    }

    func hideFioriLoadingIndicator() {
        OperationQueue.main.addOperation({
            guard let loadingIndicator = self.loadingIndicator else {
                return
            }
            loadingIndicator.dismiss()
        })
    }
}
