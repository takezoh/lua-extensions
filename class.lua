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


-- function class(className)
  -- return function(superClass)
function class(superClass)
    superClass = superClass or BaseClass
    return function(class)
      -- _G[className] = class
      class.__name = className
      class.__index = class
      setmetatable(class, superClass)
      return class
    end
  -- end
end
