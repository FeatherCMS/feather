public import FeatherModuleKit
public import MediaModule

extension Asset.File.PublicResolve {
    public struct Scope: FeatherModuleKit.Scope {
        public let query: any Query.Interface

        public init(query: any Query.Interface) {
            self.query = query
        }
    }
}
