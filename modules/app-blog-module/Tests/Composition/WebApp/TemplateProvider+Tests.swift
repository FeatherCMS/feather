import Foundation
import Testing
import WebModule

@testable import BlogWebApp

@Suite
struct TemplateProviderTests {
    @Test
    func registersBlogTemplatesAndBundledResources() {
        let provider = Templates.Provider()

        #expect(
            provider.templates.map(\.id) == [
                "blog.post",
                "blog.author",
                "blog.tag",
                "blog.posts",
                "blog.tags",
                "blog.authors",
            ]
        )
        #expect(provider.bundledTemplatePaths.count == 1)
        #expect(
            provider.bundledTemplatePaths.allSatisfy {
                FileManager.default.fileExists(atPath: $0.path)
            }
        )
    }
}
