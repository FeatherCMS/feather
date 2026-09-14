import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListMediaProcessorDefaultInteractor:
    AdminListMediaProcessorInteractor
{
    let repository: AdminMediaProcessorOpenAPIRepository

    func listMediaProcessors(
        page: Int,
        search: String?
    ) async throws -> NewAdminListModel<
        Components.Schemas.MediaProcessorListItemSchema
    > {
        let result = try await repository.listProcessors(
            page: page,
            search: search
        )
        return .init(
            items: result.items,
            pageState: result.pageState
        )
    }

    func remove(
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }
}
