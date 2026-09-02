import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminListMediaProcessorDefaultInteractor:
    AdminListMediaProcessorInteractor
{
    let repository: AdminMediaProcessorOpenAPIRepository

    func listMediaProcessors(
        page: Int
    ) async throws -> AdminListMediaProcessorModel {
        let result = try await repository.listProcessors(page: page)
        return .init(
            items: result.items,
            total: result.total,
            page: result.page,
            pageSize: result.pageSize
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
