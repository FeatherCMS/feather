import NewsApplication
import NewsModule

extension Category.List {
    struct Model: Sendable {
        let items: [Item]
        let total: Int
        let page: Int
        let pageSize: Int

        struct Item: Sendable {
            let id: String
            let title: String
            let excerpt: String
        }
    }
}
