mongosh "mongodb+srv://sandbox.p3f8a.mongodb.net/Sandbox" --apiVersion 1 --username michael

mongodump --uri "mongodb+srv://michael:Pass123@sandbox.p3f8a.mongodb.net/sample_supplies"

mongoexport --uri="mongodb+srv://michael:Pass123@sandbox.p3f8a.mongodb.net/sample_supplies" --collection=sales --out=sales.json

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
db.zips.updateMany({ "city": "HUDSON" }, { "$inc": { "pop": 10 }})
# "$inc" => increment

db.zips.updateOne({})