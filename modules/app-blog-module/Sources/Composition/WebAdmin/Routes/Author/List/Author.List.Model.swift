import BlogModule

extension Author.List {
    struct Model: Sendable {
        let items: [Item]
        let total: Int
        let page: Int
        let pageSize: Int
    }
}
