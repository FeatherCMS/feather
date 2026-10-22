public import BlogModule
public import FeatherModuleKit

extension Tag.Search {
    public struct Scope: FeatherModuleKit.Scope {
        public let tag: any Tag.Search.Query.Interface

        public init(tag: any Tag.Search.Query.Interface) {
            self.tag = tag
        }
    }
}
