import SwiftUI

/// Professional social feed: fixed top bar + stacked post cards + LinkedIn-style “New posts”.
struct SocialFeedView: View {
    @State private var posts: [SocialPost] = SocialFeedCatalog.makeFeed()
    @State private var refreshSeed = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var showNewPostsChip = false
    @State private var isRefreshing = false
    @State private var pendingNewCount = 0

    private let stackOffset = ReleaseTheme.stackOffset
    private let newPostsThreshold: CGFloat = 220

    var body: some View {
        VStack(spacing: 0) {
            FeedTopBar(user: SocialFeedCatalog.currentUser)

            GeometryReader { geo in
                let runway = min(geo.size.height * 0.35, 280)

                ZStack(alignment: .top) {
                    ScrollViewReader { proxy in
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 0) {
                                Color.clear
                                    .frame(height: 0)
                                    .id("feed-top")
                                    .background(ScrollOffsetReader(offset: $scrollOffset))

                                composerStrip
                                    .padding(.horizontal, ReleaseTheme.horizontalPadding)
                                    .padding(.top, 12)
                                    .padding(.bottom, 8)

                                StackedSectionsView(
                                    stackOffset: stackOffset,
                                    withDramaEffect: true,
                                    paneGap: ReleaseTheme.paneGap,
                                    scrollRunway: runway,
                                    panes: postPanes
                                )
                                .padding(.horizontal, ReleaseTheme.horizontalPadding)

                                Text("You're all caught up")
                                    .font(.releaseSans(13))
                                    .foregroundStyle(ReleaseTheme.mutedInk.opacity(0.7))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 28)
                            }
                            .frame(maxWidth: 720)
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 40)
                        }
                        .coordinateSpace(name: StackedScrollSpace.name)
                        .onChange(of: scrollOffset) { _, value in
                            handleScroll(value)
                        }
                        .overlay(alignment: .top) {
                            if showNewPostsChip {
                                newPostsButton {
                                    refreshFeed(using: proxy)
                                }
                                .padding(.top, 10)
                                .transition(
                                    .asymmetric(
                                        insertion: .move(edge: .top).combined(with: .opacity),
                                        removal: .opacity
                                    )
                                )
                            }
                        }
                    }
                }
            }
        }
        .background(ReleaseTheme.pageBackground.ignoresSafeArea())
    }

    // MARK: - Composer

    private var composerStrip: some View {
        HStack(spacing: 12) {
            RemoteAsyncImage(url: SocialFeedCatalog.currentUser.avatarURL)
                .frame(width: 40, height: 40)
                .clipShape(Circle())

            Text("Start a post")
                .font(.releaseSans(14, weight: .medium))
                .foregroundStyle(ReleaseTheme.mutedInk)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .stroke(ReleaseTheme.cardBorder, lineWidth: 1)
                        .background(Capsule().fill(ReleaseTheme.cardBackground))
                )

            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Color(hex: 0x378FE9))
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(ReleaseTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(ReleaseTheme.cardBorder, lineWidth: 1)
                )
        )
    }

    // MARK: - New posts chip

    private func newPostsButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isRefreshing {
                    ProgressView()
                        .controlSize(.small)
                        .tint(.white)
                } else {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 12, weight: .bold))
                }
                Text(isRefreshing ? "Refreshing…" : "New posts")
                    .font(.releaseSans(13, weight: .semibold))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(ReleaseTheme.accent)
                    .shadow(color: ReleaseTheme.accent.opacity(0.35), radius: 10, y: 4)
            )
        }
        .buttonStyle(.plain)
        .disabled(isRefreshing)
    }

    // MARK: - Posts

    private var postPanes: [AnyView] {
        posts.map { post in
            AnyView(SocialPostCard(post: post))
        }
    }

    // MARK: - Scroll + refresh

    private func handleScroll(_ offset: CGFloat) {
        // offset grows as user scrolls down (content moves up)
        let deep = offset > newPostsThreshold
        if deep && !showNewPostsChip && !isRefreshing {
            // After a short pause deep in the feed, offer “New posts” like LinkedIn.
            pendingNewCount = max(pendingNewCount, 3)
            withAnimation(.spring(response: 0.38, dampingFraction: 0.86)) {
                showNewPostsChip = true
            }
        }
        if offset < 40 && showNewPostsChip && !isRefreshing {
            withAnimation(.easeOut(duration: 0.2)) {
                showNewPostsChip = false
            }
        }
    }

    private func refreshFeed(using proxy: ScrollViewProxy) {
        guard !isRefreshing else { return }
        isRefreshing = true

        // Brief pause so the chip feels intentional, then reset feed to top.
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 450_000_000)
            refreshSeed += 1
            withAnimation(.spring(response: 0.45, dampingFraction: 0.88)) {
                posts = SocialFeedCatalog.makeFeed(seed: refreshSeed)
            }
            withAnimation(.easeInOut(duration: 0.35)) {
                proxy.scrollTo("feed-top", anchor: .top)
            }
            try? await Task.sleep(nanoseconds: 280_000_000)
            isRefreshing = false
            pendingNewCount = 0
            withAnimation(.easeOut(duration: 0.2)) {
                showNewPostsChip = false
            }
        }
    }
}

// MARK: - Scroll offset

private struct ScrollOffsetReader: View {
    @Binding var offset: CGFloat

    var body: some View {
        GeometryReader { proxy in
            let y = -proxy.frame(in: .named(StackedScrollSpace.name)).minY
            Color.clear
                .preference(key: ScrollOffsetKey.self, value: y)
                .onAppear { offset = y }
                .onChange(of: y) { _, value in
                    offset = value
                }
        }
        .frame(height: 0)
    }
}

private struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    SocialFeedView()
}
