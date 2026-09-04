import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminAddMediaFolderInteractor: Sendable {
    func getAddMediaFolder(
        parentId: String?,
        view: String
    ) async throws
        -> AdminAddMediaFolderModel
    func postAddMediaFolder(
        payload: MediaFolderAddForm
    ) async throws
        -> AdminAddMediaFolderModel
}
