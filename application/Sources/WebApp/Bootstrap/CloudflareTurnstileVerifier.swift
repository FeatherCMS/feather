import FeatherWebShared
import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct CloudflareTurnstileVerifier: TurnstileVerifier {
    private struct RequestBody: Encodable {
        let secret: String
        let response: String
    }

    private struct ResponseBody: Decodable {
        let success: Bool
    }

    let siteKey: String
    private let secretKey: String

    func verify(token: String?) async throws -> Bool {
        guard let token, !token.isEmpty, token.utf8.count <= 2048 else {
            return false
        }

        guard
            let url = URL(
                string: "https://challenges.cloudflare.com/turnstile/v0/siteverify"
            )
        else {
            return false
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 5
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(
            RequestBody(secret: secretKey, response: token)
        )

        let (data, response) = try await URLSession.shared.data(for: request)
        guard
            let response = response as? HTTPURLResponse,
            response.statusCode == 200
        else {
            return false
        }

        return try JSONDecoder().decode(ResponseBody.self, from: data).success
    }

    init(siteKey: String, secretKey: String) {
        self.siteKey = siteKey
        self.secretKey = secretKey
    }
}
