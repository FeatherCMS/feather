import FeatherContracts
import Foundation
import Testing

@Suite
struct MediaResolverTestSuite {

    private let resolver = MediaResolver(
        mediaBaseURL: URL(string: "https://media.example.com/")!
    )

    @Test
    func resolvesRelativeAndAbsoluteImagePaths() {
        #expect(
            resolver.resolve(imagePath: "/media/assets/photo.jpg")
                == "https://media.example.com/media/assets/photo.jpg"
        )
        #expect(
            resolver.resolve(imagePath: "media/assets/photo.jpg")
                == "https://media.example.com/media/assets/photo.jpg"
        )
        #expect(
            resolver.resolve(imagePath: "https://cdn.example.com/photo.jpg")
                == "https://cdn.example.com/photo.jpg"
        )
        #expect(resolver.resolve(imagePath: "") == nil)
    }

    @Test
    func resolvesOnlyTheExplicitVariantKey() {
        let variants = [
            MediaURLVariant(
                key: "preview",
                url: "/media/variants/asset/preview.jpg"
            ),
            MediaURLVariant(
                key: "cover",
                url: "/media/variants/asset/cover.jpg"
            ),
        ]

        #expect(
            resolver.resolve(variants: variants, variantKey: "cover")
                == "https://media.example.com/media/variants/asset/cover.jpg"
        )
        #expect(resolver.resolve(variants: variants, variantKey: "original") == nil)
    }

    @Test
    func resolvesMarkdownMediaPaths() {
        let output = resolver.resolveMarkdownImages(
            in: "![Photo](/media/assets/photo.jpg)"
        )
        #expect(
            output == "![Photo](https://media.example.com/media/assets/photo.jpg)"
        )
    }
}
