import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import WebComponents

protocol AdminRemoveMediaVariantInteractor: Sendable {
    func names(ids: [String]) async throws -> [NewAdminRemoveItemContext]
    func delete(ids: [String]) async throws
}
