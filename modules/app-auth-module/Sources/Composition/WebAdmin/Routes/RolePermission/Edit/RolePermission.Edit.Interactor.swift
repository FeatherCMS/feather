import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
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

extension RolePermission.Edit {
    enum Interactor {}
}

extension RolePermission.Edit.Interactor {
    protocol Interface: Sendable {

        func loadState(
            isEdited: Bool,
            canEdit: Bool,
            selectedOverride: Set<String>?,
            error: String?
        ) async throws -> RolePermission.Edit.State

        func save(
            input: RolePermission.Edit.Form.Input
        ) async throws -> RolePermission.Edit.SaveResult
    }
}
