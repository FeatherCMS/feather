import FeatherContracts

public struct NewAdminListModel<Item: Sendable>: Sendable {
    public let items: [Item]
    public let pageState: NewAdminListPageState

    public init(
        items: [Item],
        pageState: NewAdminListPageState
    ) {
        self.items = items
        self.pageState = pageState
    }

}
