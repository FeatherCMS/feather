import FeatherContracts

public struct AdminListModel<Item: Sendable>: Sendable {
    public let items: [Item]
    public let pageState: ListPageState

    public init(
        items: [Item],
        pageState: ListPageState
    ) {
        self.items = items
        self.pageState = pageState
    }

}
