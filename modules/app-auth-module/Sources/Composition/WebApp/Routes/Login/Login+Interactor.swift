import AuthAppAPI
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebApp
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Login.Interactor {
    protocol Interface: Sendable {

        func execute(
            entity: Login.Model
        ) async throws -> Login.Result
    }
}
