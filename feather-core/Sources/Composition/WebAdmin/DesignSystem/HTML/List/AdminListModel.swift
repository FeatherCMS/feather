import FeatherModuleKit

public struct AdminListModel<Item: Sendable>: Sendable {
    public let items: [Item]
    public let pageState: AdminListPageState

    public init(
        items: [Item],
        pageState: AdminListPageState
    ) {
        self.items = items
        self.pageState = pageState
    }

}
