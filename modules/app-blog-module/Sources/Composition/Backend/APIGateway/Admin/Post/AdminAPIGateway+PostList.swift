public import BlogAdminAPI
import BlogApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func blogPostList(
        _ input: Operations.BlogPostList.Input
    ) async throws -> Operations.BlogPostList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeListPosts()
            .execute(subject: subject, input: .init())
        return .ok(.init(body: .json(result.items.map(map))))
    }
}
