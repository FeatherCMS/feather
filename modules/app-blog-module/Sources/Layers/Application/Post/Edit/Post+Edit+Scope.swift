public import BlogDomain
public import BlogModule
public import FeatherModuleKit
public import SystemApplication
public import SystemModule
public import WebDomain
public import WebModule

extension Post.Edit {
    public struct Scope: FeatherModuleKit.Scope {
        public let post: any Post.Repository.Interface
        public let metadata: any WebModule.Metadata.Repository.Interface
        public let variable: any SystemModule.Variable.Lookup.Query.Interface

        public init(
            post: any Post.Repository.Interface,
            metadata: any WebModule.Metadata.Repository.Interface,
            variable: any SystemModule.Variable.Lookup.Query.Interface
        ) {
            self.post = post
            self.metadata = metadata
            self.variable = variable
        }
    }
}
