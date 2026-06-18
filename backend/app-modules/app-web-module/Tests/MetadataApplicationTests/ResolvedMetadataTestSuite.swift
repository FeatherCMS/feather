import Testing
import struct Foundation.Date
import WebDomain
@testable import WebApplication

@Suite
struct ResolvedMetadataTestSuite {

    @Test
    func usesExplicitMetadataValues() {
        let metadata = makeMetadataDetail(
            title: "Social title",
            excerpt: "Social excerpt",
            imageURL: "/social-image.png"
        )

        let result = ResolvedMetadata(
            metadata: metadata,
            fallbackTitle: "Fallback title",
            fallbackExcerpt: "Fallback excerpt",
            fallbackImageURL: "/fallback-image.png"
        )

        #expect(result.title == "Social title")
        #expect(result.excerpt == "Social excerpt")
        #expect(result.imageURL == "/social-image.png")
    }

    @Test
    func fallsBackForNilAndEmptyMetadataValues() {
        let metadata = makeMetadataDetail(
            title: "   ",
            excerpt: nil,
            imageURL: ""
        )

        let result = ResolvedMetadata(
            metadata: metadata,
            fallbackTitle: "Fallback title",
            fallbackExcerpt: "Fallback excerpt",
            fallbackImageURL: "/fallback-image.png"
        )

        #expect(result.title == "Fallback title")
        #expect(result.excerpt == "Fallback excerpt")
        #expect(result.imageURL == "/fallback-image.png")
    }
}

private func makeMetadataDetail(
    title: String?,
    excerpt: String?,
    imageURL: String?
) -> MetadataDetail {
    let now = Date()
    return .init(
        referenceType: "blog.post",
        referenceID: "post-1",
        id: "metadata-1",
        slug: "post-1",
        publicationDate: nil,
        expirationDate: nil,
        status: .published,
        title: title,
        excerpt: excerpt,
        imageURL: imageURL,
        canonicalURL: "",
        noIndex: false,
        primaryKeyword: "",
        cssCodeInjection: "",
        javascriptCodeInjection: "",
        structuredDataCodeInjection: "",
        createdAt: now,
        updatedAt: now
    )
}
