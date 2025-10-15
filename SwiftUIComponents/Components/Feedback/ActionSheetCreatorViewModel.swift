
import SwiftUI

@MainActor
class ActionSheetCreatorViewModel: ObservableObject {
    @Published var title = "Action Sheet Title"
    @Published var message: String? = "This is the action sheet message."
    @Published var buttons: [AlertButton] = [AlertButton()]
    @Published var showActionSheet = false

    func addButton() {
        guard buttons.count < 5 else { return }
        buttons.append(AlertButton())
    }

    func removeButton() {
        guard buttons.count > 1 else { return }
        buttons.removeLast()
    }

    func show() {
        showActionSheet = true
    }
}
