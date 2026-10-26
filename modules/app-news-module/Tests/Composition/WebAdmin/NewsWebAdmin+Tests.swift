import FeatherWebShared
import Hummingbird
import Testing

@testable import NewsWebAdmin

@Suite struct NewsWebAdminTests {
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
