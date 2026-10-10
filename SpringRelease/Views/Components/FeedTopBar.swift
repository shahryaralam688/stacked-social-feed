import SwiftUI

/// Dummy professional top bar — avatar, name, and light menu actions.
struct FeedTopBar: View {
    let user: SocialAuthor

    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 10) {
                RemoteAsyncImage(url: user.avatarURL)
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(ReleaseTheme.cardBorder, lineWidth: 1))

                VStack(alignment: .leading, spacing: 1) {
                    Text(user.name)
                        .font(.releaseSans(15, weight: .semibold))
                        .foregroundStyle(ReleaseTheme.pageInk)
                        .lineLimit(1)
                    Text(user.headline)
                        .font(.releaseSans(11))
                        .foregroundStyle(ReleaseTheme.mutedInk)
                        .lineLimit(1)
                }
            }

            Spacer(minLength: 8)

            HStack(spacing: 4) {
                topIcon("magnifyingglass")
                topIcon("bell")
                topIcon("ellipsis.message")
                topIcon("line.3.horizontal")
            }
        }
        .padding(.horizontal, ReleaseTheme.horizontalPadding)
        .padding(.vertical, 10)
        .frame(minHeight: ReleaseTheme.topBarHeight)
        .background(ReleaseTheme.topBarBackground)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(ReleaseTheme.cardBorder)
                .frame(height: 1)
        }
    }

    private func topIcon(_ systemName: String) -> some View {
        Button(action: {}) {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(ReleaseTheme.pageInk.opacity(0.78))
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(ReleaseTheme.pageBackground)
                )
        }
        .buttonStyle(.plain)
    }
}
