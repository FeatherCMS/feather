import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveMediaAssetInteractor: Sendable {

    func remove(ids: [String]) async throws
}
