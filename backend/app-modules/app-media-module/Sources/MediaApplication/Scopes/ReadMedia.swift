import Application

public struct ReadMedia: Scope {
    public let folders: any MediaFolderQueries
    public let assets: any MediaAssetQueries

    public init(
        folders: any MediaFolderQueries,
        assets: any MediaAssetQueries
    ) {
        self.folders = folders
        self.assets = assets
    }
}
