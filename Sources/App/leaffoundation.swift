import Vapor
import Leaf

protocol NIOLeafSource: LeafSource {

    var fileio: NonBlockingFileIO { get }
    /// reads an existing file and returns a byte buffer future
    func read(path: String, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer>
}

extension NIOLeafSource {
    func read(path: String, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer> {
        fileio.openFile(path: path, eventLoop: eventLoop)
        .flatMapErrorThrowing { _ in throw LeafError(.noTemplateExists(path)) }
        .flatMap { handle, region in
            fileio.read(fileRegion: region, allocator: .init(), eventLoop: eventLoop)
            .flatMapThrowing { buffer in
                try handle.close()
                return buffer
            }
        }
    }
}

