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

protocol AdminListMediaProcessorInteractor: Sendable {

    func listMediaProcessors(
        page: Int,
        search: String?
    ) async throws -> NewAdminListModel<
        Components.Schemas.MediaProcessorListItemSchema
    >

    func remove(
        ids: [String]
    ) async throws
}
