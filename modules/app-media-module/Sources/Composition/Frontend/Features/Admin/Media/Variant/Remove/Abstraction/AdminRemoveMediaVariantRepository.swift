import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import MediaAdminAPI
import WebComponents

protocol AdminRemoveMediaVariantRepository: Sendable {
    func names(ids: [String]) async throws -> [NewAdminRemoveItemContext]
    func delete(ids: [String]) async throws
}
