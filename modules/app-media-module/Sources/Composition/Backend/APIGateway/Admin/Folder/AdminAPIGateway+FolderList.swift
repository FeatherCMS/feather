import FeatherModuleKit
public import MediaAdminAPI
import MediaApplication

extension AdminAPIGateway {
    public func mediaFolderList(
        _ input: Operations.MediaFolderList.Input
    ) async throws -> Operations.MediaFolderList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeListFolders()
            .execute(
                subject: subject,
                input: .init(parentId: input.query.parentId)
            )
        return .ok(
            .init(body: .json(result.items.map(mapFolderListItem)))
        )
    }
}
