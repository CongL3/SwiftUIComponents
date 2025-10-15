import SwiftUI

/// Provides a convenient way to handle optional bindings, supplying a default value if the wrapped value is nil.
/// This allows you to, for example, bind a TextField directly to a `Binding<String?>`.
/// Usage: `TextField("My Text", text: $myOptionalString ?? "")`
func ??<T>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
