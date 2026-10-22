import Hummingbird
import Testing

@testable import NewsWebAdmin

@Suite struct NewsWebAdminTestSuite {
    @Test func articleAndCategoryRoutesAreUnderNews() {
        #expect(NewsAdminRoutes.articles.description.contains("news/articles"))
        #expect(
            NewsAdminRoutes.categories.description.contains("news/categories")
        )
    }
}
