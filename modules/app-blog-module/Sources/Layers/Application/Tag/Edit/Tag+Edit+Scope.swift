public import BlogDomain
public import BlogModule
public import FeatherModuleKit
public import SystemApplication
public import SystemModule
public import WebDomain

extension Tag.Edit {
    public struct Scope: FeatherModuleKit.Scope {
        public let tag: any Tag.Repository.Interface
        public let metadata: any Metadata.Repository.Interface
        public let variable: any SystemModule.Variable.Lookup.Interface

        public init(
            tag: any Tag.Repository.Interface,
            metadata: any Metadata.Repository.Interface,
            variable: any SystemModule.Variable.Lookup.Interface
        ) {
            self.tag = tag
            self.metadata = metadata
            self.variable = variable
        }
    }
}
