import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import WebComponents

protocol AdminRemoveMediaVariantInteractor: Sendable {
    func names(ids: [String]) async throws -> [NewAdminRemoveItemContext]
    func delete(ids: [String]) async throws
}
