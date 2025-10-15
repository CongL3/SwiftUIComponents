import SwiftUI

struct CreatorDetailView: View {
    let component: ComponentModel

    var body: some View {
        VStack {
            switch component.id {
            case "AlertCreator":
                AlertCreatorView()
            case "ActionSheetCreator":
                ActionSheetCreatorView()
            case "ConfirmationDialogCreator":
                ConfirmationDialogCreatorView()
            default:
                Text("Creator view not found.")
            }
        }
        .navigationTitle(component.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }
}
