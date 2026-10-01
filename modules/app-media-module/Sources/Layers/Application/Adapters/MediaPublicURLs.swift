public import FeatherDomain
import Foundation

public func mediaAssetPublicURL(
    id: String,
    slugPath: String,
    filename: String,
    `extension`: String,
    objectKeyGenerator: any ObjectKeyGenerator
) throws -> String {
    let prefix = try objectKeyGenerator.generate(from: id)
    let folderPath = slugPath.split(separator: "/").dropLast()
        .map(String.init).joined(separator: "/")
    let virtualPath = [folderPath, filename].filter { !$0.isEmpty }
        .joined(separator: "/")
    return
        "/public/\(prefix)/originals/\(encodedPath(virtualPath)).\(`extension`)"
}

public func mediaVariantPublicURL(
    assetId: String,
    slugPath: String,
    filename: String,
    variantKey: String,
    `extension`: String,
    objectKeyGenerator: any ObjectKeyGenerator
) throws -> String {
    let prefix = try objectKeyGenerator.generate(from: assetId)
    let folderPath = slugPath.split(separator: "/").dropLast()
        .map(String.init).joined(separator: "/")
    let virtualPath = [folderPath, filename].filter { !$0.isEmpty }
        .joined(separator: "/")
    return
        "/public/\(prefix)/variants/\(encodedSegment(variantKey))/\(encodedPath(virtualPath)).\(`extension`)"
}

private func encodedPath(_ value: String) -> String {
    var allowed = CharacterSet.urlPathAllowed
    allowed.remove(charactersIn: "%?#")
    return value.addingPercentEncoding(withAllowedCharacters: allowed) ?? value
}

private func encodedSegment(_ value: String) -> String {
    var allowed = CharacterSet.urlPathAllowed
    allowed.remove(charactersIn: "/%?#")
    return value.addingPercentEncoding(withAllowedCharacters: allowed) ?? value
}
