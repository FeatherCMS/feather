import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherWebAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

protocol AdminEditAuthAccessControlInteractor: Sendable {

    func loadState(
        isEdited: Bool,
        canEdit: Bool,
        selectedOverride: Set<String>?,
        error: String?
    ) async throws -> AdminEditAuthAccessControlState

    func save(
        input: AdminEditAuthAccessControlFormInput
    ) async throws -> AdminEditAuthAccessControlSaveResult
}
