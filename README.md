<img src="https://raw.githubusercontent.com/Janisbtw/Glance/master/Glance.png" width=200>

# Glance

Glance is a remake of the ShortLook tweak by Dynastic for modern rootless jailbreaks and iOS 16. Glance currently supports iOS 15.0 - 17.5.1.

[Glance](https://chariz.com/buy/glance) is available in the [Chariz](https://chariz.com/) repo.

## Features
- Show Notifications without turning on the screen (colored or white)
  - Title
  - Content
- Show App Icons (Or Profile Pictures if there's a bundle for it)
  - Custom Sizes
- Customize animation durations
- Supports AOD (Always On Display) by blurring instead of blacking the screen out

## Support
This tweak supports iOS versions from 15.0 - 17.4 on rootless and rootful jailbreaks. RootHide support is not provided but should be possible by using the patcher. Any issues that occur can be reported [here](https://github.com/Janisbtw/Glance/issues)

## Building
To build the tweak, you will need to have [Theos](https://theos.dev) installed. Additionally, you will need [AltList](https://github.com/opa334/AltList), [Comet](https://github.com/ginsudev/Comet) and [RemoteLog](https://github.com/filippofinke/remote-log).

You can then run
```
make package
```
or
```
make package THEOS_PACKAGE_SCHEME=rootless
```
to build for rootless. The deb file will be located in the `packages` folder.
Note that the first build will take a while to build the Swift support tools.

## Contributing
I currently have no plans to actively maintain this as an open source project. However, you can submit a pull request and I may or may not merge it.

## Credits
Credits are in no particular order
- [Dynastic](https://repo.dynastic.co/) for the original ShortLook tweak
- [rugmj](https://github.com/rugmj) for Pinnacle & general support
- [yan](https://github.com/yandevelop) for making [Bloom](https://havoc.app/package/bloom) compatible with Glance & general support
- [Leptos](https://github.com/leptos-null) for general support
- [L1ghtmann](https://github.com/L1ghtmann) for general support
- [Luki120](https://github.com/Luki120) for general support
- [Nightwind](https://github.com/NightwindDev) for general support
