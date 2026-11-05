/// S3 configuration shared by the server and worker.
public struct S3StorageConfig: Sendable {
    public let accessKeyId: String
    public let secretAccessKey: String
    public let region: String
    public let endpoint: String?
    public let bucket: String

    public init(
        accessKeyId: String,
        secretAccessKey: String,
        region: String,
        endpoint: String?,
        bucket: String
    ) {
        self.accessKeyId = accessKeyId
        self.secretAccessKey = secretAccessKey
        self.region = region
        self.endpoint = endpoint
        self.bucket = bucket
    }
}
