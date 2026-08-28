import NewsContracts
import Testing
import WebDomain

@testable import NewsApplication
@testable import NewsDomain

@Suite
struct NewsModuleTestSuite {

    @Test
    func applicationTargetLoads() {
        _ = NewsPermissions.self
    }

    @Test
    func articleCreateBuildsDefaultMetadata() throws {
        let article = try Article.create(
            title: "Swift News",
            excerpt: "A short update",
            content: "Article content",
            categoryIds: []
        )

        #expect(article.title == "Swift News")
        #expect(article.metadata.slug == "swift-news")
    }

    @Test
    func articleRejectsEmptyTitle() {
        #expect(throws: Article.Error.titleTooShort) {
            try Article.create(
                title: "",
                excerpt: "A short update",
                content: "Article content",
                categoryIds: []
            )
        }
    }
}
