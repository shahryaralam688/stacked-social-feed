import SwiftUI

/// Sticky chapter deck with optional cover scale — ports Animata `StackedSections`.
///
/// Each pane sticks at the top of the scroll viewport. `stackOffset` is the peek band
/// when the next pane covers this one (padding-top = index × offset). Drama scale
/// shrinks covered content from the top center as the next card rises into pin.
struct StackedSectionsView: View {
    var stackOffset: CGFloat = 48
    var withDramaEffect: Bool = true
    var paneGap: CGFloat = 8
    /// In-flow spacer after the last card so the final pane stays pinned through outro scroll.
    var scrollRunway: CGFloat = 0
    let panes: [AnyView]

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        let total = panes.count

        VStack(spacing: paneGap) {
            ForEach(Array(panes.enumerated()), id: \.offset) { index, pane in
                StickyStackCard(
                    index: index,
                    total: total,
                    stackOffset: stackOffset,
                    withDramaEffect: withDramaEffect && !reduceMotion,
                    content: pane
                )
            }

            if scrollRunway > 0 {
                Color.clear
                    .frame(height: scrollRunway)
                    .accessibilityHidden(true)
            }
        }
        .padding(.bottom, CGFloat(total) * stackOffset)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Sticky card

private struct StickyStackCard: View {
    let index: Int
    let total: Int
    let stackOffset: CGFloat
    let withDramaEffect: Bool
    let content: AnyView

    /// 1-based card index (matches Animata `--index`).
    private var cardIndex: Int { index + 1 }

    private var topPad: CGFloat { CGFloat(cardIndex) * stackOffset }

    private var endScale: CGFloat {
        // reverseIndex = total - (cardIndex - 1); scale = 1.1 - 0.1 * reverseIndex
        let reverseIndex = CGFloat(total - (cardIndex - 1))
        return 1.1 - 0.1 * reverseIndex
    }

    var body: some View {
        ZStack(alignment: .top) {
            // Invisible layout probe — sizes the row to natural chapter height.
            content
                .padding(.top, topPad)
                .hidden()
                .accessibilityHidden(true)

            GeometryReader { proxy in
                let frame = proxy.frame(in: .named(StackedScrollSpace.name))
                let stickyY = max(0, -frame.minY)
                let scale = withDramaEffect
                    ? dramaScale(minY: frame.minY, cardHeight: proxy.size.height)
                    : 1

                content
                    .scaleEffect(scale, anchor: .top)
                    .padding(.top, topPad)
                    .frame(width: proxy.size.width, alignment: .top)
                    .offset(y: stickyY)
            }
        }
        .zIndex(Double(cardIndex))
    }

    /// Interpolate toward `endScale` as this pane is covered by the next sticky card.
    private func dramaScale(minY: CGFloat, cardHeight: CGFloat) -> CGFloat {
        guard index < total - 1 else { return 1 }

        let pinnedTop = CGFloat(cardIndex) * stackOffset
        let distance = max(cardHeight - pinnedTop, 1)
        let coveredTravel = max(0, -minY)
        let progress = min(1, max(0, coveredTravel / distance))

        if progress <= 0.001 { return 1 }
        return 1 + (endScale - 1) * progress
    }
}

enum StackedScrollSpace {
    static let name = "stacked-sections-scroll"
}
