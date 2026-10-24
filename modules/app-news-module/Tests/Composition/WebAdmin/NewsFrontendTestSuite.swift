import FeatherWebShared
import Hummingbird
import Testing

@testable import NewsWebAdmin

@Suite struct NewsWebAdminTestSuite {
    @Test func articleAndCategoryRoutesAreUnderNews() {
        let routes = Router.Routes.standard
        #expect(
            routes.articles.routerPath.description.contains("news/articles")
        )
        #expect(
            routes.categories.routerPath.description.contains("news/categories")
        )
    }
}
