public import FeatherModuleKit
public import MediaDomain
public import MediaModule

extension Asset.Folder.Add {
    public struct Scope: FeatherModuleKit.Scope {
        public let folders: any Asset.Folder.Repository.Interface

        public init(
            folders: any Asset.Folder.Repository.Interface
        ) {
            self.folders = folders
        }
    }
}
