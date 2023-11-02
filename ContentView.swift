// Copyright 2023 GreenYun Organization
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Collections
import SwiftUI
import VideoToolbox

private struct Codec: Identifiable {
    var id: UInt32 { codec }

    let codec: CMVideoCodecType
    let desc: String
    let isSupported: Bool

    init(_ codec: CMVideoCodecType, _ desc: String) {
        self.codec = codec
        self.desc = desc
        self.isSupported = VTIsHardwareDecodeSupported(self.codec)
    }
}

extension Codec: Hashable {
    static func == (lhs: Codec, rhs: Codec) -> Bool {
        return lhs.codec == rhs.codec && lhs.desc == rhs.desc
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(codec)
        hasher.combine(desc)
    }
}

func boolToSymbol(_ value: Bool) -> some View {
    value
    ? Image(systemName: "checkmark.circle")
        .foregroundColor(.green)
    : Image(systemName: "xmark.circle")
        .foregroundColor(.red)
}

private let codecs: OrderedSet<Codec> = [
    Codec(kCMVideoCodecType_422YpCbCr8, "Y'CbCr 8-bit 4:2:2 ordered Cb Y'0 Cr Y'1"),
    Codec(kCMVideoCodecType_Animation, "Apple Animation"),
    Codec(kCMVideoCodecType_Cinepak, "Cinepak"),
    Codec(kCMVideoCodecType_JPEG, "Joint Photographic Experts Group (JPEG)"),
    Codec(kCMVideoCodecType_JPEG_OpenDML, "JPEG with Open-DML extensions"),
    Codec(kCMVideoCodecType_SorensonVideo, "Sorenson"),
    Codec(kCMVideoCodecType_SorensonVideo3, "Sorenson 3"),
    Codec(kCMVideoCodecType_H263, "ITU-T H.263"),
    Codec(kCMVideoCodecType_H264, "ITU-T H.264"),
    Codec(kCMVideoCodecType_HEVC, "ITU-T HEVC"),
    Codec(kCMVideoCodecType_HEVCWithAlpha, "HEVC with alpha support"),
    Codec(kCMVideoCodecType_DolbyVisionHEVC, "Dolby Vision HEVC"),
    Codec(kCMVideoCodecType_MPEG4Video, "MPEG-4 Part 2"),
    Codec(kCMVideoCodecType_MPEG2Video, "MPEG-2"),
    Codec(kCMVideoCodecType_MPEG1Video, "MPEG-1"),
    Codec(kCMVideoCodecType_VP9, "VP9"),
    Codec(kCMVideoCodecType_DVCNTSC, "DV NTSC"),
    Codec(kCMVideoCodecType_DVCPAL, "DV PAL"),
    Codec(kCMVideoCodecType_DVCProPAL, "Panasonic DVCPro PAL"),
    Codec(kCMVideoCodecType_DVCPro50NTSC, "Panasonic DVCPro-50 NTSC"),
    Codec(kCMVideoCodecType_DVCPro50PAL, "Panasonic DVCPro-50 PAL"),
    Codec(kCMVideoCodecType_DVCPROHD720p60, "Panasonic DVCPro-HD 720p60"),
    Codec(kCMVideoCodecType_DVCPROHD720p50, "Panasonic DVCPro-HD 720p50"),
    Codec(kCMVideoCodecType_DVCPROHD1080i60, "Panasonic DVCPro-HD 1080i60"),
    Codec(kCMVideoCodecType_DVCPROHD1080i50, "Panasonic DVCPro-HD 1080i50"),
    Codec(kCMVideoCodecType_DVCPROHD1080p30, "Panasonic DVCPro-HD 1080p30"),
    Codec(kCMVideoCodecType_DVCPROHD1080p25, "Panasonic DVCPro-HD 1080p25"),
    Codec(kCMVideoCodecType_AppleProRes4444XQ, "Apple ProRes 4444 XQ"),
    Codec(kCMVideoCodecType_AppleProRes4444, "Apple ProRes 4444"),
    Codec(kCMVideoCodecType_AppleProRes422HQ, "Apple ProRes 422 HQ"),
    Codec(kCMVideoCodecType_AppleProRes422, "Apple ProRes 422"),
    Codec(kCMVideoCodecType_AppleProRes422LT, "Apple ProRes 422 LT"),
    Codec(kCMVideoCodecType_AppleProRes422Proxy, "Apple ProRes 422 proxy"),
    Codec(kCMVideoCodecType_AppleProResRAW, "Apple ProRes RAW"),
    Codec(kCMVideoCodecType_AppleProResRAWHQ, "Apple ProRes RAW HQ"),
    Codec(kCMVideoCodecType_DisparityHEVC, "disparity HEVC"),
    Codec(kCMVideoCodecType_DepthHEVC, "depth HEVC"),
    Codec(kCMVideoCodecType_AV1, "AV1")
]

struct ContentView: View {
    @State private var showDesc = false

    var body: some View {
        Spacer()
        Text("Hardware Decoder Support Test")
            .font(.title2)
            .bold()
            .multilineTextAlignment(.center)
        List {
            ForEach(codecs) { codec in
                let byteData = withUnsafeBytes(of: codec.codec.bigEndian) {
                    Data(Array($0))
                }
                let desc = showDesc ? codec.desc : String(data: byteData, encoding: .utf8)!
                let sysFont = Font.system(.body)
                let font = showDesc ? sysFont : sysFont.monospaced()

                HStack {
                    Text(desc)
                        .font(font)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer()
                    boolToSymbol(codec.isSupported)
                }
            }
            .contentShape(Rectangle())
            .focusable(interactions: .activate)
            .onTapGesture {
                showDesc.toggle()
            }
        }
    }
}
