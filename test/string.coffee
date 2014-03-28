require '../libs/string'

describe 'String', ->
  
  it 'should be have #capitalize', ->
    String::should.be.have.property 'capitalize'
    String::capitalize.should.be.a.Function
  
  describe '#capitalize', ->
    it 'string should be capitalized', ->
      "foo".capitalize().should.be.eql "Foo"
