mongosh "mongodb+srv://sandbox.p3f8a.mongodb.net/Sandbox" --apiVersion 1 --username michael

mongodump --uri "mongodb+srv://michael:Pass123@sandbox.p3f8a.mongodb.net/sample_supplies"

mongoexport --uri="mongodb+srv://michael:Pass123@sandbox.p3f8a.mongodb.net/sample_supplies" --collection=sample_training --out=training.json

mongorestore --uri "mongodb+srv://michael:Pass123@sandbox.p3f8a.mongodb.net/sample_supplies"  --drop dump

mongoimport --uri="mongodb+srv://michael:Pass123@sandbox.p3f8a.mongodb.net/sample_supplies" --drop sales.json

# Find Command
mongosh "mongodb+srv://michael:Pass123@sandbox.p3f8a.mongodb.net/admin"

show dbs

use sample_training
show collections
db.zips.find( { "state": "NY" } )
it # iterate through the results

db.zips.find( { "state": "NY" } ).count()

db.zips.find( { "state": "NY", "city": "ALBANY" } ).count()

db.zips.find( { "state": "NY", "city": "ALBANY" } ).pretty()

use sample_mflix
db.movies.find( { "type": "movie" }).count()
db.movies.countDocuments()


# Inserting new documents
use sample_training
db.inspections.findOne()

db.inspections.insert({
  id: '10021-2015-ENFO',
  certificate_number: 9278806,
  business_name: 'ATLIXCO DELI GROCERY INC.',
  date: 'Feb 20 2015',
  result: 'No Violation Issued',
  sector: 'Cigarette Retail Dealer - 127',
  address: { city: 'RIDGEWOOD', zip: 11385, street: 'MENAHAN ST', number: 1712 }
})

db.inspections.find( { certificate_number: 9278806, business_name: 'ATLIXCO DELI GROCERY INC.' } )


# insert() order
db.inspections.insert([ { "test": 1 }, { "test": 2 }, { "test": 3 } ])
db.inspections.insert([{ "_id": 1, "test": 1 },{ "_id": 1, "test": 2 },{ "_id": 3, "test": 3 }])
db.inspections.insert([{ "_id": 1, "test": 1 },{ "_id": 1, "test": 2 },
    { "_id": 3, "test": 3 }],{ "ordered": false })

show dbs

# Creating & manipulating documents

use sample_training
db.zips.find().pretty()
db.zips.find({"zip": "12534"})

db.zips.find({ "city": "HUDSON" }).count()

db.zips.updateMany({ "city": "HUDSON" }, { "$inc": { "pop": 10 }})
# "$inc" => increment

<<<<<<< HEAD
db.zips.updateOne({})

# Advanced CRUD operations
mongosh "mongodb+srv://michael:Pass123@sandbox.p3f8a.mongodb.net/admin"
use sample_training
db.trips.find( { "tripduration": { "$lte": 60 } } )
db.trips.find( { "tripduration": { "$lte": 70 } } )
db.trips.find( { "tripduration": { "$lte": 70 }, "usertype": { "$ne": "Subscriber" } } )

db.trips.find( { "tripduration": { "$lte": 70 }, "usertype": { "$eq": "Customer" } } )
# Same as
db.trips.find( { "tripduration": { "$lte": 70 }, "usertype": "Customer" } )
# ==> $eq is default operator
# can use $eq, $ne, $lt, $lte, $gt, $gte, ...

# zips with population less than 1000 
db.zips.find( { "pop": { "$lt": 1000 } } ).count()

# in trips,  difference between the number of people born in 1998 and the number of people born after 1998
db.trips.find( { "birth year": 1998 } ).count()
db.trips.find( { "birth year": { "$gt": 1998 } } ).count()
db.trips.find( { "birth year": { "$gt": 1998 } } ).count() - db.trips.find( { "birth year": 1998 } ).count()

# Using the sample_training.routes collection find out which of the following statements will return all routes that have at least one stop in them?
db.routes.find( {"stops": { "$ne": 0 } } ).count()


# Query Operators - Logic

# $and, $or, $nor, $not

db.inspections.find( { $nor: [ { "result": "No Violation Issued"}, { "result": "Violation Issued" }, {"result": "Pass"}, {"result": "Fail"} ] } )

db.inspections.find( { $nor: [ 
  { "result": "No Violation Issued"}, 
  { "result": "Violation Issued" }, 
  {"result": "Pass"}, 
  {"result": "Fail"} ] } )

db.inspections.find( { $not: [ { "result": "Pass" } ] } )

db.routes.find({ "$and": [ { "$or": [ { "src_airport": "KZN" }, { "dst_airport": "KZN" } ] },
  { "$or": [{ "airplane": "CR2" }, { "airplane": "A81" }] } ]
}).count()


# How many businesses in the sample_training.inspections dataset have the inspection result "Out of Business" and belong to the "Home Improvement Contractor - 100"

db.inspections.find( { "result": "Out of Business", "sector": "Home Improvement Contractor - 100" } ).count()

# How many zips in the sample_training.zips dataset are neither over-populated nor under-populated?
# 5000 < X < 1 000 000
db.zips.find({ $and: [ { "pop": { "$gt": 5000 } }, { "pop": { "$lt": 1000000 } } ] })
db.zips.find({ $and: [ { "pop": { "$gt": 5000 } }, { "pop": { "$lt": 1000000 } } ] }).count()

# Companies (founded in 2004 & category_code "social" or "web") or (founded on month of October & category_code "social" or "web") 
db.companies.findOne()

db.companies.find(
  {
    "$and": [
      { "$or": [
        { "founded_year": 2004 },
        { "founded_month": 10 },  
      ]},
      { "$or": [
        { "category_code": "social" },
        { "category_code": "web" }
      ]},
    ]
  }
).count()

