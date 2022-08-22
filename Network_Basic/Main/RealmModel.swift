import Foundation

import RealmSwift

class UserMovie: Object {
    @Persisted var rank: String
    @Persisted var rankON: String
    @Persisted var movieTitle: String
    @Persisted var openDate: String
    @Persisted var dateID: String
    
    @Persisted(primaryKey: true) var objectID: ObjectId
    
    convenience init(rank: String, rankON: String, movieTitle: String, openDate: String, dateID: String) {
        self.init()
        self.rank = rank
        self.rankON = rankON
        self.movieTitle = movieTitle
        self.openDate = openDate
        self.dateID = dateID
    }
    

}
