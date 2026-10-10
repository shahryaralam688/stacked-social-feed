# Stacked Social Feed (SwiftUI)

A LinkedIn-style professional social feed for iOS, built with SwiftUI.

Posts use a sticky **stacked sections** scroll — each card pins and stacks as you scroll, inspired by [Animata Stacked Sections](https://github.com/codse/animata/blob/main/app/demo/library/scroll/stacked-sections-demo-001.tsx).

## Features

- Professional top bar (avatar, name, menu actions)
- “Start a post” composer strip
- Multiple social posts with remote images
- Sticky stacked card scroll with cover scale
- LinkedIn-style **New posts** refresh chip

## Requirements

- Xcode 16+
- iOS 17+
- Network access (avatars / post images load from the internet)

## Run

```bash
cd "Stacked Sections"
xcodegen generate   # optional if .xcodeproj already exists
open SpringRelease.xcodeproj
```

Pick an iPhone simulator and run.

## Structure

- `SpringRelease/Views/Components/StackedSectionsView.swift` — sticky stack engine
- `SpringRelease/Views/Components/SocialFeedView.swift` — feed + New posts chip
- `SpringRelease/Views/Components/SocialPostCard.swift` — post UI
- `SpringRelease/Models/SocialPost.swift` — sample feed data
