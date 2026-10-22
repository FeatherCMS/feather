public import BlogModule
public import FeatherModuleKit

extension Tag.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let tag: any Tag.List.Query.Interface

        public init(tag: any Tag.List.Query.Interface) {
            self.tag = tag
        }
    }
}
