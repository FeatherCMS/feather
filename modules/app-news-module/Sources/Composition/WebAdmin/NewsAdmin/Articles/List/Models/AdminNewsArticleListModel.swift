struct AdminNewsArticleListModel: Sendable {
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
