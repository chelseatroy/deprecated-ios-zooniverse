import Foundation

class Project {
    
    var title: String?
    var description: String?
    var classifications_count: String?
    
    init(json: NSDictionary) {
        if let n = json["display_name"] as? String {
            self.title = n
        }
        if let f = json["description"] as? String {
            self.description = f
        }
        if let h = json["classifications_count"] as? String {
            self.classifications_count = h
        }
    }
}