import Foundation

/// File System manager to perform CRUD operations.
public final class FileSystemManager {
    
    // MARK: - Public Methods
    
    public func save<T: Codable>(
        _ data: T,
        key: String,
        directory: FileManager.SearchPathDirectory,
        domainMask: FileManager.SearchPathDomainMask = .userDomainMask
    ) throws {
        let filePath = try filePath(
            key: key,
            directory: directory,
            domainMask: domainMask
        )
        let jsonData = try JSONEncoder().encode(data)
        
        try jsonData.write(to: filePath)
    }
    
    public func retrieve<T: Codable>(
        _ type: T.Type,
        key: String,
        directory: FileManager.SearchPathDirectory,
        domainMask: FileManager.SearchPathDomainMask = .userDomainMask
    ) throws -> T {
        let filePath = try filePath(
            key: key,
            directory: directory,
            domainMask: domainMask
        )
        let jsonData = try Data(contentsOf: filePath)
        
        return try JSONDecoder().decode(T.self, from: jsonData)
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
        
        try FileManager().removeItem(at: filePath)
    }
    
    // MARK: - Private Methods
    
    private func filePath(
        key: String,
        directory: FileManager.SearchPathDirectory,
        domainMask: FileManager.SearchPathDomainMask
    ) throws -> URL {
        let documentDirectory = try FileManager.default.url(
            for: directory,
            in: domainMask,
            appropriateFor: nil,
            create: false
        )
        
        return documentDirectory.appendingPathComponent(key)
    }
    
}
