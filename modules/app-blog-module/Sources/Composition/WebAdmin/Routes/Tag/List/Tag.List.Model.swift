import BlogModule

extension Tag.List {
    struct Model: Sendable {
        let items: [Item]
        let total: Int
        let page: Int
        let pageSize: Int
    }
}
