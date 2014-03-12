class Tag extends BaseModel
  
  @name = 'Tag'
  @schema = {
    value:  { type: String, required: true, unique: true }
    places: [{ type: @ObjectId, ref: 'Place', unique: true }]
  }
  
module.exports = Tag
