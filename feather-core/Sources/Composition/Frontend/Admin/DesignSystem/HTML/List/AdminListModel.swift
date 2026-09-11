import FeatherContracts

public struct AdminListModel<Item: Sendable>: Sendable {
    public let items: [Item]
    public let pageState: ListPageState

    public init(
        items: [Item],
        page: Int,
        pageSize: Int,
        total: Int
    ) {
        self.items = items
        self.pageState = .init(
            page: page,
            pageSize: pageSize,
            total: total
        )
    }
}
