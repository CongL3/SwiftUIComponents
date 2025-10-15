import SwiftUI

struct ConfirmationDialogCreatorView: View {
    @StateObject private var viewModel = ConfirmationDialogCreatorViewModel()

    var body: some View {
        Form {
            Section(header: Text("Confirmation Dialog Configuration")) {
                TextField("Title", text: $viewModel.title)
                TextField("Message", text: $viewModel.message ?? "")
            }

            Section(header: Text("Buttons")) {
                Stepper("Number of Buttons: \(viewModel.buttons.count)", onIncrement: viewModel.addButton, onDecrement: viewModel.removeButton)

                ForEach(viewModel.buttons.indices, id: \.self) { index in
                    VStack {
                        TextField("Button Text", text: $viewModel.buttons[index].text)
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
        .navigationTitle("Confirmation Dialog Creator")
        .confirmationDialog(viewModel.title, isPresented: $viewModel.showConfirmationDialog, titleVisibility: .visible) {
            ForEach(viewModel.buttons) { button in
                Button(button.text, role: button.style.buttonRole) {
                    // Action
                }
            }
        } message: {
            if let message = viewModel.message {
                Text(message)
            }
        }
        .id(viewModel.buttons)
    }
}

#Preview {
    ConfirmationDialogCreatorView()
}