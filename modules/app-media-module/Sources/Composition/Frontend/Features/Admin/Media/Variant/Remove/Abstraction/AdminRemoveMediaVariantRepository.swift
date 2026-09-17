import FeatherAdmin
import MediaAdminAPI

import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import WebComponents

protocol AdminRemoveMediaVariantRepository: Sendable {
    func names(ids: [String]) async throws -> [NewAdminRemoveItemContext]
    func delete(ids: [String]) async throws
}
