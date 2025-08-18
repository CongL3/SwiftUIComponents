import SwiftUI

struct FormShowcase: View {
    @State private var name = ""
    @State private var email = ""
    @State private var isSubscribed = false
    @State private var selectedPlan = "Basic"
    @State private var birthDate = Date()
    @State private var rating = 3.0
    
    let plans = ["Basic", "Premium", "Enterprise"]
    
    var body: some View {
        VStack(spacing: 0) {
            NativeFormExample(
                title: "Basic Form",
                description: "Native SwiftUI Form with basic sections",
                style: .basic
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeFormExample(
                title: "Grouped Form",
                description: "Form with grouped sections and headers",
                style: .grouped
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeFormExample(
                title: "Form with Footer",
                description: "Form sections with header and footer text",
                style: .withFooter
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeFormExample(
                title: "Complex Form",
                description: "Form with various input types and validation",
                style: .complex
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public enum NativeFormStyle: CaseIterable {
    case basic
    case grouped
    case withFooter
    case complex
    
    var displayName: String {
        switch self {
        case .basic: return "Basic"
        case .grouped: return "Grouped"
        case .withFooter: return "With Footer"
        case .complex: return "Complex"
        }
    }
}

struct NativeFormExample: View {
    let title: String
    let description: String
    let style: NativeFormStyle
    
    @State private var name = ""
    @State private var email = ""
    @State private var isSubscribed = false
    @State private var selectedPlan = "Basic"
    @State private var birthDate = Date()
    @State private var rating = 3.0
    
    let plans = ["Basic", "Premium", "Enterprise"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // Form preview with limited height
            Group {
                switch style {
                case .basic:
                    Form {
                        TextField("Name", text: $name)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                        Toggle("Subscribe", isOn: $isSubscribed)
                    }
                    
                case .grouped:
                    Form {
                        Section("Personal Information") {
                            TextField("Full Name", text: $name)
                            TextField("Email Address", text: $email)
                                .keyboardType(.emailAddress)
                        }
                        
                        Section("Preferences") {
                            Toggle("Newsletter", isOn: $isSubscribed)
                            Picker("Plan", selection: $selectedPlan) {
                                ForEach(plans, id: \.self) { plan in
                                    Text(plan).tag(plan)
                                }
                            }
                        }
                    }
                    
                case .withFooter:
                    Form {
                        Section {
                            TextField("Full Name", text: $name)
                            TextField("Email Address", text: $email)
                                .keyboardType(.emailAddress)
                        } header: {
                            Text("Account Details")
                        } footer: {
                            Text("This information will be used to create your account.")
                        }
                        
                        Section {
                            Toggle("Email Notifications", isOn: $isSubscribed)
                        } footer: {
                            Text("You can change this setting later in preferences.")
                        }
                    }
                    
                case .complex:
                    Form {
                        Section("Profile") {
                            HStack {
                                Text("Name")
                                Spacer()
                                TextField("Required", text: $name)
                                    .multilineTextAlignment(.trailing)
                            }
                            
                            DatePicker("Birth Date", selection: $birthDate, displayedComponents: .date)
                            
                            HStack {
                                Text("Rating")
                                Spacer()
                                Text("\(Int(rating)) stars")
                                    .foregroundStyle(.secondary)
                            }
                            Slider(value: $rating, in: 1...5, step: 1)
                        }
                        
                        Section("Settings") {
                            NavigationLink("Privacy Settings") {
                                Text("Privacy Settings")
                            }
                            
                            NavigationLink("Notifications") {
                                Text("Notification Settings")
                            }
                        }
                    }
                }
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text("Style: .\(style.displayName.lowercased().replacingOccurrences(of: " ", with: ""))")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
}

#Preview {
    NavigationView {
        ScrollView {
            FormShowcase()
                .padding()
        }
        .navigationTitle("Form Showcase")
    }
} 