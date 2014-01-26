local BaseClass = {}
BaseClass.__index = BaseClass

function BaseClass:new(...)
  local obj = {...}
  obj.__gc = newproxy(true)
  getmetatable(obj.__gc).__gc = self.__del
  setmetatable(obj, self)
  return obj
end

function BaseClass:super(name)
  local class = self.__index
  if not class then
    class = getmetatable(self).__index
  end

  local superClass = getmetatable(class).__index
  local val = superClass[name]
  if type(val) == 'function' then
    return function(...)
      return val(self, ...)
    end
  end
  return val
end


function class(className)
  return function(superClass)
    superClass = superClass or BaseClass
    return function(class)
      _G[className] = class
      class.__name = className
      class.__index = class
      setmetatable(class, superClass)
    end
  end
end


class "A"(){
  a = 0,
  b = 0,
  echo = function(self)
    print(self.a, self.b, self.c)
  end,
  __call = function(self)
    print(self.a, self.b)
  end,
  print_name = function(self)
    print('A')
  end,
}

class "B"(A) {
  b=3,
  c=2,
  print_name = function(self)
    print('B')
  end,
}

local a = B:new()
a.a=1
a.b=2
B:new():echo()
a:echo()
-- B:new()()
--a()
a:print_name()
a:super('print_name')()
print(a:super('b'))
