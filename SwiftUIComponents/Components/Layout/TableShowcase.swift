import SwiftUI

struct TableShowcase: View {
    var body: some View {
        VStack(spacing: 0) {
            NativeTableExample(
                title: "Basic Table",
                description: "Native iOS 16+ Table with basic columns",
                style: .basic
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeTableExample(
                title: "Sortable Table",
                description: "Table with sortable columns",
                style: .sortable
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeTableExample(
                title: "Selectable Table",
                description: "Table with row selection support",
                style: .selectable
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeTableExample(
                title: "Styled Table",
                description: "Table with custom styling and formatting",
                style: .styled
            )
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

public enum NativeTableStyle: CaseIterable {
    case basic
    case sortable
    case selectable
    case styled
    
    var displayName: String {
        switch self {
        case .basic: return "Basic"
        case .sortable: return "Sortable"
        case .selectable: return "Selectable"
        case .styled: return "Styled"
        }
    }
}

struct Person: Identifiable {
    let id = UUID()
    let name: String
    let age: Int
    let department: String
    let salary: Double
}

struct NativeTableExample: View {
    let title: String
    let description: String
    let style: NativeTableStyle
    
    @State private var people = [
        Person(name: "Alice Johnson", age: 28, department: "Engineering", salary: 85000),
        Person(name: "Bob Smith", age: 35, department: "Design", salary: 75000),
        Person(name: "Carol Davis", age: 42, department: "Marketing", salary: 68000),
        Person(name: "David Wilson", age: 29, department: "Engineering", salary: 82000),
        Person(name: "Eva Brown", age: 31, department: "Sales", salary: 71000)
    ]
    
    @State private var sortOrder = [KeyPathComparator(\Person.name)]
    @State private var selection = Set<Person.ID>()
    
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
            
            // Table examples (iOS 16+)
            Group {
                if #available(iOS 16.0, *) {
                    switch style {
                    case .basic:
                        Table(people) {
                            TableColumn("Name", value: \.name)
                            TableColumn("Age") { person in
                                Text("\(person.age)")
                            }
                            TableColumn("Department", value: \.department)
                        }
                        .frame(height: 140)
                        
                    case .sortable:
                        Table(people, sortOrder: $sortOrder) {
                            TableColumn("Name", value: \.name)
                            TableColumn("Age") { person in
                                Text("\(person.age)")
                            }
                            .width(60)
                            TableColumn("Department", value: \.department)
                            TableColumn("Salary") { person in
                                Text("$\(Int(person.salary))")
                                    .foregroundStyle(.green)
                            }
                            .width(80)
                        }
                        .onChange(of: sortOrder) { _, newOrder in
                            people.sort(using: newOrder)
                        }
                        .frame(height: 140)
                        
                    case .selectable:
                        Table(people, selection: $selection) {
                            TableColumn("Name", value: \.name)
                            TableColumn("Age") { person in
                                Text("\(person.age)")
                            }
                            TableColumn("Department", value: \.department)
                        }
                        .frame(height: 140)
                        .overlay(
                            VStack {
                                Spacer()
                                if !selection.isEmpty {
                                    Text("\(selection.count) selected")
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.blue.opacity(0.2))
                                        .clipShape(Capsule())
                                        .padding(.bottom, 8)
                                }
                            }
                        )
                        
                    case .styled:
                        Table(people) {
                            TableColumn("Employee") { person in
                                HStack(spacing: 8) {
                                    Circle()
                                        .fill(departmentColor(person.department))
                                        .frame(width: 12, height: 12)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(person.name)
                                            .fontWeight(.medium)
                                        Text("\(person.age) years old")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            
                            TableColumn("Department") { person in
                                Text(person.department)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(departmentColor(person.department).opacity(0.2))
                                    .clipShape(Capsule())
                            }
                            
                            TableColumn("Salary") { person in
                                Text("$\(Int(person.salary))")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.green)
                            }
                        }
                        .frame(height: 160)
                    }
                } else {
                    // Fallback for iOS 15
                    VStack(spacing: 8) {
                        Image(systemName: "tablecells")
                            .font(.title2)
                            .foregroundStyle(.blue)
                        
                        Text("Table Component")
                            .font(.headline)
                        
                        Text("Available in iOS 16+")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text("Use List with custom rows for iOS 15")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(height: 140)
                    .background(Color(.secondarySystemBackground))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Style: .\(style.displayName.lowercased())")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                
                Text(tableDescription)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
    
    private func departmentColor(_ department: String) -> Color {
        switch department {
        case "Engineering": return .blue
        case "Design": return .purple
        case "Marketing": return .orange
        case "Sales": return .green
        default: return .gray
        }
    }
    
    private var tableDescription: String {
        switch style {
        case .basic:
            return "Table(data) { TableColumn() }"
        case .sortable:
            return "Table(data, sortOrder: $binding)"
        case .selectable:
            return "Table(data, selection: $binding)"
        case .styled:
            return "Table with custom cell content"
        }
    }
}

#Preview {
    ScrollView {
        TableShowcase()
            .padding()
    }
} 