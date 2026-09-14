import FeatherApplication

public struct MediaAssetSearchList: DTO {
    public enum Item: Sendable {
        case asset(MediaAssetList.Item)
        case folder(MediaFolderList.Item)
    }

    public let items: [Item]

    public init(items: [Item]) {
        self.items = items
    }
}
