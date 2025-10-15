import SwiftUI



@MainActor
class AlertCreatorViewModel: ObservableObject {
    @Published var title = "Alert Title"
    @Published var message = "This is the alert's message."
    @Published var buttons: [AlertButton] = [AlertButton()]
    
    @Published var alertDetails: AlertDetails?

    func addButton() {
        guard buttons.count < 10 else { return } // Modern alerts can have more buttons
        buttons.append(AlertButton())
    }

    func removeButton() {
        guard buttons.count > 1 else { return }
        buttons.removeLast()
    }

    func show() {
        alertDetails = AlertDetails(title: title, message: message, buttons: buttons)
    }
}