import SwiftUI

struct AlertCreatorView: View {
    @StateObject private var viewModel = AlertCreatorViewModel()

    var body: some View {
        let isPresented = Binding<Bool>(
            get: { viewModel.alertDetails != nil },
            set: { if !$0 { viewModel.alertDetails = nil } }
        )

        Form {
            Section(header: Text("Alert Configuration")) {
                TextField("Title", text: $viewModel.title)
                TextField("Message", text: $viewModel.message)
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
        .navigationTitle("Alert Creator")
        .alert(
            viewModel.alertDetails?.title ?? "Alert",
            isPresented: isPresented,
            presenting: viewModel.alertDetails
        ) { details in
            ForEach(details.buttons) { button in
                Button(button.text, role: button.style.buttonRole) {}
            }
        } message: { details in
            Text(details.message)
        }
    }
}

#Preview {
    AlertCreatorView()
}