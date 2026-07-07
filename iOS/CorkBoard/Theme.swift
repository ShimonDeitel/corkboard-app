import SwiftUI

/// Cork Board's unique visual identity - a palette and mood distinct from every
/// sibling app in this portfolio, tuned to the bottle domain.
enum AppTheme {
    static let background = Color(red: 0.082, green: 0.055, blue: 0.063)
    static let card = Color(red: 0.133, green: 0.078, blue: 0.098)
    static let accent = Color(red: 0.557, green: 0.122, blue: 0.231)
    static let secondary = Color(red: 0.788, green: 0.635, blue: 0.294)
    static let primaryText = Color(red: 0.961, green: 0.914, blue: 0.925)
    static let mutedText = Color(red: 0.961, green: 0.914, blue: 0.925).opacity(0.6)

    static let titleFont: Font = .system(.title2, design: .serif).weight(.bold)
    static let headlineFont: Font = .system(.headline, design: .rounded)
    static let bodyFont: Font = .system(.body, design: .rounded)
    static let captionFont: Font = .system(.caption, design: .monospaced)

    static let cornerRadius: CGFloat = 16
}

struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(AppTheme.card)
            .cornerRadius(AppTheme.cornerRadius)
    }
}

extension View {
    func cardStyle() -> some View { modifier(CardBackground()) }
}
