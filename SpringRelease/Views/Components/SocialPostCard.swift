import SwiftUI

/// One professional social post — author row, copy, optional media, engagement.
struct SocialPostCard: View {
    let post: SocialPost

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
                .padding(.horizontal, 14)
                .padding(.top, 14)
                .padding(.bottom, 10)

            Text(post.body)
                .font(.releaseSans(15))
                .foregroundStyle(ReleaseTheme.pageInk)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 14)
                .padding(.bottom, post.imageURL == nil ? 12 : 10)

            if let imageURL = post.imageURL {
                RemoteAsyncImage(url: imageURL)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .clipped()
                    .padding(.bottom, 10)
            }

            statsRow
                .padding(.horizontal, 14)
                .padding(.bottom, 8)

            Divider()
                .overlay(ReleaseTheme.cardBorder)

            actionRow
                .padding(.horizontal, 6)
                .padding(.vertical, 6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ReleaseTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: ReleaseTheme.chapterCorner, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: ReleaseTheme.chapterCorner, style: .continuous)
                .stroke(ReleaseTheme.cardBorder, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 8, y: 2)
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 10) {
            RemoteAsyncImage(url: post.author.avatarURL)
                .frame(width: 44, height: 44)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(post.author.name)
                        .font(.releaseSans(15, weight: .semibold))
                        .foregroundStyle(ReleaseTheme.pageInk)
                        .lineLimit(1)
                    Text("· \(post.timeAgo)")
                        .font(.releaseSans(12))
                        .foregroundStyle(ReleaseTheme.mutedInk)
                }
                Text(post.author.headline)
                    .font(.releaseSans(12))
                    .foregroundStyle(ReleaseTheme.mutedInk)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)

            Image(systemName: "ellipsis")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(ReleaseTheme.mutedInk)
                .padding(.top, 4)
        }
    }

    private var statsRow: some View {
        HStack(spacing: 4) {
            Image(systemName: "hand.thumbsup.circle.fill")
                .font(.system(size: 14))
                .foregroundStyle(ReleaseTheme.accent)
            Text("\(post.likes)")
                .font(.releaseSans(12))
                .foregroundStyle(ReleaseTheme.mutedInk)
            Spacer()
            Text("\(post.comments) comments · \(post.reposts) reposts")
                .font(.releaseSans(12))
                .foregroundStyle(ReleaseTheme.mutedInk)
        }
    }

    private var actionRow: some View {
        HStack {
            actionButton("hand.thumbsup", "Like")
            actionButton("bubble.left", "Comment")
            actionButton("arrow.2.squarepath", "Repost")
            actionButton("paperplane", "Send")
        }
    }

    private func actionButton(_ icon: String, _ title: String) -> some View {
        Button(action: {}) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                Text(title)
                    .font(.releaseSans(12, weight: .medium))
            }
            .foregroundStyle(ReleaseTheme.mutedInk)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}
