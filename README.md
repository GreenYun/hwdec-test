Hardware Decoder Support Test
=============================

This is a demo program to find video codecs that is hardware docoder supported, on iOS, iPadOS, macOS, and even tvOS.

Building Instructions
---------------------

Create a new **Multiplatform App** project in XCode, then paste the content in [ContentView.swift](ContentView.swift) to your project.
Select your build target then build and run.

> Note: XCode 15 or equivalent SDK version may be required as AV1 support are introduced in the latest version of iOS/iPadOS/macOS/tvOS.
> However, this does not means we cannot check AV1 support on older version OS's (But we all know that there is no hardware decoder supports).
> The workaround is to change `kCMVideoCodecType_AV1` to the FourCC `av01` (0x61763031, Big Endian).

Minimum Platform Version Requirement
------------------------------------

The core function in this piece of codes is [VTIsHardwareDecodeSupported(_:)]

The codes are tested on the following systems:

| OS     | Version |
|--------|---------|
| iOS    | 17.0    |
| iPadOS | 17.0    |
| macOS  | 14.0    |
| tvOS   | 17.0    |

[VTIsHardwareDecodeSupported(_:)]: https://developer.apple.com/documentation/videotoolbox/2887343-vtishardwaredecodesupported

License
-------

MIT
