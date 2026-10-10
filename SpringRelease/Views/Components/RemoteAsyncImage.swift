import SwiftUI

/// Loads a remote image with a soft placeholder — used for avatars and post media.
struct RemoteAsyncImage: View {
    let url: URL?
    var contentMode: ContentMode = .fill

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            case .failure:
                placeholder
            case .empty:
                placeholder
                    .overlay { ProgressView().tint(ReleaseTheme.mutedInk) }
            @unknown default:
                placeholder
            }
        }
    }

    private var placeholder: some View {
        LinearGradient(
            colors: [
                Color(hex: 0xE8E6E1),
                Color(hex: 0xD9D6CF),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
