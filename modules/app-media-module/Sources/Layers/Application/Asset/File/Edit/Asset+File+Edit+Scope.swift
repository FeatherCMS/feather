public import FeatherModuleKit
public import MediaDomain
public import MediaModule

extension Asset.File.Edit {
    public struct Scope: FeatherModuleKit.Scope {
        public let assets: any Asset.File.Repository.Interface

        public init(
            assets: any Asset.File.Repository.Interface
        ) {
            self.assets = assets
        }
    }
}
