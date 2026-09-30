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
            resolver.resolve(imagePath: "/asset/originals/photo.jpg")
                == "https://media.example.com/asset/originals/photo.jpg"
        )
        #expect(
            resolver.resolve(imagePath: "asset/originals/photo.jpg")
                == "https://media.example.com/asset/originals/photo.jpg"
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
                url: "/asset/originals/preview.jpg"
            ),
            MediaURLVariant(
                key: "cover",
                url: "/asset/variants/cover/preview.jpg"
            ),
        ]

        #expect(
            resolver.resolve(variants: variants, variantKey: "cover")
                == "https://media.example.com/asset/variants/cover/preview.jpg"
        )
        #expect(
            resolver.resolve(variants: variants, variantKey: "original") == nil
        )
    }

    @Test
    func resolvesMarkdownMediaPaths() {
        let output = resolver.resolveMarkdownImages(
            in: "![Photo](/12/34/56789/originals/example/projects/photo.jpg)"
        )
        #expect(
            output
                == "![Photo](https://media.example.com/12/34/56789/originals/example/projects/photo.jpg)"
        )
    }

    @Test
    func resolvesMarkdownVariantButLeavesAbsoluteURLsUnchanged() {
        let source = """
            ![Variant](/12/34/56789/variants/cover/example/projects/photo.webp)
            ![External](https://cdn.example.com/12/34/56789/originals/photo.jpg)
            """
        let output = resolver.resolveMarkdownImages(in: source)

        #expect(
            output == """
                ![Variant](https://media.example.com/12/34/56789/variants/cover/example/projects/photo.webp)
                ![External](https://cdn.example.com/12/34/56789/originals/photo.jpg)
                """
        )
    }
}
