import HTTPTypes
import NIOCore
import OpenAPIRuntime
//#if canImport(FoundationEssentials)
//import FoundationEssentials
//#else
//import Foundation
//#endif
import Foundation

struct UnescapeHTTPHeadersMiddleware: ServerMiddleware {

    private func decodeAndValidate(
        _ value: String
    ) -> String? {
        let decoded = value.removingPercentEncoding ?? value
        let hasForbiddenControlCharacter = decoded.unicodeScalars.contains {
            $0.value < 0x20 || $0.value == 0x7F
        }
        guard !hasForbiddenControlCharacter else {
            return nil
        }
        return decoded
    }

    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        metadata: ServerRequestMetadata,
        operationID: String,
        next: MiddlewareNextBlock
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var (response, responseBody) = try await next(request, body, metadata)

        let unescapeFieldList: [HTTPField.Name] = [
            .location,
            .contentType,
            .contentDisposition,
            .accessControlExposeHeaders,
            .accessControlAllowOrigin,
            .contentRange,
        ]

        for fieldName in unescapeFieldList {
            if let field = response.headerFields[fieldName] {
                response.headerFields[fieldName] = decodeAndValidate(field)
            }

            if let customFieldName = HTTPField.Name(
                fieldName.rawName + "-Custom"
            ),
                let customField = response.headerFields[customFieldName]
            {
                response.headerFields[customFieldName] =
                    decodeAndValidate(customField)
            }
        }

        return (response, responseBody)
    }
}
