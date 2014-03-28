require '../libs/array'

describe 'Array', ->
  
  it 'should be have #remove', ->
    Array::should.be.have.property 'remove'
    Array::remove.should.be.a.Function
  
  describe '#remove', ->
    it 'should be removed string', ->
      a = ["foo", "bar", "baz"]
      a.remove("foo").should.be.eql ["bar", "baz"]
    
    it 'should be removed array', ->
      a = ["foo", "bar", "baz"]
      a.remove(["bar", "baz"]).should.be.eql ["foo"]
