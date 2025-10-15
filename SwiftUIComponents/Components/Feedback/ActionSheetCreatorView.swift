import SwiftUI

struct ActionSheetCreatorView: View {
    @StateObject private var viewModel = ActionSheetCreatorViewModel()

    var body: some View {
        Form {
            Section(header: Text("Action Sheet Configuration")) {
                Text("ActionSheet is deprecated in iOS 15. Use ConfirmationDialog instead.")
                    .font(.caption)
                    .foregroundColor(.red)
                TextField("Title", text: $viewModel.title)
                TextField("Message", text: $viewModel.message ?? "")
            }

            Section(header: Text("Buttons")) {
                Stepper("Number of Buttons: \(viewModel.buttons.count)", onIncrement: viewModel.addButton, onDecrement: viewModel.removeButton)

                ForEach(viewModel.buttons.indices, id: \.self) { index in
                    VStack {
                        let button = viewModel.buttons[index]
                        let textBinding = Binding<String>(
                            get: { button.text },
                            set: { newText in
                                viewModel.buttons[index].text = newText
                            }
                        )
                        TextField("Button Text", text: textBinding)
                            .id(button.id)
                        Picker("Style", selection: $viewModel.buttons[index].style) {
                            ForEach(AlertButtonStyle.allCases, id: \.self) {
                                Text($0.rawValue.capitalized).tag($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
            }

            Section {
                Button("Show", action: viewModel.show)
            }
        }
        .navigationTitle("Action Sheet Creator")
        .background(Color.clear.actionSheet(isPresented: $viewModel.showActionSheet) {
            let actionSheetButtons = viewModel.buttons.map { button -> ActionSheet.Button in
                switch button.style {
                case .default:
                    return .default(Text(button.text))
                case .destructive:
                    return .destructive(Text(button.text))
                case .cancel:
                    return .cancel(Text(button.text))
                }
            }

            return ActionSheet(
                title: Text(viewModel.title),
                message: viewModel.message.map { Text($0) },
                buttons: actionSheetButtons
            )
        }.id(viewModel.buttons))
    }
}

#Preview {
    ActionSheetCreatorView()
}
