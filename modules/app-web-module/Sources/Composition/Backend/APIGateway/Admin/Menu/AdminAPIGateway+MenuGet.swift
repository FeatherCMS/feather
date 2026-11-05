import FeatherModuleKit
import Foundation
public import WebAdminAPI
import WebApplication
import WebModule

extension AdminAPIGateway {

    public func menuGet(
        _ input: Operations.MenuGet.Input
    ) async throws -> Operations.MenuGet.Output {
        let useCase = useCases.makeDetailMenu()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.menuId)
        )

        return .ok(.init(body: .json(mapMenuDetail(result))))
    }

    private func mapMenuDetail(
        _ detail: Menu.Detail.Output
    ) -> Components.Schemas.MenuDetailSchema {
        .init(
            id: detail.id,
            key: detail.key,
            name: detail.name,
            notes: detail.notes,
            createdAt: detail.createdAt.timeIntervalSince1970,
            updatedAt: detail.updatedAt.timeIntervalSince1970
        )
    }
}
