public import FeatherModuleKit
public import WebApplication
import WebDomain
public import WebModule

extension Public.Tag.Detail {
    public struct Scope: FeatherModuleKit.Scope {
        public let tag: any Public.Tag.Detail.Query.Interface
        public let postDetail: any Public.Post.Detail.Query.Interface
        public let postList: any Public.Post.List.Query.Interface
        public let metadata: any WebModule.Metadata.Reference.Query.Interface

        public init(
            tag: any Public.Tag.Detail.Query.Interface,
            postDetail: any Public.Post.Detail.Query.Interface,
            postList: any Public.Post.List.Query.Interface,
            metadata: any WebModule.Metadata.Reference.Query.Interface
        ) {
            self.tag = tag
            self.postDetail = postDetail
            self.postList = postList
            self.metadata = metadata
        }
    }
}
