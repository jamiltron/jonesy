--- jonesy.lua
-- Functional programming in Lua
-- @author Justin Hamilton
-- @copyright Justin Hamilton, 2012 (see LICENSE for more info)
module(..., package.seeall);
require 'table'

local function non_empty(t, name)
   if (type(t) ~= "table" or empty(t)) then
      error(name.." requires a non-empty table")
   end
end

--- Segments a collection of tables into column-grouped tables.
-- Given tables t1, t2, ..., tn return {{t1[1], t2[1], ...,
-- tn[1]}, {t1[2], t2[2], ..., tn[2]}, ... {t1[n], t2[n], ...,
-- tn[n]}}
-- @param ... tables
-- @return transpose of all tables as if each were a row in a matrix
function transpose_tables(...)
   local arr = {}
   local i = 1
   
   while true do
      local col = {}
      local add = true
      
      for j,t in ipairs(arg) do
         if (type(t) ~= "table") then
            error("each argument to transpose_tables must be a table")
         end
         
         if t[i] == nil then
            add = false
            break
         else 
            col[#col + 1] = t[i]
         end
      end
      if #col == 0 then
         return arr
      else
         if add == true then
            arr[#arr + 1] = col
         else
            add = true
         end
         i = i + 1
      end
   end
   return arr
end

--- Maps a function over supplied tables.
-- Given a function f and a table t, return the
-- resulting table of {f(t[1]), f(t[2]), ..., f(t[n])}.
-- @param f function to be used in mapping
-- @param ... any number of tables to be mapped over
-- @return a new table from the resulting mapping
function map(f, ...)
   local new_arr = {}
   local col = transpose_tables(...)

   for i,v in ipairs(col) do
      new_arr[i] = f(unpack(v))
   end
   return new_arr
end

--- Left fold of a function over a table with an initial value.
-- Continuously fold a function with a value and a successive element
-- from a table until yielding a final result.
-- @param f function to be used in the fold
-- @param init initial value to be used as first argument of f
-- @param t table to be folded
-- @return the final fold of f over the initial value and each
-- successive element of t
function foldl(f, init, t)
   if(type(col) ~= "table") then
      error("foldl requires a function, initial value, and table")
   end
   
   for i,v in ipairs(t) do
      init = f(init,v)
   end
   return init
end


--- Right fold of a function over a table with an initial value.
-- Continuously fold a function with a value and a successive element
-- from a table until yielding a final result.
-- @param f function to be used in the fold
-- @param init initial value to be used as first argument of f
-- @param t table to be folded
-- @return the final fold of f over the initial value and each
-- successive element of t
function foldr(f, init, t)
   assert(type(col) == "table")

   for i=#col, 1, -1 do
      init = f(init, t[i])
   end
   return init
end

--- Replicate a value count times.
-- Return a table consisting of count-many instances of value.
-- @param count the number of times to replicate a value
-- @param value the value to be replicated
-- @return a table consiting of count-many instances of value
function replicate(count, value)
   local col = {}

   for i=1,count do
      col[i] = value
   end
   return col
end

--- Tests if a table is empty or not.
-- Checks if Lua thinks there is at least one element in the table.
-- @param t table to be checked
-- @return true if the table has no elements, true otherwise
function empty(t)
   if (type(t) ~= "table") then
      error("empty requires a table")
   end
   return #t < 1
end

--- Get the first element of a table.
-- Returns the first element of a table.
-- @param t table to process
-- @return first element of t
function head(t)
   non_empty(t, "head")
   
   return t[1]
end

--- Get the last element of a table.
-- Returns the last element of a table.
-- @param t table to process
-- @return last element of t
function last(t)
   non_empty(t, "last")
   
   return t[#t]
end

--- Get every element of a table but the head.
-- Returns every element of a table but the first.
-- @param t table to process
-- @return a table consisting of every element in t but the head.
function tail(t)
   non_empty(t, "tail")
   local new_t = {}

   for i=2, #t do
      new_t[i-1] = t[i]
   end

   return new_t
end

--- Get every element of a table but the last.
-- Returns every element of a table but the last.
-- @param t table to process
-- @return a table consisting of every element in t but the last
function init(t)
   non_empty(t, "init")
   local new_t = {}

   for i=1, #t - 1 do
      new_t[i] = t[i]
   end

   return new_t
end

--- Get a table consisting of every init of every subtable.
-- {1,2,3} yields {{1,2,3},{1,2},{1},{}}
-- @param t table to process
-- @return a table consisting of the init of every subtable
function inits(t)
   if (type(t) ~= "table") then
      error("inits requires a table")
   end

   local new_t = {}
   local cur_t = t
   new_t[#new_t + 1] = cur_t

   while (#cur_t > 0) do
      cur_t = init(cur_t)
      new_t[#new_t + 1] = cur_t
   end
   return new_t
end

--- Get a table consisting of every tail of every subtable.
-- {1,2,3} yields {{1,2,3},{1,2},{1},{}}
-- @param t table to process
-- @return a table consisting of the tail of every subtable
function tails(t)
   if (type(t) ~= "table") then
      error("inits requires a table")
   end

   local new_t = {}
   local cur_t = t
   new_t[#new_t + 1] = cur_t

   while (#cur_t > 0) do
      cur_t = tail(cur_t)
      new_t[#new_t + 1] = cur_t
   end
   return new_t
end

--- Compose two functions
-- compose(f,g) is f(g(...))
-- @param f function to compose
-- @param g function to compose
-- @return the composition of both functions
function compose(f,g)
   return function(...) return f(g(...)) end
end
