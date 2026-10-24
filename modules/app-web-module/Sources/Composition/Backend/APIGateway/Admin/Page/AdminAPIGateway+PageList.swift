import FeatherModuleKit
public import WebAdminAPI
import WebApplication
import Foundation
import WebModule

extension AdminAPIGateway {

    public func pageList(
        _ input: Operations.PageList.Input
    ) async throws -> Operations.PageList.Output {
        let useCase = useCases.makeListPages()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init()
        )
        return .ok(
            .init(body: .json(result.items.map(mapPageListItem)))
        )
    }

    private func mapPageListItem(
        _ item: Page.List.Output.Item
    ) -> Components.Schemas.PageListItemSchema {
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
