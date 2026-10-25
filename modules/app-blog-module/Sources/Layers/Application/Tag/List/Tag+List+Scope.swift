public import BlogModule
public import FeatherModuleKit

extension Tag.List {
    public struct Scope: FeatherModuleKit.Scope {
        public let tag: any Query.Interface

        public init(tag: any Query.Interface) {
            self.tag = tag
        }
    }
}
