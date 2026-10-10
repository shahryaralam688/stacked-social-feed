import SwiftUI

/// Professional social feed tokens (LinkedIn-like).
enum ReleaseTheme {
    static let pageBackground = Color(hex: 0xF3F2EF)
    static let pageInk = Color(hex: 0x191919)
    static let mutedInk = Color(hex: 0x666666)
    static let cardBackground = Color.white
    static let cardBorder = Color(hex: 0x000000).opacity(0.08)
    static let accent = Color(hex: 0x0A66C2)
    static let accentSoft = Color(hex: 0x0A66C2).opacity(0.12)
    static let topBarBackground = Color.white
    static let stackOffset: CGFloat = 28
    static let paneGap: CGFloat = 10
    static let horizontalPadding: CGFloat = 16
    static let chapterCorner: CGFloat = 14
    static let topBarHeight: CGFloat = 56
}

extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >> 8) & 0xFF) / 255
        let b = Double(hex & 0xFF) / 255
        self.init(.sRGB, red: r, green: g, blue: b, opacity: opacity)
    }
}

extension Font {
    static func releaseDisplay(_ size: CGFloat, weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }

    static func releaseSans(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
}
