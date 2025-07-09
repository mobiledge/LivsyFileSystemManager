import Foundation

/// File System manager to perform CRUD operations.
public final class FileSystemManager {
    
    private let fileManager: FileManager
    public init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    public func save<T: Codable>(
        _ data: T,
        key: String,
        directory: FileManager.SearchPathDirectory,
        domainMask: FileManager.SearchPathDomainMask = .userDomainMask,
        encoder: JSONEncoder = JSONEncoder()
    ) throws {
        let filePath = try filePath(
            key: key,
            directory: directory,
            domainMask: domainMask
        )
        let jsonData = try encoder.encode(data)
        try jsonData.write(to: filePath)
    }
    
    public func retrieve<T: Codable>(
        _ type: T.Type,
        key: String,
        directory: FileManager.SearchPathDirectory,
        domainMask: FileManager.SearchPathDomainMask = .userDomainMask,
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> T {
        let filePath = try filePath(
            key: key,
            directory: directory,
            domainMask: domainMask
        )
        let jsonData = try Data(contentsOf: filePath)
        return try decoder.decode(T.self, from: jsonData)
    }
    
    public func delete(
        key: String,
        directory: FileManager.SearchPathDirectory,
        domainMask: FileManager.SearchPathDomainMask = .userDomainMask
    ) throws {
        let filePath = try filePath(
            key: key,
            directory: directory,
            domainMask: domainMask
        )
        try fileManager.removeItem(at: filePath)
    }
    
    // MARK: - Private Methods
    
    private func filePath(
        key: String,
        directory: FileManager.SearchPathDirectory,
        domainMask: FileManager.SearchPathDomainMask
    ) throws -> URL {
        let url = try fileManager.url(
            for: directory,
            in: domainMask,
            appropriateFor: nil,
            create: false
        )
        
        return url.appendingPathComponent(key)
    }
}
