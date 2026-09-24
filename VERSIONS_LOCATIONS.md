# Versions and Locations

Where each version/build number lives. Xcode build settings are authoritative;
there is no literal `Info.plist` in the repo (`GENERATE_INFOPLIST_FILE = YES`).

| What | Value | Location |
| --- | --- | --- |
| Marketing version (`CFBundleShortVersionString`) | 1.0 | `Enhanced Magic 8 Ball.xcodeproj` → target `Enhanced Magic 8 Ball` → `MARKETING_VERSION` |
| Build number (`CFBundleVersion`) | 2 | same target → `CURRENT_PROJECT_VERSION` |
| Deployment target | iOS 27.0 | same target → `IPHONEOS_DEPLOYMENT_TARGET` |
| Orientation | portrait only | same target → `INFOPLIST_KEY_UISupportedInterfaceOrientations` |
| Bundle ID | `Hoaglun.com.Enhanced-Magic-8-Ball` | same target → `PRODUCT_BUNDLE_IDENTIFIER` |
| Changelog | — | `CHANGELOG.md` (one entry per delivery) |

## Rules

- `MARKETING_VERSION` changes only for an intentional release.
- `CURRENT_PROJECT_VERSION` increments exactly once per completed file-changing
  delivery.
- After a version change, verify the built app's `Info.plist`
  (`Debug-iphonesimulator` product) shows the new values.
