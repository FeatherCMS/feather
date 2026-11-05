struct S3StorageConfig: Sendable {
    let accessKeyId: String
    let secretAccessKey: String
    let region: String
    let endpoint: String?
    let bucket: String
}
