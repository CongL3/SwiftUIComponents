import SwiftUI

@MainActor
class ConfirmationDialogCreatorViewModel: ObservableObject {
    @Published var title = "Confirmation Dialog Title"
    @Published var message: String? = "This is the confirmation dialog message."
    @Published var buttons: [AlertButton] = [AlertButton()]
    @Published var showConfirmationDialog = false

    func addButton() {
        guard buttons.count < 5 else { return }
        buttons.append(AlertButton())
    }

    func removeButton() {
        guard buttons.count > 1 else { return }
        buttons.removeLast()
    }

    func show() {
        showConfirmationDialog = true
    }
}