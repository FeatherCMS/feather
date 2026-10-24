public import FeatherModuleKit
public import MediaDomain
public import MediaModule

extension Asset.File.Add {
    public struct Scope: FeatherModuleKit.Scope {
        public let folders: any Asset.Folder.Repository.Interface
        public let assets: any Asset.File.Repository.Interface
        public let storageObjects: any StorageObject.Repository.Interface

        public init(
            folders: any Asset.Folder.Repository.Interface,
            assets: any Asset.File.Repository.Interface,
            storageObjects: any StorageObject.Repository.Interface
        ) {
            self.folders = folders
            self.assets = assets
            self.storageObjects = storageObjects
        }
    }
}
