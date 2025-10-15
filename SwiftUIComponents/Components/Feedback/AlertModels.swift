import SwiftUI

struct AlertDetails: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let buttons: [AlertButton]
}

struct AlertButton: Identifiable, Hashable {
    let id = UUID()
    var text = "OK"
    var style: AlertButtonStyle = .default

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(text)
        hasher.combine(style)
    }

    static func == (lhs: AlertButton, rhs: AlertButton) -> Bool {
        lhs.id == rhs.id && lhs.text == rhs.text && lhs.style == rhs.style
    }
}

enum AlertButtonStyle: String, CaseIterable, Hashable {
    case `default`
    case destructive
    case cancel

    var buttonRole: ButtonRole? {
        switch self {
        case .destructive:
            return .destructive
        case .cancel:
            return .cancel
        default:
            return nil
        }
    }
}
