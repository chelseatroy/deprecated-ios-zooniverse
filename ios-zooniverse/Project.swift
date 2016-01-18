import Foundation

class Project {
    
    var title: String
    var description: String
    var classifications_count: String
    
    init(json: NSDictionary) {
        self.title = json["display_name"] as String
        self.description = json["description"] as String
        self.classifications_count = json["classifications_count"] as String
    }
}