# Expressive Query Operator
db.trips.find(
  {
    "$expr": {
      "$eq": [
        "$end station id",
        "$start station id"
      ]
    }
  }
).count()

db.trips.find(
  {
    "$expr": {
      "$and": [
        {
          "$gt": [
            "$tripduration", 1200
          ]
        },
        {
          "$eq": [
            "$end station id",
            "$start station id"
          ]
        }
      ]  
    }
  }
).count()

# How many companies in the sample_training.companies collection have the same permalink as their twitter_username?

db.companies.find(
  {
    "$expr": {
      "$eq": [
        "$twitter_username", "$permalink"
      ]
    }
  }
).count()

# Array Operators
use sample_airbnb

db.listingsAndReviews.findOne()

db.listingsAndReviews.find(
  {
    "amenities": {
      "$size": 20,
      "$all": [ "Internet", "Wifi",  "Kitchen",
        "Heating", "Family/kid friendly",
        "Washer", "Dryer", "Essentials",
        "Shampoo", "Hangers",
        "Hair dryer", "Iron",
        "Laptop friendly workspace" 
      ]
    }
  }
)

#What is the name of the listing in the sample_airbnb.listingsAndReviews dataset that accommodates more than 6 people 
#and has exactly 50 reviews?
db.listingsAndReviews.find(
  {
    "accommodates": { "$gt": 6 },
    "reviews": {
      "$size": 50
    }
  }
)

#Using the sample_airbnb.listingsAndReviews collection find out how many documents have the "property_type" "House", 
#and include "Changing table" as one of the "amenities"?
db.listingsAndReviews.find(
  {
    "property_type": "House",
    "amenities": "Changing table"
  }
).count()

db.listingsAndReviews.find(
  {},
  {"price": 1, "address": 1, "_id": 0}
)

use sample_training

db.grades.findOne()

db.grades.find({ "class_id": 431 },
               { "scores": { "$elemMatch": { "score": { "$gt": 85 } } }
             }).pretty()

db.grades.find({ "scores": { "$elemMatch": { "type": "extra credit" } }
               }).pretty()

# How many companies in the sample_training.companies collection have offices in the city of Seattle?
db.companies.find(
  {
    "offices": { "$elemMatch": { "city": "Seattle" } }
  },
  { "name": 1, "_id": 0 }
)

use sample_training

db.trips.findOne()

db.trips.findOne(
  {
    "start station location.type": "Point"
  }
)

db.companies.find(
  { "relationships.0.person.last_name": "Zuckerberg"},
  { "name": 1 }
)

db.companies.find(
  {
    "relationships.0.person.first_name": "Mark",
    "relationships.0.title": { "$regex": "CEO" }
  },
  { "name": 1, "_id": 0 }
)

db.companies.find({
    "relationships": {
      "$elemMatch": {
        "is_past": true,
        "person.first_name": "Mark"
      }
    }
  },{
    "name": 1
  }
).count()

# How many trips in the sample_training.trips collection started at stations that are to the west of the -74 longitude coordinate?
db.trips.find(
  {
    "start station location.coordinates.0": { "$lt": -74 }
  }
).count()

# How many inspections from the sample_training.inspections collection were conducted in the city of NEW YORK?
db.inspections.findOne()

db.inspections.find(
  {
    "address.city": "NEW YORK"
  }
).count()

# Aggregation Framework
use sample_airbnb

db.listingsAndReviews.find(
  { "amenities": "Wifi" },
  { "price": 1, "address": 1, "_id": 0 }
)

db.listingsAndReviews.aggregate(
  [
    { "$match": { "amenities": "Wifi" } },
    { "$project": { "price": 1, "address": 1, "_id": 0 }}
  ]
)

db.listingsAndReviews.findOne({}, { "address": 1, "_id": 0 })

db.listingsAndReviews.aggregate(
  [ 
    { 
      "$project": { "address": 1, "_id": 0 } 
    },
    {
      "$group": { "_id": "$address.country" }
    }
  ]
)

db.listingsAndReviews.aggregate(
  [ 
    { 
      "$project": { "address": 1, "_id": 0 } 
    },
    {
      "$group": { 
        "_id": "$address.country",
        "count": { "$sum": 1 } 
      }
    }
  ]
)

# What room types are present in the sample_airbnb.listingsAndReviews collection?
db.listingsAndReviews.findOne({}, { "room_type": 1 })
db.listingsAndReviews.aggregate(
  [
    {
      "$project": { "room_type": 1, "_id": 0 }
    },
    {
      "$group": { "_id": "$room_type",
        "count": { "$sum": 1 } 
      }
    }
  ]
)

# sort() and limit()

use sample_training

db.zips.find({},{"city": 1, "zip": 1, "pop": 1, "_id": 0}).sort({"pop": -1}).limit(10)

# In what year was the youngest bike rider from the sample_training.trips collection born?
use sample_training

db.trips.findOne()
db.trips.find({ "birth year": { "$ne": "" } }, { "birth year": 1, "_id": 0 }).sort({"birth year": -1})

# Introduction to indexes
=======
db.zips.updateOne({ "zip": "12534" }, { "$set": { "pop": 17630 } })

db.grades.find()
db.grades.find({ "student_id": 151})
db.grades.find({ "student_id": 151, "class_id": 339 }).pretty()
db.grades.find({ "student_id": 250, "class_id": 339 })

db.grades.updateOne({ "student_id": 250, "class_id": 339 },
                    { "$push": { "scores": { "type": "extra credit",
                                             "score": 100 }
                                }
                     })
>>>>>>> 0c83c6fe493b791cbaf7f9f8ab322eec3a3932fb
