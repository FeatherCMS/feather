import Testing
import WebDomain
import NewsModule

@testable import NewsDomain

@Suite
struct NewsDomainTestSuite {

    @Test
    func articleCreateBuildsDefaultMetadata() throws {
        let article = try Article.Model.create(
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
        #expect(throws: Article.Model.Error.titleTooShort) {
            try Article.Model.create(
                title: "",
                excerpt: "A short update",
                content: "Article content",
                categoryIds: []
            )
        }
    }
}
