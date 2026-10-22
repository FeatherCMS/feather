public import BlogAdminAPI
import BlogApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func blogAuthorLinkList(
        _ input: Operations.BlogAuthorLinkList.Input
    ) async throws -> Operations.BlogAuthorLinkList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeListAuthorLinks()
            .execute(
                subject: subject,
                input: .init(authorId: input.path.blogAuthorId)
            )
        return .ok(.init(body: .json(result.items.map(map))))
    }
}
