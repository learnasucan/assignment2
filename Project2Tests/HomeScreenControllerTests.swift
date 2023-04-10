//
//  HomeScreenControllerTests.swift
//  Project2Tests
//
//  Created by Prachit on 10/04/23.
//
@testable import Project2
import XCTest

final class HomeScreenControllerTests: XCTestCase {
    
    var homeScreenController: HomeScreenController!
    
    var jsonData1: Data {
        return """
   {
     "components": [
       {
         "type": "image",
         "cells": [
           {
             "imageUrl": "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg",
             "name": "Example 4",
             "description": "This is a fourth example",
             "dmartValue": 467,
             "saveValue": 119,
             "mrpValue": 348,
             "productType": "house",
             "veg": false
           }
         ]
       },
       {
         "type": "grid",
         "cells": [
           {
             "imageUrl": "https://cdn.dmart.in/images/products/JUN210000020xx29JUN22_5_P.jpg",
             "name": "Pampers Aloe Vera Baby Wipes : 72 Wipes",
             "description": "This is an example",
             "dmartValue": 467,
             "saveValue": 119,
             "mrpValue": 348,
             "productType": "house",
             "veg": false
           },
           {
             "imageUrl": "https://cdn.dmart.in/images/products/FEB210000569xx27FEB22_5_P.jpg",
             "name": "Himalaya Gentle Baby Soap : 4x75 gms",
             "value": "20",
             "description": "This is another example",
             "dmartValue": 467,
             "saveValue": 119,
             "mrpValue": 348,
             "productType": "house",
             "veg": false
           },
           {
             "imageUrl": "https://cdn.dmart.in/images/products/ISoaps75gm4773xx290720_5_P.jpg",
             "name": "Johnson's Baby Shampoo : 500 ml",
             "description": "This is a third example",
             "dmartValue": 467,
             "saveValue": 119,
             "mrpValue": 348,
             "productType": "house",
             "veg": false
           }
         ]
       },
       {
         "type": "list",
         "cells": [
           {
             "imageUrl": "https://cdn.dmart.in/images/products/NOV110000379xx20NOV21_5_I.jpg",
             "name": "Premia Sugar : 5 kgs",
             "description": "This is an example",
             "dmartValue": 220,
             "saveValue": 44,
             "mrpValue": 264,
             "productType": "house",
             "veg": true
           }
         ]
       },
       {
         "type": "image",
         "cells": [
           {
             "imageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoTt00SKrkY7tZdjpL7lF2LOBCghiTiwhPDQ&usqp=CAU",
             "name": "Example 1",
             "description": "This is an example",
             "dmartValue": 467,
             "saveValue": 119,
             "mrpValue": 348,
             "productType": "house",
             "veg": false
           }
         ]
       }
     ]
   }
""".data(using: .utf8)!
    }
    
    
    var jsonData2: Data {
        return """
       {
          [
           {
             "type": "grid",
             "cells": [
               {
                 "imageUrl": "https://cdn.dmart.in/images/products/JUN210000020xx29JUN22_5_P.jpg",
                 "name": "Pampers Aloe Vera Baby Wipes : 72 Wipes",
                 "description": "This is an example",
                 "dmartValue": 467,
                 "saveValue": 119,
                 "mrpValue": 348,
                 "productType": "house",
                 "veg": false
               } // missing comma here
             ]
           },
           {
             "type": "list",
             "cells": [
               {
                 "imageUrl": "https://cdn.dmart.in/images/products/NOV110000379xx20NOV21_5_I.jpg",
                 "name": "Premia Sugar : 5 kgs",
                 "description": "This is an example",
                 "dmartValue": 220,
                 "saveValue": 44,
                 "mrpValue": 264,
                 "productType": "house",
                 "veg": true
               }
             ]
           },
           {
             "type": "image",
             "cells": [
               {
                 "imageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoTt00SKrkY7tZdjpL7lF2LOBCghiTiwhPDQ&usqp=CAU",
                 "name": "Example 1",
                 "description": "This is an example",
                 "dmartValue": 467,
                 "saveValue": 119,
                 "mrpValue": 348,
                 "productType": "house",
                 "veg": false
               }
             ]
           }
         ]
       }
    """.data(using: .utf8)!
    }
    
    override func setUp() {
        super.setUp()
        homeScreenController = HomeScreenController()
    }
    
    func testLoadDataParsingSuccesfullyFromJsonFile() {
        
        do {
            let decoder = JSONDecoder()
            let responseData = try decoder.decode(ResponseData.self, from: jsonData1)
            homeScreenController.components = responseData.components
        }catch{
            XCTFail("Error loading data \(error.localizedDescription)")
        }
        
        //Check How many componnents
        XCTAssertEqual(homeScreenController.components.count, 4)
        //
        XCTAssertEqual(homeScreenController.components[0].type, .image)
        XCTAssertEqual(homeScreenController.components[0].cells.count, 1)
        
        XCTAssertEqual(homeScreenController.components[1].type, .grid)
        
    }
    
    
    func testLoadDataParsingFailureFromJsonFile() {
        
        do {
            let decoder = JSONDecoder()
            let responseData = try decoder.decode(ResponseData.self, from: jsonData2)
            homeScreenController.components = responseData.components
        }catch{
            XCTFail("Error loading data \(error.localizedDescription)")
        }
        
        //Check How many componnents
        XCTAssertEqual(homeScreenController.components.count, 4)
        //
        XCTAssertEqual(homeScreenController.components[0].type, .image)
        XCTAssertEqual(homeScreenController.components[0].cells.count, 1)
        
        XCTAssertEqual(homeScreenController.components[1].type, .grid)
        
    }
    
    func testNumbersOfGridInGridSection() {
        //It should fail as we used 3 grids
        XCTAssertEqual(homeScreenController.numberOfproductsInGrid, 2)
    }
    
    
    override  func tearDown() {
        super.tearDown()
        homeScreenController = nil
    }
    
    
}
