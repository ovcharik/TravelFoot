class Places
  @name = 'Places'
  @shema = {
    name:    { type: String, required: true },
    discription: { type: String},
    coord: { type: [Number], index: '2d', required: true }
    image: { type: String }
  }
