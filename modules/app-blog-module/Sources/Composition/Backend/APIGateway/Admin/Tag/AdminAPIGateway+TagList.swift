public import BlogAdminAPI
import BlogApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func blogTagList(
        _ input: Operations.BlogTagList.Input
    ) async throws -> Operations.BlogTagList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeListTags()
            .execute(subject: subject, input: .init())
        return .ok(.init(body: .json(result.items.map(map))))
    }
}
