<h1 align="center">NetworkLayerPackage</h1>

A description of this package.

## Response be like:

import NetworkLayerPackage

class CharacterResponse: Response {
    let rickAndMortNetworkConstants = RickAndMortyNetworkConstants()
    
    var pageNumber: Int
    init(pageNumber: Int) {
        self.pageNumber = pageNumber
        super.init()
        self.path = []
        self.networkConstants = rickAndMortNetworkConstants
        self.httpMethod = .get
        path?.append("/character")
        path?.append("?page=\(pageNumber)")
    }
}

## And Request Closure be like
