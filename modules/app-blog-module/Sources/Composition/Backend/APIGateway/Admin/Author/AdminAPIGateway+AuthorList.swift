public import BlogAdminAPI
import BlogApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func blogAuthorList(
        _ input: Operations.BlogAuthorList.Input
    ) async throws -> Operations.BlogAuthorList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeListAuthors()
            .execute(
                subject: subject,
                input: .init()
            )
        return .ok(.init(body: .json(result.items.map(map))))
    }
}
