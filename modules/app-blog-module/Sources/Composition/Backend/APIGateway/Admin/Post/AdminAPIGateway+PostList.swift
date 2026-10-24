public import BlogAdminAPI
import BlogApplication
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {

    public func blogPostList(
        _ input: Operations.BlogPostList.Input
    ) async throws -> Operations.BlogPostList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeListPosts()
            .execute(subject: subject, input: .init())
        return .ok(.init(body: .json(result.items.map(mapPostListItem))))
    }

    private func mapPostListItem(
        _ item: Post.List.Output.Item
    ) -> Components.Schemas.PostListItemSchema {
        .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            imageAssetId: item.imageAssetId,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }
}
