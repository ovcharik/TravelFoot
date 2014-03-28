Module = require '../libs/module'

Bar = {
  prop: 42
  baz: ->
    @prop
}

describe 'Module', ->
  it 'should be have ::extend', ->
    Module.should.be.have.property 'extend'
    Module.extend.should.be.a.Function
  
  describe '::extend', ->
    class Foo extends Module
      @extend Bar
    
    it 'should be extends class', ->
      Foo.should.be.have.property 'prop'
      Foo.should.be.have.property 'baz'
      
      Foo.prop.should.be.a.Number
      Foo.prop.should.eql 42
      
      Foo.baz.should.be.a.Function
      Foo.baz().should.eql 42
  
  
  it 'should be have ::include', ->
    Module.should.be.have.property 'include'
    Module.include.should.be.a.Function
  
  describe '::include', ->
    class Foo extends Module
      @include Bar
    
    it 'should be included class', ->
      Foo::should.be.have.property 'prop'
      Foo::should.be.have.property 'baz'
      
      Foo::prop.should.be.a.Number
      Foo::prop.should.eql 42
      
      Foo::baz.should.be.a.Function
      Foo::baz().should.eql 42
