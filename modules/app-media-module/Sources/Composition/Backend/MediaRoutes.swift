import Foundation
import Hummingbird
import MediaApplication
import NIOCore

public func registerMediaAssetRoutes<C: RequestContext>(
    on router: Router<C>,
    media: MediaBackend.UseCases
) {
    router.get("/media/assets/**") { request, _ in
        guard
            let parts = mediaRouteParts(
                request.uri.path,
                prefix: "/media/assets/"
            )
        else { return Response(status: .badRequest) }
        do {
            let asset = try await media.getAssetDetails(id: parts.id)
            let requestedSlugPath =
                parts.path.removingPercentEncoding ?? parts.path
            let expected = "\(asset.slugPath).\(asset.extension)"
            if requestedSlugPath != expected {
                return Response(
                    status: .movedPermanently,
                    headers: [
                        .location: "/media/assets/\(asset.id)/\(expected)"
                    ]
                )
            }
            let result = try await media.readOriginalAssetFile(
                assetId: asset.id
            )
            var buffer = ByteBufferAllocator()
                .buffer(capacity: result.data.count)
            buffer.writeBytes(result.data)
            var headers = HTTPFields()
            headers[.contentType] = result.type
            headers[.cacheControl] = "public, max-age=31536000, immutable"
            if request.uri.queryParameters["download"].map(String.init) == "1" {
                headers[.contentDisposition] =
                    "attachment; filename=\"\(safeMediaFilename(result.filename))\""
            }
            return Response(
                status: .ok,
                headers: headers,
                body: .init(byteBuffer: buffer)
            )
        }
        catch { return Response(status: .notFound) }
    }

    router.get("/media/variants/**") { request, _ in
        guard
            let parts = mediaRouteParts(
                request.uri.path,
                prefix: "/media/variants/"
            )
        else { return Response(status: .badRequest) }
        do {
            guard
                let filename = parts.path.split(separator: "/").last
                    .map(String.init)
            else { return Response(status: .badRequest) }
            let variantName = URL(fileURLWithPath: filename)
                .deletingPathExtension().lastPathComponent
            let result = try await media.readVariantFile(
                assetId: parts.id,
                variantName: variantName
            )
            var buffer = ByteBufferAllocator()
                .buffer(capacity: result.data.count)
            buffer.writeBytes(result.data)
            return Response(
                status: .ok,
                headers: [
                    .contentType: result.type,
                    .cacheControl: "public, max-age=31536000, immutable",
                ],
                body: .init(byteBuffer: buffer)
            )
        }
        catch { return Response(status: .notFound) }
    }
}

private func mediaRouteParts(_ path: String, prefix: String) -> (
    id: String, path: String
)? {
    guard path.hasPrefix(prefix) else { return nil }
    let suffix = String(path.dropFirst(prefix.count))
    guard let slash = suffix.firstIndex(of: "/"), slash > suffix.startIndex
    else { return nil }
    let id = String(suffix[..<slash])
    let rest = String(suffix[suffix.index(after: slash)...])
    return rest.isEmpty ? nil : (id, rest)
}

private func safeMediaFilename(_ value: String) -> String {
    let allowed = CharacterSet(
        charactersIn:
            "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.-_"
    )
    let sanitized = String(
        value.unicodeScalars.map {
            allowed.contains($0) ? Character(String($0)) : "-"
        }
    )
    return sanitized.isEmpty ? "download" : sanitized
}
