import Hummingbird
import Testing

@testable import NewsFrontend

@Suite struct NewsFrontendTestSuite {
    @Test func articleAndCategoryRoutesAreUnderNews() {
        #expect(NewsAdminRoutes.articles.description.contains("news/articles"))
        #expect(
            NewsAdminRoutes.categories.description.contains("news/categories")
        )
    }
}
