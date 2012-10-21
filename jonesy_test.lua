require("busted")
require("jonesy")

local t1 = {1,2,3}
local t2 = {}
local t3 = {4,5,6}

function inc(x) 
   return x + 1 
end

function sq(x)
   return x * x
end

function add(x,y) 
   return x + y 
end

function id(x) 
   return x 
end

describe("transpose_tables", function()
   it("Should transpose 3 tables as if each were a row in a matrix", function()
      assert.are.same(jonesy.transpose_tables({1,2,3},{4,5,6},{7,8,9}), {{1,4,7}, {2,5,8}, {3,6,9}})
   end)
end)

describe("empty", function()
   it("Should be true on an empty table", function()
      assert.is.True(jonesy.empty({}))
   end)

   it("Should be false on a table with entries", function()
      assert.is.False(jonesy.empty(t1))
   end)

   it("Should error if provided anything other than a table", function()
      assert.has.errors(function() jonesy.empty(nil) end)
      assert.has.errors(function() jonesy.empty(1) end)
      assert.has.errors(function() jonesy.empty("abc") end)
  end)
end)


describe("head", function()
   it("Should return the first element of a table", function()
      assert.are.equal(jonesy.head(t1), t1[1])
   end)

   it("Should error if provided an empty table", function()
      assert.has.errors(function() jonesy.head({}) end)
  end)
   it("Should error if provided anything other than a table", function()
      assert.has.errors(function() jonesy.head(nil) end)
      assert.has.errors(function() jonesy.head(1) end)
      assert.has.errors(function() jonesy.head("abc") end)
  end)
end)


describe("last", function()
   it("Should return the first element of a table", function()
      assert.are.equal(jonesy.last(t1), t1[#t1])
   end)

   it("Should error if provided an empty table", function()
      assert.has.errors(function() jonesy.last({}) end)
  end)

   it("Should error if provided anything other than a table", function()
      assert.has.errors(function() jonesy.last(nil) end)
      assert.has.errors(function() jonesy.last(1) end)
      assert.has.errors(function() jonesy.last("abc") end)
  end)
end)


describe("tail", function()
   it("Should return every element of a table but the head", function()
      assert.are.same(jonesy.tail(t1), {2,3})
   end)

   it("Should return an empty table if given a table of 1 elem", function()
      assert.are.same(jonesy.tail({1}), {})
   end)

   it("Should error if provided an empty table", function()
      assert.has.errors(function() jonesy.tail({}) end)
   end)

   it("Should error if provided anything other than a table", function()
      assert.has.errors(function() jonesy.tail(nil) end)
      assert.has.errors(function() jonesy.tail(1) end)
      assert.has.errors(function() jonesy.tail("abc") end)
  end)
end)

describe("tails", function()
   it("Should return a table consisting of every tail of every subtable", function()
      assert.are.same(jonesy.tails(t1), {{1,2,3},{2,3},{3},{}})
   end)

   it("Should return a table consisting of 1 empty table when given an empty table", function()
      assert.are.same(jonesy.tails({}), {{}})
   end)

   it("Should error if given anything other than a table", function()
      assert.has.errors(function() jonesy.tails(1) end)
   end)
end)


describe("init", function()
   it("Should return every element of a table but the last", function()
      assert.are.same(jonesy.init(t1), {1,2})
   end)

   it("Should return an empty table if given a table of 1 elem", function()
      assert.are.same(jonesy.init({1}), {})
   end)

   it("Should error if provided an empty table", function()
      assert.has.errors(function() jonesy.init({}) end)
   end)

   it("Should error if provided anything other than a table", function()
      assert.has.errors(function() jonesy.init(nil) end)
      assert.has.errors(function() jonesy.init(1) end)
      assert.has.errors(function() jonesy.init("abc") end)
  end)
end)

describe("inits", function()
   it("Should return a table consisting of every init of every subtable", function()
      assert.are.same(jonesy.inits(t1), {{1,2,3},{1,2},{1},{}})
   end)

   it("Should return a table consisting of 1 empty table when given an empty table", function()
      assert.are.same(jonesy.inits({}), {{}})
   end)

   it("Should error if given anything other than a table", function()
      assert.has.errors(function() jonesy.inits(1) end)
   end)
end)


describe("map", function()
   it("Should result in the supplied table if mapped with id", function()
      assert.are.same(jonesy.map(id, t1), t1)
   end)

   it("Should map a function over a supplied table", function()
      assert.are.same(jonesy.map(inc, t1), {2,3,4})
   end)

   it("Should return empty table if supplied empty table in most cases", function()
      assert.are.same(jonesy.map(inc, t2), {})
   end)

   it("Should handle multiple tables", function()
      assert.are.same(jonesy.map(add, t1, t1), {2, 4, 6})
   end)

   it("Should size the input portions to the smallest length table", function()
      assert.are.same(jonesy.map(add, t1, {1,2,3,4,5,6}), {2,4,6})
   end)
end)

describe("compose", function()
   it("Should compose two functions", function()
      assert.are.equal(jonesy.compose(sq, inc)(2), sq(inc(2)))
   end)
end)

describe("array_append", function()
   it("Should be the identity on a single table", function()
      assert.are.same(jonesy.array_append(t1), t1)
   end)

   it("Should join two tables", function()
      assert.are.same(jonesy.array_append(t1, t3), {1,2,3,4,5,6})
   end)

   it("Should join multiple tables", function()
      assert.are.same(jonesy.array_append(t1,t3,t1,t2),
                      {1,2,3,4,5,6,1,2,3})
   end)
end)

describe("add", function()
   it("Should be identity for 1 number", function()
      assert.are.equal(jonesy.add(1), 1)
   end)

   it("Should be identity for a number and 0", function()
      assert.are.equal(jonesy.add(1,0), 1)
   end)

   it("Should add multiple numbers together", function()
      assert.are.equal(jonesy.add(1,2,3), 6)
   end)
end)

describe("div", function()
   it("Should be identity for 1 number", function()
      assert.are.equal(jonesy.div(1), 1)
   end)

   it("Should be identity for a number and 1", function()
      assert.are.equal(jonesy.div(42,1), 42)
   end)

   it("Should add multiple numbers together", function()
      assert.are.equal(jonesy.div(12,2,3), 2)
   end)

   it("Should not allow 0 to be anything other than the first argument", function()
         assert.has.errors(function() jonesy.div(1,0) end)
         assert.are.equal(jonesy.div(0,1), 0)
   end)
end)


describe("sub", function()
   it("Should be identity for 1 number", function()
      assert.are.equal(jonesy.sub(1), 1)
   end)

   it("Should be identity for a number and 0", function()
      assert.are.equal(jonesy.sub(1,0), 1)
   end)

   it("Should sub multiple numbers together", function()
      assert.are.equal(jonesy.sub(1,2,3), -4)
   end)
end)

describe("mul", function()
   it("Should be identity for 1 number", function()
      assert.are.equal(jonesy.mul(1), 1)
   end)

   it("Should be identity for a number and 1", function()
      assert.are.equal(jonesy.mul(42,1), 42)
   end)

   it("Should add multiple numbers together", function()
      assert.are.equal(jonesy.mul(1,2,3), 6)
   end)
end)
