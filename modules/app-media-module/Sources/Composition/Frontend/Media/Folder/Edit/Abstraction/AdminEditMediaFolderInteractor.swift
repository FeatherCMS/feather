import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminEditMediaFolderInteractor: Sendable {
    func load(
        id: String
    ) async throws -> AdminEditMediaFolderModel
    func update(
        id: String,
        input: MediaFolderEditForm
    ) async throws
        -> AdminEditMediaFolderModel
}
